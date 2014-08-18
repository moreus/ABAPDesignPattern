*&---------------------------------------------------------------------*
*& Report  ZDP_PROTOTYPE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_prototype.


CLASS prototype DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_id TYPE string
     ,get_id RETURNING VALUE(rv_id) TYPE string
     ,clone ABSTRACT RETURNING VALUE(ro_prototype) TYPE REF TO prototype.

  PRIVATE SECTION.
    DATA: id TYPE string.
ENDCLASS.

CLASS prototype IMPLEMENTATION.
  METHOD constructor.
    me->id = iv_id.
  ENDMETHOD.

  METHOD get_id.
    rv_id = me->id.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_prototype1 DEFINITION INHERITING FROM prototype.
  PUBLIC SECTION.
    METHODS:
      clone REDEFINITION.
ENDCLASS.

CLASS concrete_prototype1 IMPLEMENTATION.
  METHOD clone.
    ro_prototype = me.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_prototype2 DEFINITION INHERITING FROM prototype.
  PUBLIC SECTION.
    METHODS:
      clone REDEFINITION.
ENDCLASS.

CLASS concrete_prototype2 IMPLEMENTATION.
  METHOD clone.
    ro_prototype = me.
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD main.
    DATA: p1 TYPE REF TO concrete_prototype1
          ,c1 TYPE REF TO concrete_prototype1
          , p2 TYPE REF TO concrete_prototype2
          , c2 TYPE REF TO concrete_prototype2
          , id TYPE string.

    FIELD-SYMBOLS <fs> TYPE REF TO prototype.

    CREATE OBJECT p1 EXPORTING iv_id = 'I'.

    c1 ?= p1->clone( ).

    id = c1->get_id( ).
    WRITE: / 'Cloned: {0}', id.

    CREATE OBJECT p2 EXPORTING iv_id = 'II'.
    c2 ?= p2->clone( ).
    id = c2->get_id( ).
    WRITE: / 'Cloned: {0}', id.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  mainapp=>main( ).