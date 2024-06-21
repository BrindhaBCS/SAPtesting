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

SE16_T_CODE
    Run Transaction     SE16
    Sleep    3
    Input Text        wnd[0]/usr/ctxtDATABROWSE-TABLENAME    E070L
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[7]
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SE16_E0701.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    SDOKPROF
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[7]
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Take Screenshot    SE16_SDOKPROF.jpg
    Sleep    1    
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    RSBASIDOC
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[7]
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Take Screenshot    SE16_RSBASIDOC.jpg
    Sleep    2