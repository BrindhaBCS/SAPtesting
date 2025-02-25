*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${ERROR_MESSAGE}    Could not find code page for receiving system

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

Check Idoc status
    Run Transaction    /nWE02
    Sleep    1
    # Input Text    wnd[0]/usr/tabsTABSTRIP_IDOCTABBL/tabpSOS_TAB/ssub%_SUBSCREEN_IDOCTABBL:RSEIDOC2:1100/ctxtCREDAT-LOW    11.02.2025
    # Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_IDOCTABBL/tabpSOS_TAB/ssub%_SUBSCREEN_IDOCTABBL:RSEIDOC2:1100/txtDOCNUM-LOW    ${symvar('Idoc_document_no')}
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Expand Node    wnd[0]/shellcont/shell    Statusrecord
    Sleep    1
    Doubleclick Element    wnd[0]/shellcont/shell	Statu${SPACE*1}1	Spalte1
	Sleep	2
    ${error_message}    Get Value    wnd[0]/usr/txtT100-TEXT 
    Log    ${error_message}
    Sleep    3
    
    IF  '${error_message}' == '${ERROR_MESSAGE}'
        Run Transaction    /nWE20
        Sleep    2
        Expand Node    wnd[0]/shellcont/shell    LS
        Sleep    1
        Select Node Link    wnd[0]/shellcont/shell    92${SPACE*8}LS    Column1
        Sleep    2
        Set Focus    wnd[0]/usr/tblSAPMSEDIPARTNERTC_EDP13/ctxtTCEDP13-RCVPOR[5,0]
        Sleep    2
        Send Vkey    2
        Sleep    2
        Send Vkey    2
        Sleep    2
        Clear Field Text    wnd[0]/usr/ctxtVED_EDIPOA-LOGDES
        Sleep    1
        Input Text    wnd[0]/usr/ctxtVED_EDIPOA-LOGDES    TS4CLNT001
        Sleep    2
        Click Element    wnd[0]/tbar[0]/btn[11]
        Sleep    2
        # Call BD83 processing after WE20
        Process BD83 Transaction
    ELSE
        Process BD83 Transaction
    END

Process BD83 Transaction
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