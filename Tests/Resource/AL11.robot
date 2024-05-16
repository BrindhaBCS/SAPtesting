
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5s
    Connect To Session
    Sleep    5
    Open Connection     ${symvar('Nike_connection')}
    Sleep   5
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER')}    
    Sleep    1
    # ${CFG_PASS}   OperatingSystem.Get Environment Variable    CFG_PASS
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS} 
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS')}  

    Sleep   2
    Send Vkey    0
    Sleep    5
    Take Screenshot    01_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    # Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

Transaction AL11

    Run Transaction     /nal11
    Send Vkey    0
    Take Screenshot    025_al11.jpg
    Sleep    2
    Table Scroll   wnd[0]/usr/cntlEXT_COM/shellcont/shell    23 
    Sleep    2
    Take Screenshot    026_al11.jpg