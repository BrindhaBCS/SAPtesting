*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('Idoc_SID')}
    Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Idoc_Client')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Idoc_User')}
    Sleep    2
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Idoc_Pass')}      
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Idoc_Pass}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   2
  
System Logout
    Run Transaction   /nex

Execute Idoc
    Run Transaction    /nBD83
    Sleep    2
    Input Text    wnd[0]/usr/txtSO_DOCNU-LOW    ${symvar('document_no')}
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    5

