*&---------------------------------------------------------------------*
*& Report  ZDP_FACTORYMETHOD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_factorymethod.

CLASS product DEFINITION DEFERRED.
CLASS concrete_producta DEFINITION DEFERRED.
CLASS concrete_productb DEFINITION DEFERRED.

CLASS creator DEFINITION DEFERRED.
CLASS concrete_creatora DEFINITION DEFERRED.
CLASS concrete_creatorb DEFINITION DEFERRED.

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

CLASS product DEFINITION ABSTRACT.
ENDCLASS.

CLASS concrete_producta DEFINITION INHERITING FROM product.
ENDCLASS.

CLASS concrete_productb DEFINITION INHERITING FROM product.
ENDCLASS.

CLASS creator DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      factorymethod ABSTRACT RETURNING VALUE(product) TYPE REF TO product.
ENDCLASS.

CLASS concrete_creatora DEFINITION INHERITING FROM creator.
  PUBLIC SECTION.
    METHODS:
      factorymethod REDEFINITION.
ENDCLASS.

CLASS concrete_creatora IMPLEMENTATION.
  METHOD factorymethod.
    CREATE OBJECT product TYPE concrete_producta.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_creatorb DEFINITION INHERITING FROM creator.
  PUBLIC SECTION.
    METHODS:
      factorymethod REDEFINITION.
ENDCLASS.

CLASS concrete_creatorb IMPLEMENTATION.
  METHOD factorymethod.
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
    DATA: creator TYPE REF TO creator
          , concretecreatora TYPE REF TO concrete_creatora
          , concretecreatorb TYPE REF TO concrete_creatorb
          , product TYPE REF TO product
          , class_name TYPE abap_abstypename.

    FIELD-SYMBOLS <fs> TYPE any.

    CREATE OBJECT concretecreatora.
    APPEND concretecreatora TO oa_creator_coll.

    CREATE OBJECT concretecreatorb.
    APPEND concretecreatorb TO oa_creator_coll.

    LOOP AT oa_creator_coll ASSIGNING <fs>.
      get_clazz_name <fs> class_name.
      CASE class_name.
        WHEN 'CONCRETE_CREATORA'.
          WRITE: / 'ConcreteCreatorA Creates Product A'.
        WHEN 'CONCRETE_CREATORB'.
          WRITE: / 'ConcreteCreatorB Creates Product B'.
      ENDCASE.

      creator = <fs>.
      product = creator->factorymethod( ).

      get_clazz_name product class_name.
      WRITE: / 'Product = ', class_name.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  main_app=>main( ).