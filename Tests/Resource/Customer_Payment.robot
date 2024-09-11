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
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   5
   
System Logout
    Run Transaction   /nex
    Sleep    2
   
Customer payments
    Run Transaction     /nf-28
    Sleep   4
    Input Text    wnd[0]/usr/ctxtBKPF-BLDAT    ${symvar('invoice_date')}
    Sleep   4
    Input Text    wnd[0]/usr/ctxtBKPF-BUKRS    ${symvar('company_code')}
    Sleep    2
    Input Text    wnd[0]/usr/ctxtBKPF-WAERS    ${symvar('currency_key')}
    Sleep    2
    Input Text    wnd[0]/usr/txtBKPF-BKTXT    ${symvar('text')}
    Sleep    2
    Input Text    wnd[0]/usr/ctxtRF05A-KONTO    ${symvar('account')}
    Sleep    2
    Input Text    wnd[0]/usr/txtBSEG-WRBTR    ${symvar('amount')}
    Sleep    2
    Input Text    wnd[0]/usr/ctxtBSEG-SGTXT    ${symvar('text')}
    Sleep    2
    Input Text    wnd[0]/usr/ctxtRF05A-AGKON   ${symvar('customer_no')}
    Sleep    2
    Select Radio Button    wnd[0]/usr/sub:SAPMF05A:0103/radRF05A-XPOS1[2,0]
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[16]
    Sleep    2
    Input Text    wnd[0]/usr/sub:SAPMF05A:0731/txtRF05A-SEL01[0,0]    ${symvar('document_no')}
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[16]
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    4
    ${output}   Get Value    wnd[0]/sbar/pane[0]
    Log To Console      **gbStart**copilot_status**splitKeyValue**${output}**gbEnd**

