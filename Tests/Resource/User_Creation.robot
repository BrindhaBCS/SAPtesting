*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    SAP_Tcode_Library.py
Library    ExcelLibrary
Library    openpyxl
*** Variables ***
${filepath}    C:\\RobotFramework\\sap_testing\\Tests\\Resource\\Prerequisite_Status.xlsx
${sheetname}    Sheet1

*** Keywords *** 
System Logon
    Start Process    ${symvar('ABAP_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('ABAP_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document
Create User
    Run Transaction    /nSU01
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('ALM_User')}
    Click Element    wnd[0]/tbar[1]/btn[8]
    Window Handling    wnd[1]    Address Maintenance      wnd[1]/usr/btnBUTTON_2
    ${user}    To Upper    ${symvar('ALM_User')}
    ${status}    Get Value    wnd[0]/sbar/pane[0]
    IF    '${status}' == 'User ${user} already exists'
        Write Excel    ${filepath}    ${sheetname}    8    2    ${status}
        Write Excel    ${filepath}    ${sheetname}    8    3    Passed
    ELSE
        Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpADDR/ssubMAINAREA:SAPLSUID_MAINTENANCE:1900/txtSUID_ST_NODE_PERSON_NAME-NAME_LAST    ${symvar('ALM_User')}
        Click Element     wnd[0]/usr/tabsTABSTRIP1/tabpLOGO

        Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD    ${symvar('ALM_pass')}
        Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD2    ${symvar('ALM_pass')}
        
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpPROF
        Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell    0    PROFILE    SAP_ALL
        Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell    1    PROFILE    SAP_NEW
        
        Click Element    wnd[0]/tbar[0]/btn[11]
        ${output}   Get Value    wnd[0]/sbar/pane[0]
        Write Excel    ${filepath}    ${sheetname}    8    2    ${output}
        Write Excel    ${filepath}    ${sheetname}    8    3    Passed
    END
