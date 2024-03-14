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

RZ10
    Run Transaction    /nRZ10
    Sleep    2
    Send Vkey    4    window=0
    Sleep    1
    Set Focus    wnd[1]/usr/lbl[32,3]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Select Radio Button    wnd[0]/usr/radSPFL1010-EXPERT
    Sleep    1
    Click Element   wnd[0]/usr/btnSHOW_PUSH
    Sleep    1
    Take Screenshot    RZ10_1.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Send Vkey    4    window=0
    Sleep    1
    Set Focus    wnd[1]/usr/lbl[32,5]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Click Element   wnd[0]/usr/btnSHOW_PUSH
    Sleep    1
    Take Screenshot    RZ10_2.jpg
    Sleep    6