*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
Library    openpyxl
*** Variables ***
${filepath}    C:\\RobotFramework\\sap_testing\\Tests\\Resource\\Prerequisite_Status.xlsx
${sheetname}    Sheet1
${Basis_success}    SAP BASIS version patch level met the criteria
${Basis_fail}    SAP BASIS version patch level too low. Need to Patch SAP BASIS Either 7.40 SP16 or higher
${SAP_UI_success}    SAP UI version patch level met the criteria
${SAP_UI_fail}    SAP BASIS and SAP UI version patch level too low. Need to Patch SAP_UI Either 740 SP15 or higher
${ST_PI_Success}    ST-PI patch version met the criteria
${ST_PI_Fail}    Latest patch of ST-PI needs to be applied

*** Keywords ***
System Logon
    Start Process    ${symvar('ABAP_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('ABAP_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABAP_PASSWORD')}
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
SAP BASIS Release
    Click Element    wnd[0]/mbar/menu[4]/menu[11]
    Click Element    wnd[1]/usr/btnPRELINFO
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_BASIS
    IF    '${version}' >= '750'
        Write Excel    ${filepath}    ${sheetname}    2    2    ${Basis_success}
        Write Excel    ${filepath}    ${sheetname}    2    3    Passed
    ELSE
        Write Excel    ${filepath}    ${sheetname}    2    2    ${Basis_fail}
        Write Excel    ${filepath}    ${sheetname}    2    3    Failed
    END

SAP UI Release
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_UI
    IF    '${version}' == '740'
        ${support_package}    software support package version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_UI
        IF    '${support_package}' >= 'SAPK-74014INSAPUI'
            Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_success}
            Write Excel    ${filepath}    ${sheetname}    3    3    Passed
        ELSE
            Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_fail}
            Write Excel    ${filepath}    ${sheetname}    3    3    Failed          
        END
    ELSE IF    '${version}' >= '740'
        Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_success}
        Write Excel    ${filepath}    ${sheetname}    3    3    Passed
    ELSE
        Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_fail}
            Write Excel    ${filepath}    ${sheetname}    3    3    Failed
    END

Component ST-PI Version
    Click Element    wnd[0]/mbar/menu[4]/menu[11]
    Click Element    wnd[1]/usr/btnPRELINFO
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ST-PI
    ${support_package}    software support package version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ST-PI
    IF    '${version}' == '740'
        IF    '${support_package}' == '${symvar('Current_Version')}'
            Write Excel    ${filepath}    ${sheetname}    4    2    ${ST_PI_Success}
            Write Excel    ${filepath}    ${sheetname}    4    3    Passed
        ELSE
            Log To Console    **gbStart**ST_PI_Status**splitKeyValue**Technical Prerequisties not met . ST-PI version too low.**gbEnd**            
        END
    ELSE IF    '${version}' >= '740'
        Write Excel    ${filepath}    ${sheetname}    4    2    ${ST_PI_Success}
        Write Excel    ${filepath}    ${sheetname}    4    3    Passed
    ELSE
        Log To Console    **gbStart**ST_PI_Status**splitKeyValue**Technical Prerequisties not met . ST-PI version too low.**gbEnd**
    END
    Log To Console    **gbStart**ST_PI_version**splitKeyValue**ST-PI ${version}**gbEnd**
    Log To Console    **gbStart**supportpackage**splitKeyValue**${support_package}**gbEnd**