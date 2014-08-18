*&---------------------------------------------------------------------*
*& Report  ZDP_PROXY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_proxy.


INTERFACE lif_data.
  DATA: t_t100 TYPE tt_t100.
  METHODS: get_data IMPORTING iv_spras TYPE spras OPTIONAL
                    CHANGING  ct_data  TYPE tt_t100.
  METHODS: write_data.
ENDINTERFACE.

CLASS lcl_proxy_data DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_data.
  PRIVATE SECTION.
    DATA: o_t100_data TYPE REF TO lif_data.
ENDCLASS.

CLASS lcl_t100_data DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_data.
ENDCLASS.

CLASS lcl_proxy_data IMPLEMENTATION.
  METHOD lif_data~get_data.
    IF iv_spras NE sy-langu.
      EXIT.
    ENDIF.

    CREATE OBJECT o_t100_data TYPE lcl_t100_data.
    o_t100_data->get_data(
      EXPORTING
        iv_spras = iv_spras
        CHANGING
          ct_data = ct_data
    ).
  ENDMETHOD.

  METHOD lif_data~write_data.
    IF o_t100_data IS NOT BOUND.
      WRITE: / 'No data to display'.
    ELSE.
      o_t100_data->write_data( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_t100_data IMPLEMENTATION.
  METHOD lif_data~get_data.
    SELECT * FROM t100 INTO TABLE lif_data~t_t100
      UP TO 200000000 ROWS WHERE sprsl = iv_spras.
    ct_data = lif_data~t_t100.
  ENDMETHOD.

  METHOD lif_data~write_data.
    DATA: lv_lines TYPE i.
    lv_lines = lines( lif_data~t_t100 ).
    WRITE: / 'Total lines', lv_lines.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_main_app DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:run.
ENDCLASS.

CLASS lcl_main_app IMPLEMENTATION.
  METHOD run.
    DATA: lo_proxy TYPE REF TO lif_data.
    DATA: lt_data TYPE tt_t100.

    CREATE OBJECT lo_proxy TYPE lcl_proxy_data.
    lo_proxy->get_data(
      EXPORTING
        iv_spras = 'E'
      CHANGING
        ct_data  = lt_data
      ).

    lo_proxy->write_data( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
lcl_main_app=>run( ).