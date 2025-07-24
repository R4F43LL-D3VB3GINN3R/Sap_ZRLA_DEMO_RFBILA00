*&---------------------------------------------------------------------*
*& Report ZRLA_DEMO_RFBILA00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrla_demo_rfbila00.

INCLUDE zrla_demo_rfbila00_top.
INCLUDE zrla_demo_rfbila00_rot.
INCLUDE zrla_demo_rfbila00_alv.

START-OF-SELECTION.

  "alv routines
  PERFORM create_alv.
  PERFORM set_functions.      "enable standard functions
  PERFORM set_settings.       "enable style functions
  PERFORM set_columns.        "enable columns settings
  PERFORM set_aggregations.   "enable sum of a column

  "data routines to main period
  PERFORM get_data.
  "calculate total per gl_account nº
  PERFORM calculate_total_balance.
  "output routines
  PERFORM display_data.

END-OF-SELECTION.
