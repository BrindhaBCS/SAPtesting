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

SWU3
    Run Transaction    /nSWU3
    Sleep    1
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*10}1
    Take Screenshot    SWU3_1.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}13
    Take Screenshot    SWU3_2.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}17
    Take Screenshot    SWU3_3.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}22
    Take Screenshot    SWU3_4.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}29 
    Take Screenshot    SWU3_5.jpg
    Sleep    6