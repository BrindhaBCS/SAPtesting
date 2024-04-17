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
    #Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}   
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

STMS_T_CODE
    Run Transaction    /nSTMS
    Sleep    2
    Take Screenshot    STMS.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[19]
    Sleep    1
    Take Screenshot    TRANSPORT.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[18]
    Sleep    2   
    Select Table Row    wnd[0]/usr/cntlGRID1/shellcont/shell    0
    Sleep    1
    Double Click On Current Cell    wnd[0]/usr/cntlGRID1/shellcont/shell           
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpATTR
    Sleep    1
    Take Screenshot    STMS_System_0.1.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
    Sleep    1
    Take Screenshot    STMS_System_0.2.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
    Sleep    1
    Take Screenshot    STMS_System_0.3.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Select Table Row    wnd[0]/usr/cntlGRID1/shellcont/shell    1
    Sleep    2
    Double Click On Current Cell    wnd[0]/usr/cntlGRID1/shellcont/shell           
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpATTR
    Sleep    1
    Take Screenshot    STMS_System_1.1.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
    Sleep    1
    Take Screenshot    STMS_System_1.2.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
    Sleep    1
    Take Screenshot    STMS_System_1.3.jpg
    Sleep    1
    
