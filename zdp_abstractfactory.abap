*&---------------------------------------------------------------------*
*& Report  ZDP_ABSTRACTFACTORY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_abstractfactory.


CLASS abs_data DEFINITION ABSTRACT.
  PUBLIC SECTION.
  METHODS: read_data ABSTRACT.
ENDCLASS.

CLASS data_from_file DEFINITION INHERITING FROM abs_data.
  PUBLIC SECTION.
  METHODS: read_data REDEFINITION.
ENDCLASS.


CLASS data_from_file IMPLEMENTATION.
  METHOD read_data.
    WRITE: / 'Reading data from file'.
  ENDMETHOD.
ENDCLASS.

CLASS data_from_db DEFINITION INHERITING FROM abs_data.
  PUBLIC SECTION.
  METHODS: read_data REDEFINITION.
ENDCLASS.

CLASS data_from_db IMPLEMENTATION.
  METHOD read_data.
    WRITE: / 'Reading data from Database Table'.
  ENDMETHOD.
ENDCLASS.

CLASS abs_print DEFINITION ABSTRACT.
  PUBLIC SECTION.
  METHODS: write_data ABSTRACT.
ENDCLASS.

CLASS print_alv DEFINITION INHERITING FROM abs_print.
  PUBLIC SECTION.
  METHODS: write_data REDEFINITION.
ENDCLASS.

CLASS print_alv IMPLEMENTATION.
  METHOD write_data.
    WRITE: / 'Writing data into ALV'.
  ENDMETHOD.
ENDCLASS.

CLASS print_simple DEFINITION INHERITING FROM abs_print.
  PUBLIC SECTION.
  METHODS: write_data REDEFINITION.
ENDCLASS.


CLASS print_simple IMPLEMENTATION.
  METHOD write_data.
    WRITE: / 'Writing data in classic - This is actually classic'.
  ENDMETHOD.
ENDCLASS.

CLASS REPORT DEFINITION ABSTRACT.
  PUBLIC SECTION.
  METHODS: get_data ABSTRACT,
  print_data ABSTRACT.
ENDCLASS.


CLASS simple_report DEFINITION INHERITING FROM REPORT.
  PUBLIC SECTION.
  METHODS: get_data REDEFINITION.
  METHODS: print_data REDEFINITION.
ENDCLASS.

CLASS simple_report IMPLEMENTATION.
  METHOD get_data.
    DATA: lo_data TYPE REF TO data_from_file.
    CREATE OBJECT lo_data.
    lo_data->read_data( ).
  ENDMETHOD.

  METHOD print_data.
    DATA: lo_print TYPE REF TO print_simple.
    CREATE OBJECT lo_print.
    lo_print->write_data( ).
  ENDMETHOD.
ENDCLASS.

CLASS complex_report DEFINITION INHERITING FROM REPORT.
  PUBLIC SECTION.
  METHODS: get_data REDEFINITION.
  METHODS: print_data REDEFINITION.
ENDCLASS.

CLASS complex_report IMPLEMENTATION.
  METHOD get_data.
    DATA: lo_data TYPE REF TO data_from_db.
    CREATE OBJECT lo_data.
    lo_data->read_data( ).
  ENDMETHOD.

  METHOD print_data.
    DATA: lo_print TYPE REF TO print_alv.
    CREATE OBJECT lo_print.
    lo_print->write_data( ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_main_app DEFINITION.
  PUBLIC SECTION.
  CLASS-METHODS: RUN.
ENDCLASS.

CLASS lcl_main_app IMPLEMENTATION.
  METHOD RUN.
    DATA: lo_report TYPE REF TO REPORT.
    CREATE OBJECT lo_report TYPE simple_report.
    lo_report->get_data( ).
    lo_report->print_data( ).

    CREATE OBJECT lo_report TYPE complex_report.
    lo_report->get_data( ).
    lo_report->print_data( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
lcl_main_app=>run( ).