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

scenario-SecurityAuditProfile
    Run Transaction    /nSM19
    Sleep    2
    Take Screenshot    SF1.jpg
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP1/tabpTAB2    
    Take Screenshot    SF2.pjg
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP2/tabpADMIN
    Take Screenshot    DF2.jpg
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP1/tabpTAB1
    Take Screenshot    DF1.jpg
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP2/tabpPARAM
    Take Screenshot    KP1.jpg
    Sleep    2