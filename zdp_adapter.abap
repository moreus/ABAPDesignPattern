*&---------------------------------------------------------------------*
*& Report  ZDP_ADAPTER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_adapter.

INTERFACE lif_output.
  METHODS: generate_output.
ENDINTERFACE.

CLASS simple_op DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_output.
ENDCLASS.

CLASS simple_op IMPLEMENTATION.
  METHOD lif_output~generate_output.
    WRITE: / 'Simple Output - just using write.'.
  ENDMETHOD.
ENDCLASS.

CLASS tree_output DEFINITION.
  PUBLIC SECTION.
    METHODS: generate_tree.
ENDCLASS.

CLASS tree_output IMPLEMENTATION.
  METHOD generate_tree.
    WRITE: / 'Creating Tree ... using CL_GUI_ALV_TREE'.
  ENDMETHOD.
ENDCLASS.

CLASS new_complex_op DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_output.
ENDCLASS.

CLASS new_complex_op IMPLEMENTATION.
  METHOD lif_output~generate_output.
    DATA: o_tree_op TYPE REF TO tree_output.
    CREATE OBJECT o_tree_op.
    o_tree_op->generate_tree( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: o_op TYPE REF TO lif_output.
  CREATE OBJECT o_op TYPE simple_op.
  o_op->generate_output( ).

  CREATE OBJECT o_op TYPE new_complex_op.
  o_op->generate_output( ).