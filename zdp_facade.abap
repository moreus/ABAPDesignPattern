*&---------------------------------------------------------------------*
*& Report  ZDP_FACADE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_facade.

CLASS lcl_data DEFINITION.
  PUBLIC SECTION.
  METHODS: constructor.
ENDCLASS.

INTERFACE lif_write.
  METHODS: write_data.
ENDINTERFACE.

CLASS lcl_write_alv DEFINITION.
  PUBLIC SECTION.
  INTERFACES: lif_write.
ENDCLASS.

CLASS lcl_write_log DEFINITION.
  PUBLIC SECTION.
  INTERFACES: lif_write.
ENDCLASS.

CLASS lcl_facade DEFINITION.
  PUBLIC SECTION.
  METHODS: process_report IMPORTING iv_write_type TYPE char1.
ENDCLASS.

CLASS lcl_data IMPLEMENTATION.
  METHOD constructor.
    WRITE: / 'Getting Data'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_write_alv IMPLEMENTATION.
  METHOD lif_write~write_data.
    WRITE: / 'Writing data in ALV'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_write_log IMPLEMENTATION.
  METHOD lif_write~write_data.
    WRITE: / 'Wring data in Log'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_facade IMPLEMENTATION.
  METHOD process_report.
    DATA: lo_data TYPE REF TO lcl_data.
    CREATE OBJECT lo_data.

    DATA: lo_write TYPE REF TO lif_write.
    IF iv_write_type = 'A'.
      CREATE OBJECT lo_write TYPE lcl_write_alv.
    ELSE.
      CREATE OBJECT lo_write TYPE lcl_write_log.
    ENDIF.
    lo_write->write_data( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
DATA: lo_facade TYPE REF TO lcl_facade.
CREATE OBJECT lo_facade.
lo_facade->process_report( iv_write_type = 'A' ).