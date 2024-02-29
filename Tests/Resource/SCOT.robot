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
    # Input Text    wnd[0]/usr/txtRSYST-BNAME    SELENIUM    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    Test@12345
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

Transaction SCOT
    Run Transaction     /nscot
    Send Vkey    0
    Take Screenshot    017_scot.jpg
    Sleep    1
    
SMTP Nodes    
    Click Toolbar Button    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_TOOLBAR_CONTAINER/shellcont/shell  EXPA
    Doubleclick Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_COLUMN_TREE_CONT/shellcont/shell    SMTP    Node
    Sleep    1
    Take Screenshot    018_SMTP.jpg
    Send Vkey    0        
    Doubleclick Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_COLUMN_TREE_CONT/shellcont/shell    SMTP&-&INT    Node
    Sleep    1
    Take Screenshot    019_SMTP&INT.jpg
    Send Vkey   0

Settings Nodes
    Scot Tree    wnd[0]/shellcont/shell/shellcont[1]/shell           
    Sleep    1
    Take Screenshot    020_OutboundSettings.jpg

    Click Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_SETTINGS:0200/tabsGV_CNT_TABSTR_OUT/tabpSTATUS
    Sleep    1
    Take Screenshot    021_Statusrequest.jpg    
    
    Click Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_SETTINGS:0200/tabsGV_CNT_TABSTR_OUT/tabpA_OUT
    Sleep    1
    Take Screenshot    022_Anlys.jpg
    
    Click Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_SETTINGS:0200/tabsGV_CNT_TABSTR_OUT/tabpSIGN_ENCRYPT
    Sleep    1
    Take Screenshot    023_sig&encry.jpg
    Sleep    1
