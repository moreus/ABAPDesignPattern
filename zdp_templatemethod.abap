*&---------------------------------------------------------------------*
*& Report  ZDP_TEMPLATEMETHOD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_templatemethod.

CLASS template_sandwich DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:  prepare_sandwich FINAL.

  PROTECTED SECTION.
    METHODS: add_butter.
    METHODS: add_extra ABSTRACT.
    METHODS: add_veggetables ABSTRACT.
  PRIVATE SECTION.
    METHODS: slice_break.
ENDCLASS.

CLASS template_sandwich IMPLEMENTATION.
  METHOD add_butter.
    WRITE: / 'Add thin layer of butter'.
  ENDMETHOD.

  METHOD slice_break.
    WRITE: / 'Slice Break.'.
  ENDMETHOD.

  METHOD prepare_sandwich.
    slice_break( ).
    add_butter( ).
    add_extra( ).
    add_veggetables( ).
  ENDMETHOD.
ENDCLASS.

CLASS cheese_sandwich DEFINITION  INHERITING FROM template_sandwich.
  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: add_extra REDEFINITION.
    METHODS: add_veggetables REDEFINITION.
    METHODS: add_butter REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.

CLASS cheese_sandwich IMPLEMENTATION.
  METHOD add_butter.
    WRITE: / 'Add thick layer of butter'.
  ENDMETHOD.

  METHOD add_extra.
    WRITE:/ 'Add slices of camenbert'.
  ENDMETHOD.

  METHOD add_veggetables.
    WRITE:/ 'Add tomato slices'.
  ENDMETHOD.
ENDCLASS.

CLASS ham_sandwich DEFINITION  INHERITING FROM template_sandwich.
  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: add_extra REDEFINITION.
    METHODS: add_veggetables REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.

CLASS ham_sandwich IMPLEMENTATION.
  METHOD add_extra.
    WRITE: / 'Add slice of ham'.
  ENDMETHOD.

  METHOD add_veggetables.
    WRITE: / 'Add salad leaves'.
    WRITE: / 'Add onions'.
  ENDMETHOD.
ENDCLASS.

CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      main.
ENDCLASS.

CLASS mainapp IMPLEMENTATION.
  METHOD main.
    DATA: sandwich TYPE REF TO template_sandwich.
    CREATE OBJECT sandwich TYPE cheese_sandwich.

    sandwich->prepare_sandwich( ).

    CREATE OBJECT sandwich TYPE ham_sandwich.
    sandwich->prepare_sandwich( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  mainapp=>main( ).