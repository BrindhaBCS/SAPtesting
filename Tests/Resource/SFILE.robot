*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
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
    Run Transaction    /nex
    Sleep    2
SFILE
    Run Transaction    /nSFILE
    Sleep    2
    Take Screenshot    sfile_1.jpg
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Expand Element    wnd[0]/shellcont/shell/shellcont[1]/shell[1]    ${SPACE*10}1
    Expand Element    wnd[0]/shellcont/shell/shellcont[1]/shell[1]    ${SPACE*10}2
    Sleep    2    
    Select Node Link    wnd[0]/shellcont/shell/shellcont[1]/shell[1]    ${SPACE*10}4    &Hierarchy
    Sleep    2
    Take Screenshot    sfile_2.jpg
    Sleep    2
    Select Node Link    wnd[0]/shellcont[0]/shell[0]/shellcont[1]/shell[1]    ${SPACE*10}8    &Hierarchy
    Sleep    2
    Take Screenshot    sfile_3.jpg
    Sleep    2
    Select Node Link    wnd[0]/shellcont[0]/shell[0]/shellcont[1]/shell[1]    ${SPACE*9}14    &Hierarchy
    Sleep    2
    Take Screenshot    sfile_4.jpg
    Sleep    2