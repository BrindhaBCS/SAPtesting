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

SLDAPICUST
    Run Transaction    /nsldapicust
    Sleep    2
    Take Screenshot     sldapicust_1.jpg
    ${destination}  get cell value from gridtable       wnd[0]/usr/cntlCONTAINER/shellcont/shell
    Log     ${destination}
    Run Transaction     /nsm59
    Take Screenshot     sldapicust_2.jpg
    Click Element   wnd[0]/mbar/menu[1]/menu[5]
    Input Text  wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[0,24]       ${destination}
    Sleep   5
    Take Screenshot     sldapicust_3.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep  5s
    Take Screenshot     sldapicust_4.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   5s
    Take Screenshot     sldapicust_5.jpg
    Sleep   5s
    Click Element   wnd[0]/usr/tabsTAB_SM59/tabpSIGN
    Sleep   5s
    Take Screenshot     sldapicust_6.jpg  
    Sleep    6