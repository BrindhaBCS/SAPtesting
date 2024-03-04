
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


Transaction ST06
    Run Transaction    /nST06  
    Sleep    2    
    Take Screenshot    st06.jpg  
    Select CPU    wnd[0]/shellcont/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[1]/shell    ${symvar('History_cpu')} 
    Sleep    2
    Take Screenshot    st06.jpg    
    Select CPU    wnd[0]/shellcont/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[1]/shell      ${symvar('History_memory')}
    Sleep    2
    Take Screenshot    st06Memory.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10