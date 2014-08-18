*&---------------------------------------------------------------------*
*& Report  ZDP_COMMAND
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_command.


CLASS receiver DEFINITION.
  PUBLIC SECTION.
    METHODS:
      action.
ENDCLASS.

CLASS receiver IMPLEMENTATION.
  METHOD action.
    WRITE: / 'Console.WriteLine(Called Receiver.Action()'.
  ENDMETHOD.
ENDCLASS.

CLASS command DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING io_receiver TYPE REF TO receiver
      , execute ABSTRACT.

  PROTECTED SECTION.
    DATA: mo_receiver TYPE REF TO receiver.
ENDCLASS.


CLASS command IMPLEMENTATION.
  METHOD constructor.
    me->mo_receiver = io_receiver.
  ENDMETHOD.
ENDCLASS.

CLASS concrete_command DEFINITION INHERITING FROM command.
  PUBLIC SECTION.
    METHODS:
      execute REDEFINITION.
ENDCLASS.


CLASS concrete_command IMPLEMENTATION.
  METHOD execute.
    me->mo_receiver->action( ).
  ENDMETHOD.
ENDCLASS.

CLASS invoker DEFINITION.
  PUBLIC SECTION.
    METHODS:
      set_command IMPORTING io_command TYPE REF TO command
      , execute_command.
  PRIVATE SECTION.
    DATA: mo_command TYPE REF TO command.
ENDCLASS.

CLASS invoker IMPLEMENTATION.
  METHOD set_command.
    me->mo_command = io_command.
  ENDMETHOD.

  METHOD execute_command.
    me->mo_command->execute( ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_application DEFINITION CREATE  PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS:run.
    METHODS: constructor.
  PRIVATE SECTION.
    CLASS-DATA: so_application TYPE REF TO lcl_application.
ENDCLASS.

CLASS lcl_application IMPLEMENTATION.
  METHOD run.
    DATA: exc_ref  TYPE REF TO cx_root
          , exc_text TYPE string.

    IF lcl_application=>so_application IS INITIAL.
      TRY .
          CREATE OBJECT lcl_application=>so_application.
        CATCH cx_sy_create_object_error INTO exc_ref.
          exc_text = exc_ref->get_text( ).
          MESSAGE exc_text TYPE 'I'.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    DATA: receiver TYPE REF TO receiver,
          command  TYPE REF TO concrete_command
          , invoker TYPE REF TO invoker.

    CREATE OBJECT receiver.
    CREATE OBJECT command EXPORTING io_receiver = receiver.

    CREATE OBJECT invoker.

    invoker->set_command( command ).
    invoker->execute_command( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_application=>run( ).