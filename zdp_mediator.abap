*&---------------------------------------------------------------------*
*& Report  ZDP_MEDIATOR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_mediator.
CLASS united_nations DEFINITION DEFERRED.

CLASS country DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING io_mediator TYPE REF TO united_nations.
  PROTECTED SECTION.
    DATA: mo_mediator TYPE REF TO united_nations.
ENDCLASS.

CLASS country IMPLEMENTATION.
  METHOD constructor.
    me->mo_mediator = io_mediator.
  ENDMETHOD.
ENDCLASS.

CLASS united_nations DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      declear ABSTRACT IMPORTING iv_message   TYPE string
                                 io_colleague TYPE REF TO country.
ENDCLASS.

CLASS irag DEFINITION INHERITING FROM country.
  PUBLIC SECTION.
    METHODS:
        constructor IMPORTING io_mediator TYPE REF TO united_nations
       ,declear IMPORTING iv_message TYPE string
       ,get_message IMPORTING iv_message TYPE string
       .
ENDCLASS.

CLASS irag IMPLEMENTATION.
  METHOD constructor.
    super->constructor( io_mediator ).
  ENDMETHOD.

  METHOD declear.
    me->mo_mediator->declear( iv_message = iv_message io_colleague =
me ).
  ENDMETHOD.

  METHOD get_message.
    WRITE: / '伊拉克获得对方信息: ', iv_message.
  ENDMETHOD.
ENDCLASS.

CLASS usa DEFINITION INHERITING FROM country.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING io_mediator TYPE REF TO united_nations
     ,declear IMPORTING iv_message TYPE string
     ,get_message IMPORTING iv_message TYPE string
     .
ENDCLASS.

CLASS usa IMPLEMENTATION.
  METHOD constructor.
    super->constructor( io_mediator ).
  ENDMETHOD.

  METHOD declear.
    me->mo_mediator->declear( iv_message = iv_message io_colleague = me ).
  ENDMETHOD.

  METHOD get_message.
    WRITE: / '美国获得对方信息: ', iv_message.
  ENDMETHOD.
ENDCLASS.

CLASS united_nations_securitycouncil DEFINITION INHERITING FROM united_nations.


  PUBLIC SECTION.
    METHODS:
      set_colleague1 IMPORTING io_co1 TYPE REF TO usa,
      set_colleague2 IMPORTING io_co2 TYPE REF TO irag,
      declear REDEFINITION.
  PRIVATE SECTION.
    DATA: mo_co1 TYPE REF TO usa,
          mo_co2 TYPE REF TO irag.
ENDCLASS.


CLASS united_nations_securitycouncil IMPLEMENTATION.
  METHOD set_colleague1.
    me->mo_co1 = io_co1.
  ENDMETHOD.

  METHOD set_colleague2.
    me->mo_co2 = io_co2.
  ENDMETHOD.

  METHOD declear.
    IF io_colleague EQ mo_co1.
      mo_co2->get_message( iv_message ).
    ELSE.
      mo_co1->get_message( iv_message ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD main.
    DATA: unsc TYPE REF TO united_nations_securitycouncil,
          c1   TYPE REF TO usa
          , c2 TYPE REF TO irag.
    CREATE OBJECT unsc.

    c1 = NEW usa( unsc ).
    c2 = NEW irag( unsc ).

    unsc->set_colleague2( c2 ).
    unsc->set_colleague1( c1 ).

    c1->declear( '不准研制核武器，否则就要发动战争' ).
    c2->declear( '我们没有核武器，也不怕侵略' ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  mainapp=>main( ).