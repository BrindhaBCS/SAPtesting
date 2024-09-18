*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Resource    ../Web/Support_Web.robot

*** Variables ***
${File_path}    ${CURDIR}\\keyfile.txt
 

*** Keywords ***
System Logon
    Start Process     ${symvar('ABAP_SAP_SERVER')}
    Sleep    3s
    Connect To Session
    Open Connection    ${symvar('ABAP_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE      %{ABAP_PASSWORD}  
    Send Vkey    0
    Window Handling    wnd[1]    Copyright    wnd[1]/tbar[0]/btn[0]
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
System Logout
    Run Transaction     /nex

System Registration
    Run Transaction     /n/SDF/ALM_SETUP
    Sleep    5
    ${already exist}    Get Value    wnd[0]/usr/txtLMSIDCOM
    IF  '${already exist}' != ''
        Set Global Variable     ${already exist}
        Log To Console    **gbStart**Copilot_Status**splitKeyValue**System is already registered with ALM :${already exist}**gbEnd**
    ELSE     
        Input Text    wnd[0]/usr/ctxtDEST    BCS_ALM
        Sleep    2
        Send Vkey    0
        Sleep    3
        ${is_destination_exists}    Run Keyword And Return Status    Element Should Be Visible and Enabled    wnd[0]/usr/btn%P017010_1000
        IF    "${is_destination_exists}" == "True"
            Click Element    wnd[0]/usr/btn%P017010_1000
        ELSE
            Log    Their is no existing http port for BCS_ALM
        END
        Sleep    3
        Click Element    wnd[0]/usr/btnUPD
        Sleep    2
        Click Element    wnd[1]/usr/btnPASTE
        Sleep    2
        ${get text}    Get File Content   ${File_path} 
        Log    ${get text}
        Input Text    wnd[1]/usr/cntlSEC_AP_CONTROL/shellcont/shell    ${get text}
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Click Element    wnd[2]/tbar[0]/btn[0]
        Sleep    2
        Input Text    wnd[0]/usr/txtAUTHUSER    ${symvar('ALM_User')}
        Sleep    2
        Click Element    wnd[0]/usr/btnREG
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Click Element    wnd[0]/usr/btn%P018047_1000
        Sleep    2
        FOR    ${desc}    IN    @{symvar('Give_Task_Descriptions')}
            FOR    ${i}    IN RANGE    0    1000
                ${data}    Get Value    wnd[1]/usr/tbl/SDF/ALM_SETUPTASKS_CONTROL/txtWA_CURRENT_TASK-DESCRIPTION[1,${i}]
                IF    '${data}' == ''
                    Log    No more tasks to check.
                    Exit For Loop
                END
                IF    '${data}' == '${desc}'
                    Log    Checking task: ${desc} against ${data}
                    Click Task    ${i}
                    Exit For Loop
                END
            END
        END
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Click Element    wnd[0]/usr/btn%P046053_1000
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Click Element    wnd[0]/usr/btn%P046053_1000
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        ${LMS_Configured}    Get Value    wnd[0]/usr/txtLMSIDCOM
        # Log To Console    system successfully configured with : ${LMS_Configured}
        # Log    system successfully configured with : ${LMS_Configured}
        Set Global Variable     ${LMS_Configured}
        Log To Console    **gbStart**Copilot_Status**splitKeyValue**System ${symvar('ABAP_Connection')} Client ${symvar('ABAP_CLIENT')} Successfully Configured in SAP Cloud ALM. LMS ID : ${LMS_Configured}**gbEnd**
    END
    
Click Task
    [Arguments]    ${row}
    Select Checkbox    wnd[1]/usr/tbl/SDF/ALM_SETUPTASKS_CONTROL/chkWA_CURRENT_TASK-ACTIVE[0,${row}]
    
