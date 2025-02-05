*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Idoc_SID')}
    Sleep    1   
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Idoc_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Idoc_User')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Idoc_Pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Idoc_Pass}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
  
System Logout
    Run Transaction   /nex
Execute Idoc
    Run Transaction    /nBD83
    Sleep    2
    Input Text    wnd[0]/usr/txtSO_DOCNU-LOW    ${symvar('Idoc_document_no')}
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    3
    ${a}    Get Sap Table Value    table_id=wnd[0]/usr/cntlGRID1/shellcont/shell    row_num=0    column_id=DOCNUM
    ${b}    Get Sap Table Value    table_id=wnd[0]/usr/cntlGRID1/shellcont/shell    row_num=0    column_id=STATXT
    ${level}    Set Variable    STATUS: ${b} for [IDOCNUM: ${a}]
    Log To Console    message=${level}
    Log To Console    **gbStart**Idoc_status**splitKeyValue**${level}**gbEnd**
        

