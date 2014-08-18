*&---------------------------------------------------------------------*
*& Report  ZDP_BRIDGE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_bridge.
CLASS abstract_car DEFINITION DEFERRED.
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

CLASS abstract_road DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      set_car IMPORTING io_car TYPE REF TO abstract_car,
      run ABSTRACT.
  PROTECTED SECTION.
    DATA: mo_car TYPE REF TO abstract_car.
ENDCLASS.

CLASS abstract_road IMPLEMENTATION.
  METHOD set_car.
    me->mo_car = io_car.
    DATA: name TYPE string.
    get_clazz_name me->mo_car name.
    WRITE: / name.
  ENDMETHOD.
ENDCLASS.

CLASS abstract_car DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      run ABSTRACT.
ENDCLASS.

CLASS speed_way DEFINITION INHERITING FROM abstract_road.
  PUBLIC SECTION.
    METHODS:
      run REDEFINITION.
ENDCLASS.

CLASS speed_way IMPLEMENTATION.
  METHOD run.
    WRITE: ' run on the speed way.'.
    me->mo_car->run(  ).
  ENDMETHOD.
ENDCLASS.

CLASS street DEFINITION INHERITING FROM abstract_road.
  PUBLIC SECTION.
    METHODS:
    run REDEFINITION.
ENDCLASS.

CLASS street IMPLEMENTATION.
  METHOD run.
    WRITE: ' run on the streen.'.
    me->mo_car->run(  ).
  ENDMETHOD.
ENDCLASS.

CLASS car DEFINITION INHERITING FROM abstract_car.
  PUBLIC SECTION.
    METHODS:
      run REDEFINITION.
ENDCLASS.

CLASS car IMPLEMENTATION.
  METHOD run.
    WRITE: / 'this is car runing on '.
  ENDMETHOD.
ENDCLASS.

CLASS bus DEFINITION INHERITING FROM abstract_car.
  PUBLIC SECTION.
    METHODS:
      run REDEFINITION.
ENDCLASS.

CLASS bus IMPLEMENTATION.
  METHOD run.
    WRITE: / 'this is bus running on '.
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD main.
    DATA: road1 TYPE REF TO speed_way
          , road2 TYPE REF TO street.
    CREATE OBJECT road1.
    CREATE OBJECT road2.

    road1->set_car( NEW car( ) ).
    road1->run( ).
    road2->set_car( NEW bus( ) ).
    road2->run( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  mainapp=>main( ).