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

SDCCN
    Run Transaction    /nSDCCN
    Sleep    2
    Take Screenshot    SDCCN_1.JPG
    Sleep    2
    Click Element    wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpOUTBOX
    Sleep    2
    Take Screenshot    SDCCN_2.JPG
    Sleep    2
    Click Element    wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpDEL_ITEMS
    Sleep    2
    Take Screenshot    SDCCN_3.JPG
    Sleep    2
    Click Element    wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpSHOWLOG
    Sleep    2
    Take Screenshot    SDCCN_4.JPG
    Sleep    6