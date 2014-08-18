*&---------------------------------------------------------------------*
*& Report  ZDP_FACTORYMETHOD2
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_factorymethod2 NO STANDARD PAGE HEADING LINE-SIZE 80.

CLASS cl_abap_typedescr DEFINITION LOAD.

DATA: moff TYPE i
      , slen TYPE i
      , mlen TYPE i.

DEFINE get_clazz_name.
  &2 = cl_abap_classdescr=>get_class_name( &1 ).
  find REGEX 'CLASS=' in &2 MATCH OFFSET moff MATCH LENGTH mlen.
  slen = moff + mlen.
  SHIFT &2 by slen PLACES LEFT.
END-OF-DEFINITION.

INTERFACE product.
  TYPES ty_productname(30) TYPE c.
  DATA: name TYPE ty_productname.

  METHODS:
    get_name RETURNING VALUE(name) TYPE  ty_productname.
ENDINTERFACE.

CLASS concrete_producta DEFINITION.
  PUBLIC SECTION.
    INTERFACES:
      product.
ENDCLASS.

CLASS concrete_producta IMPLEMENTATION.
  METHOD product~get_name.
    name = 'ConcreteProductA'.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_productb DEFINITION.
  PUBLIC SECTION.
    INTERFACES:
      product.
ENDCLASS.

CLASS concrete_productb IMPLEMENTATION.
  METHOD product~get_name.
    name = 'ConCreteProductB'.
  ENDMETHOD.
ENDCLASS.

INTERFACE creator.
  METHODS:
    factorymethod RETURNING VALUE(product) TYPE REF TO product.
ENDINTERFACE.

CLASS concrete_creatora DEFINITION.
  PUBLIC SECTION.
    INTERFACES:
      creator.
ENDCLASS.

CLASS concrete_creatora IMPLEMENTATION.
  METHOD creator~factorymethod.
    CREATE OBJECT product TYPE concrete_producta.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_creatorb DEFINITION.
  PUBLIC SECTION.
    INTERFACES:
      creator.
ENDCLASS.

CLASS concrete_creatorb IMPLEMENTATION.
  METHOD creator~factorymethod.
    CREATE OBJECT product TYPE concrete_productb.
  ENDMETHOD.
ENDCLASS.

CLASS main_app DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: oa_creator_coll TYPE TABLE OF REF TO creator.
    CLASS-METHODS: main.
ENDCLASS.

CLASS main_app IMPLEMENTATION.
  METHOD main.

    DATA: concrete_creatora  TYPE REF TO concrete_creatora
          , concrete_creatorb TYPE REF TO concrete_creatorb
          , product TYPE REF TO product
          , product_name(30) TYPE c
          , class_name TYPE abap_abstypename.

    FIELD-SYMBOLS <fs> TYPE REF TO creator.

    CREATE OBJECT concrete_creatora.
    APPEND concrete_creatora TO oa_creator_coll.

    CREATE OBJECT concrete_creatorb.
    APPEND concrete_creatorb TO oa_creator_coll.

    LOOP AT oa_creator_coll ASSIGNING <fs>.
      get_clazz_name <fs> class_name.
      CASE class_name.
        WHEN 'CONCRETE_CREATORA'.
          WRITE: / 'ConcreteCreatorA Creates Product A'.
        WHEN 'CONCRETE_CREATORB'.
          WRITE: / 'ConcreteCreatorB Creates Product B'.
      ENDCASE.

      product = <fs>->factorymethod( ).
      get_clazz_name product class_name.
      product_name = product->get_name( ).
      WRITE: / 'Class=', class_name, 'Product=', product_name.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  main_app=>main( ).