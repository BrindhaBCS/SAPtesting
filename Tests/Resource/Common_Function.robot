*** Settings ***    
Library    Process
Library    CustomSapGuiLibrary.py
Library    OperatingSystem
Library    String


*** Variables ***
# ${EXE_PAD}  C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\saplogon.exe
# ${TITLE_PAD}    SAP Logon 760
# ${Connection_Name}  RBT
# ${SAP_CLIENT}   000
# ${SAP_USER}    DDIC


*** Keywords ***
System Logon
    Start Process    ${symvar('EXE_PAD')}
    Sleep   5s
    Connect To Session
    Sleep    5
    Open Connection     ${symvar('Connection_Name')}
    Sleep   5
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('SAP_CLIENT')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SAP_USER')}    
    Sleep    1
    # ${SAP_PASSWORD}   OperatingSystem.Get Environment Variable    SAP_PASSWORD
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SAP_PASSWORD')}    
    Sleep   2
    Send Vkey    0
    Sleep    5
    # Take Screenshot    01_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    # Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    # Take Screenshot    logoutpage.jpg
