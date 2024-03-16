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
WE20_T_CODE
    Run Transaction     /nWE20
    Sleep   1
    Take Screenshot    WE20.jpg
Partner type KU
    Select Node     wnd[0]/shellcont/shell  KU
    Sleep   1
    Take Screenshot    WE20_2.1.jpg
    Click Element   wnd[0]/tbar[1]/btn[46]
    Sleep   1
    Take Screenshot   WE20_2.2.jpg
    Input Text  wnd[1]/usr/ctxtGSO_PTYP-LOW     KU
    Sleep   1
    Take Screenshot    WE20_2.3.jpg
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Take Screenshot    WE20_2.4.jpg
    Get No Entries Found Text   wnd[0]/sbar/pane[0]
    Sleep   1
    Take Screenshot    WE20_2.5.jpg
Partner type LS
    Select Node     wnd[0]/shellcont/shell  LS
    Sleep   1
    Take Screenshot    WE20_0.1.jpg
    Click Element   wnd[0]/tbar[1]/btn[46]
    Sleep   1
    Take Screenshot    WE20_0.2.jpg
    Input Text  wnd[1]/usr/ctxtGSO_PTYP-LOW     LS
    Sleep   1
    Take Screenshot    WE20_0.3.jpg
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Take Screenshot    WE20_0.4.jpg
    Get No Entries Found Text   wnd[0]/sbar/pane[0]
    Sleep   1  
    Take Screenshot    WE20_0.5.jpg

Partner type LI
    Select Node     wnd[0]/shellcont/shell  LI
    Sleep   1
    Take Screenshot    WE20_1.1.jpg
    Click Element   wnd[0]/tbar[1]/btn[46]
    Sleep   1
    Take Screenshot   WE20_1.2.jpg
    Input Text  wnd[1]/usr/ctxtGSO_PTYP-LOW     LI
    Sleep   1
    Take Screenshot    WE20_1.3.jpg
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Take Screenshot    WE20_1.4.jpg
    Get No Entries Found Text   wnd[0]/sbar/pane[0]
    Sleep   1
    Take Screenshot    WE20_1.5.jpg
