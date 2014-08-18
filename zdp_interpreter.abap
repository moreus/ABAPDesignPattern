*&---------------------------------------------------------------------*
*& Report  ZDP_INTERPRETER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_interpreter.
CLASS context DEFINITION DEFERRED.

CLASS abstract_expression DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      interpret ABSTRACT IMPORTING io_context TYPE REF TO context.
ENDCLASS.

CLASS context DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_input TYPE string
      , get_input RETURNING VALUE(rv_input) TYPE string
      , set_input IMPORTING iv_input TYPE string
      , get_output RETURNING VALUE(rv_output) TYPE string
      , set_output IMPORTING iv_output TYPE string.
  PRIVATE SECTION.
    DATA: mv_input TYPE string
          , mv_output TYPE i.
ENDCLASS.

CLASS context IMPLEMENTATION.
  METHOD constructor.
    me->mv_input = iv_input.
  ENDMETHOD.
  METHOD get_input.
    rv_input = me->mv_input.
  ENDMETHOD.
  METHOD set_input.
    me->mv_input = iv_input.
  ENDMETHOD.
  METHOD get_output.
    rv_output = me->mv_output.
  ENDMETHOD.
  METHOD set_output.
    me->mv_output = iv_output.
  ENDMETHOD.
ENDCLASS.

CLASS plus_expression DEFINITION INHERITING FROM abstract_expression.
  PUBLIC SECTION.
    METHODS:
    interpret REDEFINITION.
ENDCLASS.

CLASS plus_expression IMPLEMENTATION.
  METHOD interpret.
    WRITE: / 'PlusExpression++'.
    DATA: input TYPE string.
    input = io_context->get_input( ).

  ENDMETHOD.
ENDCLASS.


CLASS minus_expression DEFINITION INHERITING FROM abstract_expression.
  PUBLIC SECTION.
    METHODS:
    interpret REDEFINITION.
ENDCLASS.

CLASS minus_expression IMPLEMENTATION.
  METHOD interpret.
    WRITE: / 'MinusExpression--'.
    DATA: input TYPE string.
    input = io_context->get_input( ).
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD main.
    DATA: inputexpr TYPE string.
    inputexpr = '10'.

    DATA: context TYPE REF TO context.
    CREATE OBJECT context EXPORTING iv_input = inputexpr.

    DATA: list TYPE STANDARD TABLE OF REF TO abstract_expression.

    APPEND NEW plus_expression( ) TO list.
    APPEND NEW plus_expression( ) TO list.

    APPEND NEW minus_expression( ) TO list.
    APPEND NEW minus_expression( ) TO list.
    APPEND NEW minus_expression( ) TO list.

    FIELD-SYMBOLS <fs> TYPE REF TO abstract_expression.

    LOOP AT list ASSIGNING <fs>.
      <fs>->interpret( context ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  mainapp=>main( ).