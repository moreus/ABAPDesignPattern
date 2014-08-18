*&---------------------------------------------------------------------*
*& Report  ZDP_BUILDER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_builder.


INTERFACE lif_pizza.
  DATA: dough   TYPE string,
        sauce   TYPE string,
        topping TYPE string.
ENDINTERFACE.

CLASS lcl_pizza DEFINITION.
  PUBLIC SECTION.
  INTERFACES: lif_pizza.
ENDCLASS.

CLASS pizza_builder DEFINITION ABSTRACT.
  PUBLIC SECTION.
  METHODS: create_new_pizza
  RETURNING VALUE(ro_pizza) TYPE REF TO lif_pizza.
  METHODS: build_dough ABSTRACT,
  build_sauce ABSTRACT,
  build_topping ABSTRACT.

  PROTECTED SECTION.
  DATA: pizza TYPE REF TO lif_pizza.
ENDCLASS.

CLASS pizza_builder IMPLEMENTATION.
  METHOD create_new_pizza.
    CREATE OBJECT pizza TYPE lcl_pizza.
    ro_pizza = pizza.
  ENDMETHOD.
ENDCLASS.

CLASS veg_pizza_builder DEFINITION INHERITING FROM pizza_builder.
  PUBLIC SECTION.
  METHODS: build_dough REDEFINITION,
  build_sauce REDEFINITION,
  build_topping REDEFINITION.
ENDCLASS.

CLASS veg_pizza_builder IMPLEMENTATION.
  METHOD build_dough.
    pizza->dough = 'Thin Crust'.
  ENDMETHOD.

  METHOD build_sauce.
    pizza->sauce = 'Mild'.
  ENDMETHOD.

  METHOD build_topping.
    pizza->topping = 'Olives, Pineapples, Jalapenos'.
  ENDMETHOD.
ENDCLASS.

CLASS cheese_pizza_builder DEFINITION INHERITING FROM pizza_builder.
  PUBLIC SECTION.
  METHODS: build_dough REDEFINITION,
  build_sauce REDEFINITION,
  build_topping REDEFINITION.
ENDCLASS.


CLASS cheese_pizza_builder IMPLEMENTATION.
  METHOD build_dough.
    pizza->dough = 'Thick Crust'.
  ENDMETHOD.

  METHOD build_sauce.
    pizza->sauce = 'Mild Hot'.
  ENDMETHOD.

  METHOD build_topping.
    pizza->topping = 'Cheese, Cheese, Cheese, more Cheese'.
  ENDMETHOD.
ENDCLASS.

CLASS cook DEFINITION.
  PUBLIC SECTION.
  METHODS: construct_pizza IMPORTING io_builder      TYPE REF TO pizza_builder
    RETURNING VALUE(ro_pizza) TYPE REF TO lif_pizza.
  PRIVATE SECTION.
  DATA: pizzabuilder TYPE REF TO pizza_builder.
ENDCLASS.

CLASS cook IMPLEMENTATION.
  METHOD construct_pizza.
    pizzabuilder = io_builder.
    ro_pizza = pizzabuilder->create_new_pizza( ).

    pizzabuilder->build_dough( ).
    pizzabuilder->build_sauce( ).
    pizzabuilder->build_topping( ).
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
DATA: o_cook          TYPE REF TO cook,
      o_pizza_builder TYPE REF TO pizza_builder,
      o_pizza         TYPE REF TO lif_pizza.
CREATE OBJECT o_cook.

CREATE OBJECT o_pizza_builder TYPE veg_pizza_builder.
o_pizza = o_cook->construct_pizza( o_pizza_builder ).
WRITE: / o_pizza->dough, o_pizza->sauce, o_pizza->topping.

CREATE OBJECT o_pizza_builder TYPE cheese_pizza_builder.
o_pizza = o_cook->construct_pizza( o_pizza_builder ).
WRITE: / o_pizza->dough, o_pizza->sauce, o_pizza->topping.