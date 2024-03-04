
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py



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


Transaction DB02
    Sleep   5
    Run Transaction     /nDB02
    Sleep   5
    Select Node   wnd[0]/shellcont[1]/shell/shellcont[1]/shell  ${symvar('Link_id1')}   ${symvar('Link_id2')}
    Sleep   5
    Take Screenshot    DB02.jpg1
    Sleep   2
    Select Tree Items   wnd[0]/shellcont[1]/shell/shellcont[1]/shell  ${symvar('Link_id3')}   ${symvar('Link_id2')}
    Sleep   5
    Take Screenshot    DB02.jpg2
    Sleep   2
    Select Tree Items   wnd[0]/shellcont[1]/shell/shellcont[1]/shell  ${symvar('Link_id4')}   ${symvar('Link_id2')}
    Sleep   5
    Take Screenshot    DB02.jpg3
    Sleep   2

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10