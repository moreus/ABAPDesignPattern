*&---------------------------------------------------------------------*
*& Report  ZDP_STATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_state.

CLASS context DEFINITION DEFERRED.
CLASS cl_abap_typedescr DEFINITION LOAD.

DATA: moff TYPE i
      , slen TYPE i
      , mlen TYPE i.

DEFINE get_clazz_name.
  &2 = cl_abap_classdescr=>get_class_name( &1 ).
  FIND REGEX 'CLASS=' IN &2 MATCH OFFSET moff match LENGTH mlen.
  slen = moff + mlen.
  SHIFT &2 BY slen PLACES LEFT.
END-OF-DEFINITION.

CLASS state DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      handle ABSTRACT IMPORTING io_context TYPE REF TO context.
ENDCLASS.

CLASS context DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING io_state TYPE REF TO state,
      request.
    DATA: mo_state TYPE REF TO state.
ENDCLASS.

CLASS context IMPLEMENTATION.
  METHOD constructor.
    me->mo_state = io_state.
  ENDMETHOD.

  METHOD request.
    me->mo_state->handle( io_context = me ).
  ENDMETHOD.
ENDCLASS.

CLASS concrete_statea DEFINITION INHERITING FROM state.
  PUBLIC SECTION.
    METHODS:
      handle REDEFINITION.
ENDCLASS.

CLASS concrete_stateb DEFINITION INHERITING FROM state.
  PUBLIC SECTION.
    METHODS:
      handle REDEFINITION.
ENDCLASS.

CLASS concrete_statea IMPLEMENTATION.
  METHOD handle.
    DATA: stateb TYPE REF TO state.
    DATA: class_name TYPE abap_abstypename.
    CREATE OBJECT stateb TYPE concrete_stateb.
    io_context->mo_state = stateb.
    get_clazz_name stateb class_name.
    WRITE: / 'State:', class_name.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_stateb IMPLEMENTATION.
  METHOD handle.
    DATA: statea TYPE REF TO state.
    DATA: class_name TYPE abap_abstypename.
    CREATE OBJECT statea TYPE concrete_statea.
    io_context->mo_state = statea.
    get_clazz_name statea class_name.
    WRITE: / 'State:', class_name.
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD: main.
    DATA: context TYPE REF TO context.
    DATA: state TYPE REF TO concrete_statea.
    CREATE OBJECT state.
    CREATE OBJECT context EXPORTING io_state = state.

    context->request( ).
    context->request( ).
    context->request( ).
    context->request( ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  mainapp=>main(  ).