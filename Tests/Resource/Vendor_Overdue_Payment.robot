*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
 
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    # Sleep    5
    Connect To Session
    Open Connection    ${symvar('connection')}
    # Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('sap_client')}
    # Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('sap_user')}
    # Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    # Sleep   5
   
System Logout
    Run Transaction   /nex
   
pending payments
    Run Transaction     /nfbl1n
    # Sleep   2
    Input Text      wnd[0]/usr/ctxtKD_LIFNR-LOW     ${symvar('customer_no')}
    # Sleep   2
    Input Text    wnd[0]/usr/ctxtKD_BUKRS-LOW    ${symvar('company_code')}
    # Sleep    2
    Click Element   wnd[0]/tbar[1]/btn[8]
    Sleep    0.2
    Click Element    element_id=wnd[0]/tbar[1]/btn[32]
    Fbl1n Arrange
    Sleep    0.2
    Click Element    element_id=wnd[1]/tbar[0]/btn[0]
    Sleep    0.2
    # Sleep   2
    Click Element   wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    # Sleep   2
    Set Key Value    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    xlsx-TT
    # Sleep    10
    Click Element   wnd[1]/tbar[0]/btn[20]
    # Sleep   2
    Input Text      wnd[1]/usr/ctxtDY_PATH  ${EMPTY}
    # Sleep   2
    Input Text  wnd[1]/usr/ctxtDY_PATH      ${symvar('filepath')}
    # Sleep   2
    Input Text  wnd[1]/usr/ctxtDY_FILENAME    ${symvar('filename')}
    # Sleep   2
    Click Element   wnd[1]/tbar[0]/btn[0]