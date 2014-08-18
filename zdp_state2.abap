*&---------------------------------------------------------------------*
*& Report  ZDP_STATE2
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdp_state2.
CLASS account DEFINITION DEFERRED.
CLASS silverstate DEFINITION DEFERRED.

CLASS state DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      deposit ABSTRACT IMPORTING iv_amount  TYPE d
        , withdraw ABSTRACT EXPORTING ev_amount TYPE d
          , payinterest ABSTRACT
          , get_account ABSTRACT RETURNING VALUE(ro_account) TYPE REF TO account
          , get_balance ABSTRACT RETURNING VALUE(rv_account) TYPE d
          , get_interest ABSTRACT RETURNING VALUE(rv_interest) TYPE d
          , get_lowerlimit ABSTRACT RETURNING VALUE(rv_lowerlimit) TYPE d
          , get_upperlimit ABSTRACT RETURNING VALUE(rv_upperlimit) TYPE d.
  PROTECTED SECTION.
    DATA: mo_account TYPE REF TO account
        , mv_balance TYPE d
          , mv_interest TYPE d
          , mv_lowerlimit TYPE d
          , mv_upperlimit TYPE d.
ENDCLASS.

CLASS account DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_account RETURNING VALUE(rv_account) TYPE string
      , set_account IMPORTING iv_account TYPE string
      , get_state RETURNING VALUE(ro_state) TYPE REF TO state
      , set_state IMPORTING io_state TYPE REF TO state.

  PRIVATE SECTION.
    DATA: mv_account TYPE string,
          mo_state   TYPE REF TO state.
ENDCLASS.

CLASS account IMPLEMENTATION.
  METHOD get_state.
    ro_state = me->mo_state.
  ENDMETHOD.

  METHOD set_state.
    me->mo_state = io_state.
  ENDMETHOD.
  METHOD get_account.
    rv_account = me->mv_account.
  ENDMETHOD.

  METHOD set_account.
    me->mv_account = iv_account.
  ENDMETHOD.
ENDCLASS.

CLASS balance DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_balance RETURNING VALUE(rv_balance) TYPE d
      , set_balance IMPORTING iv_balance TYPE d.

  PRIVATE SECTION.
    DATA: mv_balance TYPE d.
ENDCLASS.

CLASS balance IMPLEMENTATION.
  METHOD get_balance.
    rv_balance = me->mv_balance.
  ENDMETHOD.

  METHOD set_balance.
    me->mv_balance = iv_balance.
  ENDMETHOD.
ENDCLASS.

CLASS redstate DEFINITION INHERITING FROM state.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING io_state TYPE REF TO state,
      initialize,
      deposit REDEFINITION,
      withdraw REDEFINITION,
      payinterest REDEFINITION,
      get_account REDEFINITION,
      get_balance REDEFINITION,
      get_interest REDEFINITION,
      get_lowerlimit REDEFINITION,
      get_upperlimit REDEFINITION.

  PRIVATE SECTION.
    METHODS: statechangecheck.
    DATA: mv_servicefee.
ENDCLASS.

CLASS redstate IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->mv_balance = io_state->mv_balance.
    me->mo_account = NEW account( ).
    me->initialize( ).
  ENDMETHOD.

  METHOD initialize.
    me->mv_interest   = 0.
    me->mv_lowerlimit = -100.
    me->mv_upperlimit = 0.
    me->mv_servicefee = 15.
  ENDMETHOD.

  METHOD deposit.
    me->mv_balance = me->mv_balance +  iv_amount.
    me->statechangecheck( ).
  ENDMETHOD.

  METHOD withdraw.
    ev_amount = ev_amount - me->mv_servicefee.
    WRITE: / 'No funds available for withdrawal!'.
  ENDMETHOD.

  METHOD payinterest.
  ENDMETHOD.

  METHOD statechangecheck.
    IF mv_balance > mv_upperlimit.
      DATA: m_silverstate TYPE REF TO silverstate.
      CREATE OBJECT m_silverstate.
      mv_account->set_state( io_state = m_silverstate).
    ENDIF.
  ENDMETHOD.

  METHOD get_balance.
    rv_balance = me->mv_balance.
  ENDMETHOD.

  METHOD get_interest.
    rv_interest = me->mv_interest.
  ENDMETHOD.

  METHOD get_account.
    ro_account = me->mo_account.
  ENDMETHOD.

  METHOD get_lowerlimit.
    rv_lowerlimit = me->mv_lowerlimit.
  ENDMETHOD.

  METHOD get_upperlimit.
    rv_upperlimit = me->mv_upperlimit.
  ENDMETHOD.
ENDCLASS.

CLASS silverstate DEFINITION INHERITING FROM state.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING io_state   TYPE REF TO state OPTIONAL
                            iv_balance TYPE d OPTIONAL
                            io_account TYPE REF TO account OPTIONAL.
ENDCLASS.

CLASS silverstate IMPLEMENTATION.
  IF io_state IS INITIAL.
    me->mv_balance = io_state->get_balance( ).
    me->mo_account = io_state->get_account( ).
  ELSE.
    me->mv_balance = iv_balance.
    me->mo_account = io_account.
  ENDIF.
ENDCLASS.