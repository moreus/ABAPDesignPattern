*&---------------------------------------------------------------------*
*& Report  ZDP_FLYWEIGHT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_flyweight.


CLASS flyweight DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      operation ABSTRACT IMPORTING iv_extrincicstate TYPE i.
ENDCLASS.

CLASS concrete_flyweight DEFINITION INHERITING FROM flyweight.
  PUBLIC SECTION.
    METHODS:
      operation REDEFINITION.
ENDCLASS.

CLASS concrete_flyweight IMPLEMENTATION.
  METHOD operation.
    WRITE: /5(20) 'ConcreteFlyweight', iv_extrincicstate.
  ENDMETHOD.
ENDCLASS.

CLASS unshared_concrete_flyweight DEFINITION INHERITING FROM flyweight.
  PUBLIC SECTION.
    METHODS:
      operation REDEFINITION.
ENDCLASS.

CLASS unshared_concrete_flyweight IMPLEMENTATION.
  METHOD operation.
    WRITE: /5(20) 'Unshared Concrete Flyweight', iv_extrincicstate.
  ENDMETHOD.
ENDCLASS.

CLASS flyweight_factory DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_flyweight,
        key(1) TYPE c
      , value TYPE REF TO concrete_flyweight
      , END OF ty_flyweight.

    METHODS:
      constructor
      , getflyweight IMPORTING iv_key TYPE c
        RETURNING VALUE(ro_value) TYPE REF TO flyweight.

  PRIVATE SECTION.
    DATA flyweights TYPE HASHED TABLE OF ty_flyweight WITH UNIQUE KEY key.
ENDCLASS.

CLASS flyweight_factory IMPLEMENTATION.
  METHOD constructor.
    DATA: cf TYPE REF TO concrete_flyweight
          ,buffer TYPE ty_flyweight .

    CREATE OBJECT cf.
    buffer-key   = 'X'.
    buffer-value = cf.
    INSERT buffer INTO TABLE flyweights.

    CREATE OBJECT cf.
    buffer-key   = 'Y'.
    buffer-value = cf.
    INSERT buffer INTO TABLE flyweights.

    CREATE OBJECT cf.
    buffer-key   = 'Z'.
    buffer-value = cf.
    INSERT buffer INTO TABLE flyweights.
  ENDMETHOD.

  METHOD getflyweight.
    DATA buffer TYPE ty_flyweight.
    READ TABLE flyweights WITH TABLE KEY key = iv_key INTO buffer.
    ro_value = buffer-value.
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      main.
ENDCLASS.

CLASS mainapp  IMPLEMENTATION.
  METHOD main.
    DATA: extrincicstate TYPE i
          ,f TYPE REF TO flyweight_factory
          ,fx TYPE REF TO flyweight
          ,fy TYPE REF TO flyweight
          ,fz TYPE REF TO flyweight
          ,uf TYPE REF TO unshared_concrete_flyweight
          .
    extrincicstate = 22.

    CREATE OBJECT f.
    fx = f->getflyweight( 'X' ).
    SUBTRACT 1 FROM extrincicstate.
    fx->operation( extrincicstate ).

    SUBTRACT 1 FROM extrincicstate.
    fy = f->getflyweight( 'Y' ).
    fy->operation( extrincicstate ).

    SUBTRACT 1 FROM extrincicstate.
    fz = f->getflyweight( 'Z' ).
    fz->operation( extrincicstate ).

    SUBTRACT 1 FROM extrincicstate.
    CREATE OBJECT uf.
    uf->operation( extrincicstate ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  mainapp=>main( ).