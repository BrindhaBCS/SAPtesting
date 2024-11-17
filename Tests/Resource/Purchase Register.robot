*** Settings ***
Library   TallyLibrary.py

*** Keywords ***
Purchase Register
    Login
    Send Keys To Window    ${symvar('Shift_T')}
    Send Keys To Window    ${symvar('Shift_D')}
    Send Keys To Window    ${symvar('Shift_A')} 
    Send Keys To Window    ${symvar('Shift_P')}  
    Send Keys To Window    ${symvar('Alt_F2')} 
    Select Period    ${symvar('FROM_DATE')}    ${symvar('TO_DATE')}  
    Send Keys To Window    ${symvar('Ctrl_H')}      
    Select View Mode    ${symvar('View')}
    Logout

Login
    Login Tally    ${symvar('TALLY')}

Logout
    Close Tally Window 