*&---------------------------------------------------------------------*
*& Report  ZDP_SINGLETON
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_singleton.


CLASS lcl_application DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS:
      get_instance
        RETURNING VALUE(ro_instance) TYPE REF TO lcl_application.

    METHODS:
      set_name IMPORTING iv_name TYPE char30,
      get_name RETURNING VALUE(rv_name) TYPE char30.

  PRIVATE SECTION.
    CLASS-DATA: lo_apps TYPE REF TO lcl_application.
    DATA: v_name TYPE char30.
ENDCLASS.

CLASS lcl_application IMPLEMENTATION.
  METHOD get_instance.
    IF lo_apps IS INITIAL.
      CREATE OBJECT lo_apps.
    ENDIF.

    ro_instance = lo_apps.
  ENDMETHOD.

  METHOD set_name.
    me->v_name = iv_name.
  ENDMETHOD.

  METHOD get_name.
    rv_name = me->v_name.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_application TYPE REF TO lcl_application.
  DATA: lv_result TYPE char30.

  WRITE: / 'LO_APPLICATION'.

  lo_application = lcl_application=>get_instance( ).
  lo_application->set_name( ' This is first object' ).

  lv_result = lo_application->get_name( ).
  WRITE: / lv_result.
  CLEAR lv_result.

  DATA: lo_2nd_apps TYPE REF TO lcl_application.
  SKIP 2.
  WRITE: / 'LO_2ND_APPS : '.
  lo_2nd_apps = lcl_application=>get_instance( ).
  lv_result = lo_2nd_apps->get_name( ).
  WRITE: / lv_result.
  CLEAR lv_result.