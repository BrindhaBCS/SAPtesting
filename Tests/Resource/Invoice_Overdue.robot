*** Settings ***
Library   TallyLibrary.py

*** Keywords ***
Start And Use Tally  
    Login
    Send Keys To Window    ${symvar('Shift_T')}
    Send Keys To Window    ${symvar('Shift_D')}
    Send Keys To Window    ${symvar('Shift_S')} 
    Send Keys To Window    ${symvar('Shift_O')}
    Send Keys To Window    ${symvar('Shift_R')}
    Send Keys To Window    ${symvar('F2')} 
    Select Period    ${symvar('FROM_DATE')}    ${symvar('TO_DATE')}  
    Logout
        

Login
    Login Tally    ${symvar('TALLY')}

Logout
    Close Tally Window 

