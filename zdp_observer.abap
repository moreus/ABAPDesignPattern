*&---------------------------------------------------------------------*
*& Report  ZDP_OBSERVER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
PROGRAM zdp_observer.


CLASS main_process DEFINITION.
  PUBLIC SECTION.
    METHODS: set_state IMPORTING iv_state TYPE char1.
    EVENTS: state_changed EXPORTING VALUE(new_state) TYPE char1.
  PRIVATE SECTION.
    DATA: current_state TYPE char1.
ENDCLASS.

CLASS main_process IMPLEMENTATION.
  METHOD set_state.
    current_state = iv_state.
    SKIP 2.
    WRITE: / 'Main Process new state', current_state.
    RAISE EVENT state_changed EXPORTING new_state = current_state.
  ENDMETHOD.
ENDCLASS.

CLASS myfunction DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: on_state_changed ABSTRACT
                  FOR EVENT state_changed OF main_process
      IMPORTING new_state.
ENDCLASS.

CLASS myalv DEFINITION INHERITING FROM myfunction.
  PUBLIC SECTION.
    METHODS: on_state_changed REDEFINITION.
ENDCLASS.


CLASS myalv IMPLEMENTATION.
  METHOD on_state_changed.
    WRITE: / 'New state in ALV processing', new_state.
  ENDMETHOD.
ENDCLASS.

CLASS mydb DEFINITION INHERITING FROM myfunction.
  PUBLIC SECTION.
    METHODS: on_state_changed REDEFINITION.
ENDCLASS.

CLASS mydb IMPLEMENTATION.
  METHOD on_state_changed.
    WRITE: / 'New State in DB processing', new_state.
  ENDMETHOD.
ENDCLASS.

CLASS main_app DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: run.
ENDCLASS.

CLASS main_app  IMPLEMENTATION.
  METHOD run.
    DATA: lo_process TYPE REF TO main_process.
    DATA: lo_alv TYPE REF TO myalv.
    DATA: lo_db TYPE REF TO mydb.

    CREATE OBJECT lo_process.
    CREATE OBJECT: lo_alv, lo_db.

    SET HANDLER lo_alv->on_state_changed FOR lo_process.
    SET HANDLER lo_db->on_state_changed FOR lo_process.

    lo_process->set_state( 'A' ).
    lo_process->set_state( 'B' ).
    lo_process->set_state( 'C' ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  main_app=>run( ).