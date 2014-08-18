*&---------------------------------------------------------------------*
*& Report  ZDP_ITERATOR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_iterator.


CLASS lcl_item DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_name TYPE string.
    DATA: v_name TYPE string READ-ONLY.
ENDCLASS.

CLASS lcl_item IMPLEMENTATION.
  METHOD constructor.
    v_name = iv_name.
  ENDMETHOD.
ENDCLASS.

INTERFACE if_collection DEFERRED.

INTERFACE if_iterator.
  METHODS: get_index RETURNING VALUE(index) TYPE i,
    has_next RETURNING VALUE(has_next) TYPE flag,
    get_next RETURNING VALUE(object) TYPE REF TO object,
    first RETURNING VALUE(object) TYPE REF TO object,
    set_step IMPORTING VALUE(iv_step) TYPE i.
  DATA: v_step TYPE i.
  DATA: v_current TYPE i.
  DATA: o_collection TYPE REF TO if_collection.
ENDINTERFACE.

INTERFACE if_collection.
  METHODS: get_iterator RETURNING VALUE(iterator) TYPE REF TO if_iterator.
  METHODS: add IMPORTING element TYPE REF TO object,
    remove IMPORTING element TYPE REF TO object,
    clear,
    size RETURNING VALUE(size) TYPE i,
    is_empty RETURNING VALUE(empty) TYPE flag,
    get IMPORTING index         TYPE i
        RETURNING VALUE(object) TYPE REF TO object.
ENDINTERFACE.

CLASS lcl_iterator DEFINITION.
  PUBLIC SECTION.
    INTERFACES: if_iterator.
    METHODS: constructor IMPORTING io_collection TYPE REF TO if_collection.
    ALIASES: get_index FOR if_iterator~get_index,
    has_next FOR if_iterator~has_next,
    get_next FOR if_iterator~get_next,
    first FOR if_iterator~first,
    set_step FOR if_iterator~set_step.

  PRIVATE SECTION.
    ALIASES:  v_step FOR if_iterator~v_step,
    v_current FOR if_iterator~v_current,
    o_collection FOR if_iterator~o_collection.
ENDCLASS.

CLASS lcl_collection DEFINITION.
  PUBLIC SECTION.
    INTERFACES: if_collection.
    DATA: i_items TYPE STANDARD TABLE OF REF TO object.
    ALIASES: get_iterator FOR if_collection~get_iterator,
            add FOR if_collection~add,
            remove FOR if_collection~clear,
            clear FOR if_collection~size,
            size FOR if_collection~is_empty,
            get FOR if_collection~get.
ENDCLASS.

CLASS lcl_collection IMPLEMENTATION.
  METHOD if_collection~get_iterator.
    CREATE OBJECT iterator
      TYPE lcl_iterator
      EXPORTING
        io_collection = me.
  ENDMETHOD.

  METHOD if_collection~add.
    APPEND element TO i_items.
  ENDMETHOD.

  METHOD if_collection~remove.
    DELETE i_items WHERE table_line EQ element.
  ENDMETHOD.

  METHOD if_collection~clear.
    CLEAR: i_items.
  ENDMETHOD.

  METHOD if_collection~size.
    size = lines( i_items ).
  ENDMETHOD.

  METHOD if_collection~is_empty.
    IF me->size( ) IS INITIAL.
      empty = 'X'.
    ENDIF.
  ENDMETHOD.

  METHOD if_collection~get.
    READ TABLE i_items INTO object INDEX index.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_iterator IMPLEMENTATION.
  METHOD constructor.
    o_collection = io_collection.
    v_step = 1.
  ENDMETHOD.

  METHOD if_iterator~first.
    v_current = 1.
    object = o_collection->get( v_current ).
  ENDMETHOD.

  METHOD if_iterator~get_next.
    v_current = v_current + v_step.
    object = o_collection->get( v_current ).
  ENDMETHOD.

  METHOD if_iterator~has_next.
    DATA obj TYPE REF TO object.
    DATA idx TYPE i.
    idx = v_current + v_step.
    obj = o_collection->get( idx ).
    IF obj IS BOUND.
      has_next = 'X'.
    ENDIF.
  ENDMETHOD.

  METHOD if_iterator~set_step.
    me->v_step = iv_step.
  ENDMETHOD.

  METHOD if_iterator~get_index.
    index = index.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:run.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD run.
    DATA: o_collection TYPE REF TO if_collection.
    DATA: o_iterator TYPE REF TO if_iterator.
    DATA: lo_item TYPE REF TO lcl_item.

    CREATE OBJECT o_collection TYPE lcl_collection.
    o_iterator = o_collection->get_iterator( ).

    CREATE OBJECT lo_item
      EXPORTING
        iv_name = 'Item1'.
    o_collection->add( lo_item ).

    CREATE OBJECT lo_item
      EXPORTING
        iv_name = 'Item2'.
    o_collection->add( lo_item ).

    CREATE OBJECT lo_item
      EXPORTING
        iv_name = 'Item3'.
    o_collection->add( lo_item ).

    CREATE OBJECT lo_item
      EXPORTING
        iv_name = 'Item4'.
    o_collection->add( lo_item ).

    CREATE OBJECT lo_item
      EXPORTING
        iv_name = 'Item5'.
    o_collection->add( lo_item ).

    WHILE o_iterator->has_next( ) IS NOT INITIAL.
      lo_item ?= o_iterator->get_next( ).
      WRITE: / lo_item->v_name.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_main=>run( ).