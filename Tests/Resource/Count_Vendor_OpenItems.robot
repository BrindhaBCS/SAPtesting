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
    Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   5
   
System Logout
    Run Transaction   /nex
    # Sleep    2
   
Vendor Open Items
    Run Transaction     /nfbl1n
    Sleep   4
    Input Text    wnd[0]/usr/ctxtKD_BUKRS-LOW    ${symvar('company_code')}
    # Sleep    2
    Click Element   wnd[0]/tbar[1]/btn[8]
    Sleep   2
    ${Open_Items}    Get Open Items    wnd[0]/sbar/pane[0]
    Log To Console    **gbStart**copilot_open_items**splitKeyValue**Number of open items in company code ${symvar('company_code')} is ${Open_Items}**gbEnd**