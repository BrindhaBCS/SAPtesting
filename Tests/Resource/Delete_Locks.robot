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

Delete Lock
    Run Transaction    /nsm12
    Input Text    wnd[0]/usr/txtSEQG3-GUNAME    ${EMPTY}
    Input Text    wnd[0]/usr/txtSEQG3-GUNAME    ${symvar('lock_user_name')}
    Click Element    wnd[0]/tbar[1]/btn[8]
    # Sleep    5
    ${row}    Get Row Count    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[0]/shell
    Log To Console    ${row}
    Search And Select Lock    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[0]/shell    ${symvar('table_name')}
    # Sleep    10
    Click Element    wnd[0]/tbar[1]/btn[14]
    Click Element    wnd[1]/usr/btnSPOP-OPTION1
    
