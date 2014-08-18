*&---------------------------------------------------------------------*
*& Report  ZDP_COMPOSITE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_composite.

CLASS lcl_shape DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_name TYPE string,
      add ABSTRACT IMPORTING io_shape TYPE REF TO lcl_shape,
      remove ABSTRACT IMPORTING io_shape TYPE REF TO lcl_shape,
      display ABSTRACT IMPORTING indent TYPE i.
  PROTECTED SECTION.
    DATA: v_name TYPE string.
ENDCLASS.

CLASS lcl_shape IMPLEMENTATION.
  METHOD constructor.
    me->v_name = iv_name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_line DEFINITION INHERITING FROM lcl_shape.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_name TYPE string.
    METHODS: add REDEFINITION,
      remove REDEFINITION,
      display REDEFINITION.
ENDCLASS.

CLASS lcl_line IMPLEMENTATION.
  METHOD constructor.
    super->constructor( iv_name ).
  ENDMETHOD.

  METHOD add.
    WRITE: / 'Can not add'.
  ENDMETHOD.

  METHOD remove.
    WRITE: / 'Can not delete'.
  ENDMETHOD.

  METHOD display.
    WRITE: / ''.
    DO indent TIMES.
      WRITE: '-'.
    ENDDO.

    WRITE: v_name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_picture DEFINITION INHERITING FROM lcl_shape.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_name TYPE string.
    METHODS: add REDEFINITION,
      remove REDEFINITION,
      display REDEFINITION.

  PRIVATE SECTION.
    TYPES: BEGIN OF lty_shapes,
             o_shape TYPE REF TO lcl_shape,
           END OF lty_shapes.
    DATA: li_shapes TYPE STANDARD TABLE OF REF TO lcl_shape.
ENDCLASS.

CLASS lcl_picture IMPLEMENTATION.
  METHOD constructor.
    super->constructor( iv_name ).
  ENDMETHOD.

  METHOD add.
    APPEND io_shape TO  li_shapes.
  ENDMETHOD.

  METHOD remove.
    DELETE li_shapes WHERE table_line EQ io_shape.
  ENDMETHOD.

  METHOD display.
    DATA: lo_shape TYPE REF TO lcl_shape.
    WRITE: / ''.
    DO indent TIMES.
      WRITE: (2) '-'.
    ENDDO.
    WRITE:  v_name.
    DATA: lv_indent TYPE i.
    lv_indent = indent + 1.
    LOOP AT li_shapes INTO lo_shape.
      lo_shape->display( lv_indent ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: run.
ENDCLASS.
*
CLASS lcl_main IMPLEMENTATION.
  METHOD run.

    DATA: lo_pic   TYPE REF TO lcl_shape.
    DATA: lo_shape TYPE REF TO lcl_shape.

    CREATE OBJECT lo_pic TYPE lcl_picture EXPORTING iv_name = 'Picture'.
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Left Line'.
    lo_pic->add( lo_shape ).
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Top Line'.
    lo_pic->add( lo_shape ).
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Right Line'.
    lo_pic->add( lo_shape ).
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Bottom Line'.
    lo_pic->add( lo_shape ).

    DATA: lo_pic2 TYPE REF TO lcl_shape.
    CREATE OBJECT lo_pic2 TYPE lcl_picture EXPORTING iv_name = 'Picture 2'.
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Left Line'.
    lo_pic2->add( lo_shape ).
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Top Line'.
    lo_pic2->add( lo_shape ).
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Right Line'.
    lo_pic2->add( lo_shape ).
    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'Bottom Line'.
    lo_pic2->add( lo_shape ).
    lo_pic->add( lo_pic2 ).

    CREATE OBJECT lo_shape TYPE lcl_line EXPORTING iv_name = 'text'.
    lo_pic->add( lo_shape ).

*   Uniform way to access the composition - it could be a primitive object
*   or composition itself.
    lo_pic->display( 4 ).

  ENDMETHOD.
ENDCLASS.
*
START-OF-SELECTION.
  lcl_main=>run( ).