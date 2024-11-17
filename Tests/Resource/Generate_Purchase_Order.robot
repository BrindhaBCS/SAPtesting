*** Settings ***
Library    TallyLibrary.py

*** Variables ***
${Tally}    "C:\\Program Files\\TallyPrime\\tally.exe"

*** Keywords ***
Display the outstanding purchase order
    Login Tally    ${TALLY}
    Send Keys To Window    +T
    Send Keys To Window    +D 
    Send Keys To Window    +E
    Send Keys To Window    +L
    Send Keys To Window    +O     #outstanding not showing
    Send Keys To Window    F2 
    Select Period    ${FROM_DATE}    ${TO_DATE}   
    Close Tally Window 




#     click_display_more_reports
#     click_statement_of_inventory
#     click_outstanding_sales_order
#     click_all_orders
#     select_period    1-5-24    1-7-24
# Login
#     Login Tally    C:\\Program Files\\TallyPrime\\tally.exe
# Logout
#     Close Tally Window