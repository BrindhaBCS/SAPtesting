*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}   
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
 
System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

SM37
    Run Transaction    /nSM37
    Sleep    2
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-SCHEDUL
    Sleep    1
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-READY
    Sleep    1
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-RUNNING
    Sleep    1
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-FINISHED
    Sleep    1
    Take Screenshot    sm371.jpg
    Input Text    wnd[0]/usr/ctxtBTCH2170-FROM_DATE    ${EMPTY}
    Sleep    1
    Input Text    wnd[0]/usr/ctxtBTCH2170-TO_DATE    ${EMPTY}
    Sleep    1
    Input Text    wnd[0]/usr/txtBTCH2170-USERNAME    ${EMPTY}
    Sleep    1
    Take Screenshot    sm372.jpg
    Sleep    2
    Input Text    wnd[0]/usr/txtBTCH2170-USERNAME    *
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Take Screenshot    sm37.jpg
    Sleep    2
    Table Scroll    wnd[0]/usr    wnd[0]/usr/lbl[4,12]
    Sleep    2
    FOR    ${i}    IN RANGE    6   
        Send Vkey    82
        Take Screenshot    SPAD_${i + 1}.jpg  
    END