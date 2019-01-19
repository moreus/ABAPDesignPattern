*&---------------------------------------------------------------------*
*& Report  ZDP_VISITOR
*& Tight Coupled Visitor
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_visitor.

INTERFACE lif_visitable.
  METHODS: accept IMPORTING visitor.
ENDINTERFACE.

INTERFACE lif_visitor.
  METHODS: visit IMPORTING visitable.
ENDINTERFACE.

CLASS simple_visitable DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_visitable.
ENDCLASS.

CLASS simple_visitable IMPLEMENTATION.
  METHOD lif_visitable~accept.
    visitor.visit(me).
  ENDMETHOD.
ENDCLASS.

CLASS simple_visitor DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_visitor.
ENDCLASS.

CLASS simple_visitor IMPLEMENTATION.
  METHOD lif_visitor~visit.
    visitable.accept( ).
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
 
