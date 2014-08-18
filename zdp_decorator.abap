*&---------------------------------------------------------------------*
*& Report  ZDP_DECORATOR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_decorator.


CLASS output DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: process_output ABSTRACT.
ENDCLASS.

CLASS alv_output DEFINITION INHERITING FROM output.
  PUBLIC SECTION.
    METHODS: process_output REDEFINITION.
ENDCLASS.

CLASS alv_output IMPLEMENTATION.
  METHOD process_output.
    WRITE: / 'Standard ALV output'.
  ENDMETHOD.
ENDCLASS.

CLASS op_decorator DEFINITION INHERITING FROM output.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING io_decorator TYPE REF TO output,
      process_output REDEFINITION.
  PRIVATE SECTION.
    DATA: o_decorator TYPE REF TO output.
ENDCLASS.


CLASS op_decorator IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->o_decorator = io_decorator.
  ENDMETHOD.

  METHOD process_output.
    CHECK o_decorator IS BOUND.
    o_decorator->process_output( ).
  ENDMETHOD.
ENDCLASS.

CLASS op_pdf DEFINITION INHERITING FROM op_decorator.
  PUBLIC SECTION.
    METHODS: process_output REDEFINITION.
ENDCLASS.

CLASS op_pdf IMPLEMENTATION.
  METHOD process_output.
    super->process_output( ).
    WRITE: /(10) space, 'Generating PDF'.
  ENDMETHOD.
ENDCLASS.

CLASS op_xls DEFINITION INHERITING FROM op_decorator.
  PUBLIC SECTION.
    METHODS: process_output REDEFINITION.
ENDCLASS.

CLASS op_xls IMPLEMENTATION.
  METHOD process_output.
    super->process_output( ).
    WRITE: /(10) space, 'Generating Excel'.
  ENDMETHOD.
ENDCLASS.

CLASS op_email DEFINITION INHERITING FROM op_decorator.
  PUBLIC SECTION.
    METHODS: process_output REDEFINITION.
ENDCLASS.

CLASS op_email IMPLEMENTATION.
  METHOD process_output.
    super->process_output( ).
    WRITE: /(10) space, 'Sending Email'.
  ENDMETHOD.
ENDCLASS.

CLASS op_alv DEFINITION INHERITING FROM op_decorator.
  PUBLIC SECTION.
    METHODS: process_output REDEFINITION.
ENDCLASS.


CLASS op_alv IMPLEMENTATION.
  METHOD process_output.
    super->process_output( ).
    WRITE: /(10) space, 'Generating ALV'.
  ENDMETHOD.
ENDCLASS.


CLASS main_app DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:run IMPORTING
                        iv_pdf   TYPE flag
                        iv_email TYPE flag
                        iv_xls   TYPE flag.
ENDCLASS.

CLASS main_app IMPLEMENTATION.
  METHOD run.
    DATA: lo_decorator TYPE REF TO output,
          lo_pre       TYPE REF TO output.

    CREATE OBJECT lo_decorator TYPE alv_output.
    lo_pre = lo_decorator.

    IF iv_pdf IS NOT INITIAL.
      CREATE OBJECT lo_decorator
        TYPE op_pdf
        EXPORTING
          io_decorator = lo_pre.
      lo_pre = lo_decorator.
    ENDIF.

    IF iv_email IS NOT INITIAL.
      CREATE OBJECT lo_decorator
        TYPE op_email
        EXPORTING
          io_decorator = lo_pre.
      lo_pre = lo_decorator.
    ENDIF.

    IF iv_xls IS NOT INITIAL.
      CREATE OBJECT lo_decorator
        TYPE op_xls
        EXPORTING
          io_decorator = lo_pre.
      lo_pre = lo_decorator.
    ENDIF.

    lo_decorator->process_output( ).
  ENDMETHOD.
ENDCLASS.

PARAMETERS: p_pdf   AS CHECKBOX,
            p_email AS CHECKBOX,
            p_xls   AS CHECKBOX.

START-OF-SELECTION.
  main_app=>run(
    iv_pdf = p_pdf
    iv_email = p_email
    iv_xls = p_xls
 ).