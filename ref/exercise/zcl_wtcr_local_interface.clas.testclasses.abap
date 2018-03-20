"! test double type "stub" for cash provider
CLASS ltd_cash_provider DEFINITION FOR TESTING.

  PUBLIC SECTION.
    INTERFACES lif_cash_provider PARTIALLY IMPLEMENTED.
ENDCLASS.


CLASS ltd_cash_provider IMPLEMENTATION.

  METHOD lif_cash_provider~get_notes.
    r_change = VALUE #( ( amount = 11 ) ( amount = 5 ) ( amount = 99 ) ).
  ENDMETHOD.

ENDCLASS.

* _____________________________________________________________________________

CLASS ltc_get_amount_in_coins DEFINITION DEFERRED."back door injection
CLASS zcl_wtcr_local_interface DEFINITION LOCAL FRIENDS ltc_get_amount_in_coins."back door injection

CLASS ltc_get_amount_in_coins DEFINITION FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    DATA m_cut TYPE REF TO zcl_wtcr_local_interface.
    DATA m_td_cash_provider TYPE REF TO ltd_cash_provider.

    METHODS setup.
    "! Amount of 1 EUR results in 1 EUR coin
    METHODS amount_1_coin_1 FOR TESTING RAISING cx_static_check.
    "! Amount of 2 EUR results in 2 EUR coins
    METHODS amount_2_coin_2 FOR TESTING RAISING cx_static_check.
    "! Amount of 29 EUR results in 4 EUR coins
    METHODS amount_29_coin_4 FOR TESTING RAISING cx_static_check.
    "! Amount of 4 EUR results in 0 EUR notes
    METHODS amount_4_notes_0 FOR TESTING RAISING cx_static_check.
    "! Amount of 29 EUR results in 25 EUR notes
    METHODS amount_29_notes_25 FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_get_amount_in_coins IMPLEMENTATION.

  METHOD setup.
    "given
    m_cut = NEW #( ).
    m_td_cash_provider = NEW ltd_cash_provider( ).
    m_cut->m_cash_provider = m_td_cash_provider. "back door injection
  ENDMETHOD.

  METHOD amount_1_coin_1.
    "when
    DATA(coin_amount) = m_cut->get_amount_in_coins( 1 ).

    "then
    cl_abap_unit_assert=>assert_equals( act = coin_amount
                                        exp = 1 ).
  ENDMETHOD.

  METHOD amount_2_coin_2.
    "when
    DATA(coin_amount) = m_cut->get_amount_in_coins( 2 ).

    "then
    cl_abap_unit_assert=>assert_equals( act = coin_amount
                                        exp = 2 ).
  ENDMETHOD.

  METHOD amount_29_coin_4.
    "when
    DATA(coin_amount) = m_cut->get_amount_in_coins( 29 ).

    "then
    cl_abap_unit_assert=>assert_equals( act = coin_amount
                                        exp = 4 ).
  ENDMETHOD.

  METHOD amount_4_notes_0.
    "when
    DATA(note_amount) = m_cut->get_amount_in_notes( 4 ).

    "then
    cl_abap_unit_assert=>assert_equals( act = note_amount
                                        exp = 0 ).
  ENDMETHOD.

  METHOD amount_29_notes_25.
    "when
    DATA(note_amount) = m_cut->get_amount_in_notes( 29 ).

    "then
    cl_abap_unit_assert=>assert_equals( act = note_amount
                                        exp = 25 ).
  ENDMETHOD.

ENDCLASS.
