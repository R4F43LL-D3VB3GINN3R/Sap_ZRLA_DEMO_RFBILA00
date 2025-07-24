*&---------------------------------------------------------------------*
*& Include          ZRLA_DEMO_RFBILA00_ALV
*&---------------------------------------------------------------------*

FORM display_data.

  ol_alv->display( ).

ENDFORM.

form print_row USING ls_bill TYPE ty_bill.

  "set color for last row
  DATA lv_color TYPE i.
  DATA col_total TYPE i.

  IF lv_total_current GT 0 OR lv_total_current EQ 0.
    lv_color  = 1.
    col_total = 5. " green
  ELSE.
    lv_color  = 1.
    col_total = 6. " red
  ENDIF.

  lt_s_color = VALUE #(
  ( fname = 'BUKRS'  color-col = col_total color-int = lv_color )
  ( fname = 'GJAHR'  color-col = col_total color-int = lv_color )
  ( fname = 'BELNR'  color-col = col_total color-int = lv_color )
  ( fname = 'SAKNR'  color-col = col_total color-int = lv_color )
  ( fname = 'TSAKNR' color-col = col_total color-int = lv_color )
  ( fname = 'WAERS'  color-col = col_total color-int = lv_color )
  ( fname = 'DMBTR'  color-col = col_total color-int = lv_color )
  ( fname = 'ICON'   color-col = col_total color-int = lv_color )
  ( fname = 'SHKZG'  color-col = col_total color-int = lv_color )
  ( fname = 'BALCF'  color-col = col_total color-int = lv_color )
  ( fname = 'GJAHR2' color-col = col_total color-int = lv_color )
  ( fname = 'BELNR2' color-col = col_total color-int = lv_color )
  ( fname = 'SHKZG2' color-col = col_total color-int = lv_color )
  ( fname = 'DMBTR2' color-col = col_total color-int = lv_color )
  ( fname = 'ICON2'  color-col = col_total color-int = lv_color )
  ( fname = 'TOTDEB' color-col = col_total color-int = lv_color )
  ( fname = 'TOTCRE' color-col = col_total color-int = lv_color )
  ( fname = 'BEWAR'  color-col = col_total color-int = lv_color )
  ).

  ls_bill-t_color = lt_s_color.

endform.

FORM set_functions.

  "cl_salv_functions deals only standard functions of alv

  CREATE OBJECT lo_functions.

  lo_functions = ol_alv->get_functions( ).
  lo_functions->set_all( abap_true ).

ENDFORM.

FORM set_settings.

  "additional settings to custom alv format

  lo_alv_display = ol_alv->get_display_settings( ).
  lo_alv_display->set_striped_pattern( cl_salv_display_settings=>true ).
  lo_alv_display->set_list_header( 'Title Alv' ).
  lo_alv_display->set_striped_pattern( value = abap_true ).
  lo_alv_display->set_vertical_lines( value = abap_true ).
  lo_alv_display->get_fit_column_to_table_size( ).


ENDFORM.

