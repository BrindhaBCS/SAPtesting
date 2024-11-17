*** Settings ***
Library    TallyLibrary.py

*** Variables ***
${Tally}    "C:\\Program Files\\TallyPrime\\tally.exe"
${FROM_DATE}     01-01-2024
${TO_DATE}       31-12-2024

*** Keywords ***
Display sales register
    Login Tally    ${TALLY}
    Send Keys To Window    +T
    Send Keys To Window    +D 
    Send Keys To Window    +A
    Send Keys To Window    +S
    Send Keys To Window    %F2 
    Select Period    ${FROM_DATE}    ${TO_DATE} 
    Send Keys To Window    ^H      
    Select View Mode    Half Yearly
    Send Keys To Window    {ENTER}
    Close Tally Window 


#     click_display_more_reports
#     click_account_book
#     click_sales_register
#     select_period    1-5-24    1-7-24
#     Sleep    5
#     change_sales_order_view    quarterly
#     Sleep    5
# Login
#     Login Tally    C:\\Program Files\\TallyPrime\\tally.exe
# Logout
#     Close Tally Window
