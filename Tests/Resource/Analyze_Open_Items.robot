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
    Open Connection    ${symvar('connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('sap_client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('sap_user')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   5
   
System Logout
    Run Transaction   /nex
    Sleep    2
   
Open items
    Run Transaction     /ns_alr_87012178
    Sleep    4
    Click Element    wnd[0]/tbar[1]/btn[17]
    Sleep    2
    Spam Search And Select Label    wnd[1]/usr/cntlALV_CONTAINER_1/shellcont/shell    CO-PILOT
    Sleep    2
    Input Text    wnd[0]/usr/ctxtDD_KUNNR-LOW    ${symvar('customer_no')}
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    5