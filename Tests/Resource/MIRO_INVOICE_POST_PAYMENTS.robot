*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Connect To Session
    Open Connection    ${symvar('MIRO_INVOICE_POST_PAYMENTS_Connection')}  
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MIRO_INVOICE_POST_PAYMENTS_Sap_client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MIRO_INVOICE_POST_PAYMENTS_Sap_user')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MIRO_INVOICE_POST_PAYMENTS_Sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MIRO_INVOICE_POST_PAYMENTS_SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]

   
System Logout
    Run Transaction   /nex
   
MIRO_INVOICE_POST_PAYMENTS
    Run Transaction     /nf-53
    Sleep   1
    Input Text    wnd[0]/usr/ctxtBKPF-BLDAT    ${symvar('Miro_post_payments_invoice_date')}
    Sleep    0.2 seconds
    Input Text    wnd[0]/usr/ctxtBKPF-BUKRS    ${symvar('Miro_post_payments_company_code')}
    Sleep    0.2 seconds
    Input Text    wnd[0]/usr/ctxtBKPF-WAERS    ${symvar('Miro_post_payments_currency_key')}
    Sleep    0.2 seconds
    Input Text    wnd[0]/usr/txtBKPF-BKTXT    ${symvar('Miro_post_payments_text')}
    Sleep    0.2 seconds
    Input Text    wnd[0]/usr/ctxtRF05A-KONTO    ${symvar('Miro_post_payments_account')}
    Sleep    0.2 seconds
    # ${p}    India To European Numeric    ${symvar('MIRO_Invoice_Total_Amount')}
    Input Text    wnd[0]/usr/txtBSEG-WRBTR    ${symvar('MIRO_Invoice_Total_Amount')}
    Sleep    0.2 seconds
    Input Text    wnd[0]/usr/ctxtBSEG-SGTXT    ${symvar('Miro_post_payments_text')}
    Sleep    0.2 seconds
    Input Text    wnd[0]/usr/ctxtRF05A-AGKON   ${symvar('Miro_post_payments_customer_no')}
    Sleep    0.2 seconds
    Select Radio Button    wnd[0]/usr/sub:SAPMF05A:0103/radRF05A-XPOS1[2,0]
    Sleep    0.2 seconds
    Click Element    wnd[0]/tbar[1]/btn[16]
    Sleep    1
    Input Text    wnd[0]/usr/sub:SAPMF05A:0731/txtRF05A-SEL01[0,0]    ${symvar('Miro_post_payments_document_no')}
    Sleep    0.2 seconds
    Click Element    wnd[0]/tbar[1]/btn[16]
    Sleep    0.2 seconds
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    1
    ${output}   Get Value    wnd[0]/sbar/pane[0]
    Log To Console      **gbStart**Miro_post_payments_copilot_status**splitKeyValue**${output}**gbEnd**