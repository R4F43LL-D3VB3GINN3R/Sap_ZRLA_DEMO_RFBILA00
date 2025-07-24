*&---------------------------------------------------------------------*
*& Include          ZRLA_DEMO_RFBILA00_ROT
*&---------------------------------------------------------------------*

FORM get_data.

  SELECT bukrs,
         gjahr,
         belnr,
         saknr,
         shkzg,
         dmbtr,
         bewar
    FROM bseg
    INTO CORRESPONDING FIELDS OF TABLE @it_bill
    WHERE saknr NE ''
    AND   gjahr EQ @lc_currentyear
    AND   bukrs EQ @lc_companycode.

  "test for input data
*  READ TABLE it_bill INTO ls_bill INDEX 1.
*  DATA: new_bill LIKE LINE OF it_bill.
*  new_bill = ls_bill.
*  CLEAR new_bill.
*  new_bill-saknr = '220000'.
*  APPEND new_bill TO it_bill.
*
*  READ TABLE it_bill INTO ls_bill INDEX 1.
*  new_bill = ls_bill.
*  CLEAR new_bill.
*  new_bill-saknr = '220001'.
*  INSERT new_bill INTO it_bill INDEX 20.

  SORT it_bill BY saknr ASCENDING.

ENDFORM.

FORM get_total_credit_debit USING ls_bill-saknr TYPE saknr.

  "-----------------------------------------
  "           REPORTING PERIOD
  "-----------------------------------------

  "total credit value
  SELECT SUM( dmbtr ) FROM bseg INTO @DATA(lv_credit)
  WHERE saknr EQ @ls_bill-saknr
  AND   gjahr EQ @lc_currentyear
  AND   bukrs EQ @lc_companycode
  AND   shkzg EQ 'H'.

  "total debit value
  SELECT SUM( dmbtr ) FROM bseg INTO @DATA(lv_debit)
  WHERE saknr EQ @ls_bill-saknr
  AND   gjahr EQ @lc_currentyear
  AND   bukrs EQ @lc_companycode
  AND   shkzg EQ 'S'.

  lv_total_current = lv_debit - lv_credit.

  "-----------------------------------------
  "             PRIOR PERIOD
  "-----------------------------------------

  "total credit value
  SELECT SUM( dmbtr ) FROM bseg INTO @DATA(lv_credit2)
  WHERE saknr EQ @ls_bill-saknr
  AND   gjahr EQ @lc_compareyear
  AND   bukrs EQ @lc_companycode
  AND   shkzg EQ 'H'.

  "total debit value
  SELECT SUM( dmbtr ) FROM bseg INTO @DATA(lv_debit2)
  WHERE saknr EQ @ls_bill-saknr
  AND   gjahr EQ @lc_compareyear
  AND   bukrs EQ @lc_companycode
  AND   shkzg EQ 'S'.

  tot_previous_period = lv_debit2 - lv_credit2.

ENDFORM.

FORM get_balance_carryfoward USING racct TYPE saknr.

  SELECT SUM( tslvt ) FROM faglflext INTO @DATA(lv_sum)
  WHERE racct EQ @racct
  AND   ryear EQ @lc_compareyear.

  tot_blc_carryfoward_current = lv_sum.

ENDFORM.

FORM calculate_total_balance.

  "get first g/l account
  DATA: last_saknr TYPE ska1-saknr.
  READ TABLE it_bill INTO ls_bill INDEX 1.
  IF sy-subrc EQ 0.
    last_saknr = ls_bill-saknr.
  ENDIF.

  DATA: lv_endline TYPE i.
  lv_endline = lines( it_bill ).

  "calculate total balance an set icons
  LOOP AT it_bill INTO DATA(ls_bill).

    "insert last row details for last g/l account
    IF ls_bill-saknr NE last_saknr.
      PERFORM get_total_credit_debit  USING last_saknr.
      PERFORM get_balance_carryfoward USING last_saknr.
      PERFORM append_last_row_details USING sy-tabix.
      PERFORM insert_text_glaccount   USING last_saknr.
    ENDIF.

    "operations for total debit and credit
    CASE ls_bill-shkzg.
      WHEN 'H'.
        tot_blc_credit_current = tot_blc_credit_current - ls_bill-dmbtr.
        ls_bill-totcre         = ls_bill-dmbtr.
      WHEN 'S'.
        tot_blc_debit_current = tot_blc_debit_current + ls_bill-dmbtr.
        ls_bill-totdeb        = ls_bill-dmbtr.
    ENDCASE.

    MODIFY it_bill FROM ls_bill.
    last_saknr = ls_bill-saknr.
  ENDLOOP.

  DATA: lv_tabix TYPE sy-tabix.
  lv_tabix = lines( it_bill ) + 1.

  "insert last row details for last g/l account
  PERFORM get_balance_carryfoward USING last_saknr.
  PERFORM get_total_credit_debit  USING last_saknr.
  PERFORM append_last_row_details USING lv_tabix.
  PERFORM insert_text_glaccount   USING last_saknr.

ENDFORM.

FORM append_last_row_details USING index TYPE sy-tabix.

  "add or subtract balance carryfoward from total balance
  IF tot_blc_carryfoward_current GT 0.
    lv_total_current = lv_total_current + tot_blc_carryfoward_current.
  ENDIF.
  IF tot_blc_carryfoward_current LT 0.
    lv_total_current = lv_total_current - tot_blc_carryfoward_current.
  ENDIF.

  ls_bill-balcf    = tot_blc_carryfoward_current.
  ls_bill-dmbtr    = lv_total_current.
  ls_bill-totcre   = tot_blc_credit_current.
  ls_bill-totdeb   = tot_blc_debit_current.
  ls_bill-dmbtr2   = tot_previous_period.

  "clear not needed information
  CLEAR ls_bill-belnr.
  CLEAR ls_bill-gjahr.
  CLEAR ls_bill-shkzg.
  CLEAR ls_bill-bewar.

  "print the last row
  PERFORM print_row USING ls_bill.

  "insert last row
  INSERT ls_bill INTO it_bill INDEX index.

ENDFORM.

FORM insert_text_glaccount USING ls_bill-saknr TYPE saknr.

  DATA(total_lines_it_bill) = lines( it_bill ).
  DATA: lv_spras TYPE spras.

  READ TABLE it_bill INTO ls_bill INDEX total_lines_it_bill.
  IF sy-subrc EQ 0.

    "get language from company
    SELECT SINGLE spras INTO (@lv_spras) FROM t001 WHERE bukrs EQ @ls_bill-bukrs.
    "get text from g/l account
    SELECT SINGLE txt20 FROM skat INTO @DATA(lv_txt20) WHERE saknr EQ @ls_bill-saknr AND spras EQ @lv_spras.
    "get currency from g/l account
    SELECT SINGLE waers FROM skb1 INTO @DATA(lv_waers) WHERE saknr EQ @ls_bill-saknr.

    ls_bill-tsaknr = lv_txt20.
    ls_bill-waers  = lv_waers.
    MODIFY it_bill INDEX total_lines_it_bill FROM ls_bill.
  ENDIF.

ENDFORM.
