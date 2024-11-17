*** Settings ***
Library   TallyLibrary.py

*** Variables ***
${Tally}    "C:\\Program Files\\TallyPrime\\tally.exe"
${FROM_DATE}     01-01-2024
${TO_DATE}       31-12-2024

*** Keywords ***
Purchase Register
    Login Tally    ${TALLY}
    Send Keys To Window    +T
    Send Keys To Window    +D
    Send Keys To Window    +A 
    Send Keys To Window    +P  
    Send Keys To Window    %F2 
    Select Period    ${FROM_DATE}    ${TO_DATE}   
    Send Keys To Window    ^H      
    Select View Mode    Daily
    Close Tally Window     
