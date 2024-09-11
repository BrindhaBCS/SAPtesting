*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

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

SAP BASIS Release
    Click Element    wnd[0]/mbar/menu[4]/menu[11]
    Click Element    wnd[1]/usr/btnPRELINFO
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_BASIS
    IF    '${version}' >= '750'
        Log To Console    **gbStart**copilot_status2**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} SAP_BASIS Version Condition Met (${version})**gbEnd**
    ELSE
        Log To Console    **gbStart**copilot_status2**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} Technical Prerequisties not met . SAP BASIS version too low.**gbEnd**
    END

SAP UI Release
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_UI
    IF    '${version}' == '740'
        ${support_package}    software support package version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_UI
        IF    '${support_package}' >= 'SAPK-74014INSAPUI'
            Log To Console    **gbStart**copilot_status3**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} SAP_UI Version Condition Met ${version} and support package ${support_package}**gbEnd**
        ELSE
            Log To Console    **gbStart**copilot_status3**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} Technical Prerequisties not met . SAP UI version too low.**gbEnd**           
        END
    ELSE IF    '${version}' >= '740'
        Log To Console    **gbStart**copilot_status3**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} SAP_UI Version Condition Met ${version}**gbEnd**
    ELSE
        Log To Console    **gbStart**copilot_status3**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} Technical Prerequisties not met . SAP UI version too low.**gbEnd**
    END

Component ST-PI Version
    Click Element    wnd[0]/mbar/menu[4]/menu[11]
    Click Element    wnd[1]/usr/btnPRELINFO
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ST-PI
    ${support_package}    software support package version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ST-PI
    IF    '${version}' == '740'
        IF    '${support_package}' >= '${symvar('Current_Version')}'
            Log To Console    **gbStart**copilot_status4**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} Version of ST-PI is ${version} and support package is Up-To-Date ${support_package}**gbEnd**
        ELSE
            Log To Console    **gbStart**copilot_status4**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} Technical Prerequisties not met . ST-PI version too low.**gbEnd**            
        END
    ELSE IF    '${version}' >= '740'
        Log To Console    **gbStart**copilot_status4**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} Version of ST-PI is ${version}**gbEnd**
    ELSE
        Log To Console    **gbStart**copilot_status4**splitKeyValue**System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} Technical Prerequisties not met . ST-PI version too low.**gbEnd**
    END
    Log To Console    **gbStart**ST_PI_version**splitKeyValue**ST-PI ${version}**gbEnd**
    Log To Console    **gbStart**supportpackage**splitKeyValue**${support_package}**gbEnd**