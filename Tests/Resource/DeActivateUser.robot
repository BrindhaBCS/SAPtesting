*** Settings ***
Library    Process
Library    ExcelLibrary
Library    SAP_Tcode_Library.py
Library    openpyxl
Library    DateTime
*** Keywords *** 
System Logon
    Start Process    ${symvar('SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('User_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('User_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Login_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{DEV_PASSWORD}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('DEV_PASSWORD')}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
System Logout
    Run Transaction   /nex
DeActivate User
    Run Transaction    /nSU01
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('SAP_User_ID')}
    Click Element    wnd[0]/tbar[1]/btn[7]
    # Sleep    5
    Window Handling    wnd[1]    Address Maintenance      wnd[1]/usr/btnBUTTON_2
    # Sleep    5
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[19]
    Sleep    1
    ${Get Current Date}    Get Current Date    result_format=%d.%m.%Y
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/ctxtSUID_ST_NODE_LOGONDATA-GLTGB    ${Get Current Date}
    Sleep    1
    Click Element   wnd[0]/tbar[0]/btn[11]
    Sleep    1
    Click Element   wnd[0]/tbar[1]/btn[29]
    Sleep    1
    Click Element   wnd[1]/tbar[0]/btn[6]
    Sleep    1
    ${result}    Get Value    wnd[0]/sbar/pane[0]
    Log    ${result}
    Log To Console    ${result}