*&---------------------------------------------------------------------*
*& Report  ZDP_STRATEGY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_strategy.


INTERFACE strategy.
  METHODS: algorithm.
ENDINTERFACE.

CLASS concrete_strategya DEFINITION.
  PUBLIC SECTION.
    INTERFACES: strategy.
ENDCLASS.

CLASS concrete_strategya IMPLEMENTATION.
  METHOD strategy~algorithm.
    WRITE: / 'Called Concreate Strategy A Algorithm Interface.'.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_strategyb DEFINITION.
  PUBLIC SECTION.
    INTERFACES: strategy.
ENDCLASS.

CLASS concrete_strategyb IMPLEMENTATION.
  METHOD strategy~algorithm.
    WRITE: / 'Called Concreate Strategy B Algorithm Interface.'.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_strategyc DEFINITION.
  PUBLIC SECTION.
    INTERFACES: strategy.
ENDCLASS.

CLASS concrete_strategyc IMPLEMENTATION.
  METHOD strategy~algorithm.
    WRITE: / 'Called Concreate Strategy C Algorithm Interface.'.
  ENDMETHOD.
ENDCLASS.

CLASS context DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING io_instance TYPE REF TO strategy
      , context_interface.
  PRIVATE SECTION.
    DATA: mstrategy TYPE REF TO strategy.
ENDCLASS.

CLASS context IMPLEMENTATION.
  METHOD constructor.
    mstrategy = io_instance.
  ENDMETHOD.

  METHOD context_interface.
    me->mstrategy->algorithm( ).
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD main.
    DATA: o_context TYPE REF TO context.
    DATA: o_strategy TYPE REF TO strategy.

    CREATE OBJECT o_strategy TYPE concrete_strategya.
    CREATE OBJECT o_context EXPORTING io_instance = o_strategy.
    o_context->context_interface( ).

    CREATE OBJECT o_strategy TYPE concrete_strategyb.
    CREATE OBJECT o_context EXPORTING io_instance = o_strategy.
    o_context->context_interface( ).

    CREATE OBJECT o_strategy TYPE concrete_strategyc.
    CREATE OBJECT o_context EXPORTING io_instance = o_strategy.
    o_context->context_interface( ).

  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
mainapp=>main( ).