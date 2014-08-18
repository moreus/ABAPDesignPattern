*&---------------------------------------------------------------------*
*& Report  ZDP_CHAINOFRESP
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_chainofresp.


CLASS cl_abap_typedescr DEFINITION LOAD.

DATA: moff TYPE I
      , slen TYPE I
      , mlen TYPE I.

DEFINE get_clazz_name.
  &2 = cl_abap_classdescr=>get_class_name( &1 ).
  FIND REGEX 'CLASS=' IN &2 MATCH OFFSET moff match LENGTH mlen.
  slen = moff + mlen.
  SHIFT &2 BY slen PLACES LEFT.
END-OF-DEFINITION.

CLASS HANDLER DEFINITION ABSTRACT.
  PUBLIC SECTION.
  METHODS:
  set_successor IMPORTING io_successor TYPE REF TO HANDLER
  , handle_request ABSTRACT IMPORTING iv_request TYPE I.

  PROTECTED SECTION.
  DATA:
        successor TYPE REF TO HANDLER.
ENDCLASS.

CLASS HANDLER IMPLEMENTATION.
  METHOD set_successor.
    me->successor = io_successor.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_handler1 DEFINITION INHERITING FROM HANDLER.
  PUBLIC SECTION.
  METHODS:
  handle_request REDEFINITION.
ENDCLASS.

CLASS concrete_handler1 IMPLEMENTATION.
  METHOD handle_request.
    DATA: class_name TYPE abap_abstypename.
    get_clazz_name me class_name.

    IF ( iv_request >= 0 AND iv_request < 10 ).
      WRITE: / class_name, 'Handled request', iv_request.
  ELSEIF ( NOT successor IS INITIAL ).
      me->successor->handle_request( iv_request ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_handler2 DEFINITION INHERITING FROM HANDLER.
  PUBLIC SECTION.
  METHODS:
  handle_request REDEFINITION.
ENDCLASS.

CLASS concrete_handler2 IMPLEMENTATION.
  METHOD handle_request.
    DATA: class_name  TYPE abap_abstypename.
    get_clazz_name me class_name.

    IF ( iv_request >= 10 AND iv_request < 20 ).
      WRITE: /  class_name, 'Handled request', iv_request.
  ELSEIF ( NOT successor IS INITIAL ).
      me->successor->handle_request( iv_request ).
    ENDIF.
  ENDMETHOD.                    "handlerequest
ENDCLASS.

CLASS concrete_handler3 DEFINITION INHERITING FROM HANDLER.
  PUBLIC SECTION.
  METHODS:
  handle_request REDEFINITION.
ENDCLASS.

CLASS concrete_handler3 IMPLEMENTATION.
  METHOD handle_request.
    DATA: class_name  TYPE abap_abstypename.
    get_clazz_name me class_name.

    IF ( iv_request >= 20 AND iv_request < 30 ).
      WRITE: /  class_name, 'Handled request', iv_request.
  ELSEIF ( NOT successor IS INITIAL ).
      me->successor->handle_request( iv_request ).
    ENDIF.
  ENDMETHOD.                    "handlerequest
ENDCLASS.

CLASS lcl_application DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
  CLASS-METHODS: RUN.
  METHODS:       constructor.
  PRIVATE SECTION.
  CLASS-DATA:    so_application TYPE REF TO lcl_application.
ENDCLASS.

CLASS lcl_application IMPLEMENTATION.

*----------------------------------------------------------
* LCL_APPLICATION->RUN().
*----------------------------------------------------------
  METHOD RUN.
    DATA:
          exc_ref  TYPE REF TO cx_root
          ,exc_text TYPE string.

    IF lcl_application=>so_application IS INITIAL.
      TRY.
        CREATE OBJECT lcl_application=>so_application.
      CATCH cx_sy_create_object_error INTO exc_ref.
        exc_text = exc_ref->get_text( ).
        MESSAGE exc_text TYPE 'I'.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    DATA:
          h1 TYPE REF TO concrete_handler1
          ,h2 TYPE REF TO concrete_handler2
          ,h3 TYPE REF TO concrete_handler3
          ,t_request TYPE TABLE OF I
          ,request TYPE I
          .

*   create objects
    CREATE OBJECT h1.
    CREATE OBJECT h2.
    CREATE OBJECT h3.

    h1->set_successor( h2 ).
    h2->set_successor( h3 ).

    INSERT 2  INTO TABLE t_request.
    INSERT 5  INTO TABLE t_request.
    INSERT 14 INTO TABLE t_request.
    INSERT 22 INTO TABLE t_request.
    INSERT 18 INTO TABLE t_request.
    INSERT 3  INTO TABLE t_request.
    INSERT 27 INTO TABLE t_request.
    INSERT 20 INTO TABLE t_request.

    LOOP AT t_request INTO request.
      h1->handle_request( request ).
    ENDLOOP.

  ENDMETHOD.                    "constructor

ENDCLASS.

START-OF-SELECTION.
lcl_application=>run( ).