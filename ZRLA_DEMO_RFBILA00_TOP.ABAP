*&---------------------------------------------------------------------*
*& Include          ZRLA_DEMO_RFBILA00_TOP
*&---------------------------------------------------------------------*

"---------------------------------------------------
"              STRUCTURES AND TABLES
"---------------------------------------------------

TYPES: BEGIN OF ty_bill,
         bukrs   TYPE bukrs,      "company code
         gjahr   TYPE gjahr,      "fical year
         belnr   TYPE belnr_d,    "accounting document number
         saknr   TYPE saknr,      "g/l Account Number
         tsaknr  TYPE txt20,      "short text to g/l account
         waers   TYPE waers,      "currency
         shkzg   TYPE shkzg,      "debit/credit indicator
         balcf   TYPE string,     "balance carryfoward
         dmbtr2  TYPE string,     "balance of prior periods
         totdeb  TYPE string,     "balance of debits
         totcre  TYPE string,     "balance of credits
         dmbtr   TYPE dmbrt,      "total balance
         bewar   TYPE bewar,      "movement type
         t_color TYPE lvc_t_scol, "color to print row
       END OF ty_bill.

"main table output
DATA: it_bill TYPE TABLE OF ty_bill,
      ls_bill TYPE ty_bill.

"---------------------------------------------------
"                   VARIABLES
"---------------------------------------------------

"account reasons
DATA:      gl_account_output TYPE saknr.

"year and year to compare
CONSTANTS: lc_currentyear TYPE bseg-gjahr VALUE '2025',
           lc_compareyear TYPE bseg-gjahr VALUE '2024'.

"company code
DATA: lc_companycode TYPE bukrs VALUE 'PT02'.

"balance year
DATA: lv_total_current TYPE dmbtr.

"total prior period
DATA: tot_previous_period TYPE dmbtr.
"balance carryfoward
DATA: tot_blc_carryfoward_current TYPE dmbtr.
"balance total credit
DATA: tot_blc_credit_current TYPE dmbtr.
"balance total debit
DATA: tot_blc_debit_current TYPE dmbtr.


"---------------------------------------------------
"                  ALV OBJECTS
"---------------------------------------------------

"object from classes
DATA: ol_alv         TYPE REF TO cl_salv_table,
      lo_functions   TYPE REF TO cl_salv_functions,
      lo_alv_columns TYPE REF TO cl_salv_columns,
      lo_alv_column  TYPE REF TO cl_salv_column,
      lo_cols        TYPE REF TO cl_salv_columns_table,
      lo_col         TYPE REF TO cl_salv_column_table,
      lo_alv_display TYPE REF TO cl_salv_display_settings,
      lo_aggregation TYPE REF TO cl_salv_aggregations.

DATA: lt_s_color        TYPE lvc_t_scol,
      ls_color          TYPE lvc_s_colo,
      lv_countrow_color TYPE i.