FORM set_columns.

  lo_alv_columns = ol_alv->get_columns( ).

  lo_alv_column = lo_alv_columns->get_column( 'BUKRS' ).
  lo_alv_column->set_long_text( 'CoCd' ).
  lo_alv_column->set_fixed_header_text( 'L' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('5').
  lo_alv_column->set_tooltip( value = 'Company Code' ).
  lo_alv_column->set_optimized( 'X' ).
*  lo_alv_column->set_visible( abap_false ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).
*  lo_alv_column->set_visible( abap_false ).

  lo_alv_columns = ol_alv->get_columns( ).

  lo_alv_column = lo_alv_columns->get_column( 'GJAHR' ).
  lo_alv_column->set_long_text( 'Year' ).
  lo_alv_column->set_fixed_header_text( 'L' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('5').
  lo_alv_column->set_tooltip( value = 'Main' ).
  lo_alv_column->set_optimized( 'X' ).
*  lo_alv_column->set_visible( abap_false ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).
  lo_alv_column->set_visible( abap_false ).

  lo_alv_column = lo_alv_columns->get_column( 'BELNR' ).
  lo_alv_column->set_long_text( 'Document Nº' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('15').
  lo_alv_column->set_optimized( 'X' ).
  lo_alv_column->set_tooltip( value = 'Document Number' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).
*  lo_alv_column->set_visible( abap_false ).

  lo_alv_column = lo_alv_columns->get_column( 'SAKNR' ).
  lo_alv_column->set_long_text( 'Gl.Account' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('15').
  lo_alv_column->set_optimized( 'X' ).
  lo_alv_column->set_tooltip( value = 'Account Reason' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

  lo_alv_column = lo_alv_columns->get_column( 'TSAKNR' ).
  lo_alv_column->set_long_text( 'G/L Description' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('20').
  lo_alv_column->set_optimized( 'X' ).
  lo_alv_column->set_tooltip( value = 'G/L Account Description' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

  lo_alv_column = lo_alv_columns->get_column( 'WAERS' ).
  lo_alv_column->set_long_text( 'Crrcy' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('5').
  lo_alv_column->set_optimized( 'X' ).
  lo_alv_column->set_tooltip( value = 'G/L Account Currency' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

  lo_alv_column ?= lo_alv_columns->get_column( 'SHKZG' ).
  lo_alv_column->set_long_text( 'Debit/Credit' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('5').
  lo_alv_column->set_optimized( abap_true ).
  lo_alv_column->set_visible( abap_false ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).
*  lo_alv_column->set_visible( abap_false ).

  lo_alv_column ?= lo_alv_columns->get_column( 'BALCF' ).
  lo_alv_column->set_long_text( 'Balance Carryfoward' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('20').
  lo_alv_column->set_optimized( abap_true ).
  lo_alv_column->set_tooltip( value = 'Main Balance' ).
  lo_alv_column->set_decimals( value = '2' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

  lo_alv_column ?= lo_alv_columns->get_column( 'DMBTR2' ).
  lo_alv_column->set_long_text( 'Balance of Prior Periods' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('20').
  lo_alv_column->set_optimized( abap_true ).
  lo_alv_column->set_tooltip( value = 'Previous Period' ).
  lo_alv_column->set_decimals( value = '2' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

  lo_alv_column ?= lo_alv_columns->get_column( 'TOTDEB' ).
  lo_alv_column->set_long_text( 'Debit Blnce Reporting Per' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('20').
  lo_alv_column->set_optimized( abap_true ).
  lo_alv_column->set_tooltip( value = 'Debit Blnce Reported Year' ).
  lo_alv_column->set_decimals( value = '2' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

  lo_alv_column ?= lo_alv_columns->get_column( 'TOTCRE' ).
  lo_alv_column->set_long_text( 'Credit Blnce Reporting Per' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('20').
  lo_alv_column->set_optimized( abap_true ).
  lo_alv_column->set_tooltip( value = 'Credit Balance Reported Year' ).
  lo_alv_column->set_decimals( value = '2' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).


  lo_alv_column ?= lo_alv_columns->get_column( 'DMBTR' ).
  lo_alv_column->set_long_text( 'Acumulated Balance' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('20').
  lo_alv_column->set_optimized( abap_true ).
  lo_alv_column->set_tooltip( value = 'Total Reported Balance' ).
  lo_alv_column->set_decimals( value = '2' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

  lo_alv_column ?= lo_alv_columns->get_column( 'BEWAR' ).
  lo_alv_column->set_long_text( 'Mov.Type' ).
  lo_alv_column->set_medium_text( '' ).
  lo_alv_column->set_short_text( '' ).
  lo_alv_column->set_output_length('20').
  lo_alv_column->set_optimized( abap_true ).
  lo_alv_column->set_tooltip( value = 'Movement Type' ).
  lo_alv_column->set_decimals( value = '2' ).
  lo_alv_column->set_alignment(
  value = if_salv_c_alignment=>centered
  ).

ENDFORM.

FORM set_aggregations.

*  lo_aggregation = ol_alv->get_aggregations( ).
*
*  lo_aggregation->add_aggregation(
*    columnname = 'DMBTR'
*  ).

ENDFORM.

FORM create_alv.

  cl_salv_table=>factory(
   IMPORTING
     r_salv_table   = ol_alv                          " Basis Class Simple ALV Tables
   CHANGING
     t_table        = it_bill
 ).

  DATA(lo_columns_tab) = CAST cl_salv_columns_table( ol_alv->get_columns( ) ).
  lo_columns_tab->set_color_column( 'T_COLOR' ).

ENDFORM.
