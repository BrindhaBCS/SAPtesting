*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${File_path}    ${CURDIR}\\keyfile.txt
 

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    3s
    Connect To Session
    Open Connection    ${symvar('BPM_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('BPM_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('BPM_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE      ${symvar('BPM_User_Password')}  
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{BPM_User_Password}
    Send Vkey    0
    Sleep    1
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
System Logout
    Run Transaction     /nex

System Registration
    Run Transaction     /n/SDF/ALM_SETUP
    Sleep    2
    ${already exist}    Get Value    wnd[0]/usr/txtLMSIDCOM
    IF  '${already exist}' != ''
        Log To Console    System is already registered with ALM with : ${already exist}
        Log    System is already registered with ALM with : ${already exist}
        Set Global Variable     ${already exist}
        Log To Console    **gbStart**Copilot_Status**splitKeyValue**System is already registered with ALM :${already exist}**gbEnd**
    ELSE     
        Input Text    wnd[0]/usr/ctxtDEST    BCS_ALM
        Sleep    2
        Send Vkey    0
        Sleep    2
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
        Input Text    wnd[0]/usr/txtAUTHUSER    ALM_USER
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
        Log To Console    system successfully configured with : ${LMS_Configured}
        Log    system successfully configured with : ${LMS_Configured}
        Set Global Variable     ${LMS_Configured}
        Log To Console    **gbStart**Copilot_Status**splitKeyValue**system successfully configured :${LMS_Configured}**gbEnd**
    END
    
Click Task
    [Arguments]    ${row}
    Select Checkbox    wnd[1]/usr/tbl/SDF/ALM_SETUPTASKS_CONTROL/chkWA_CURRENT_TASK-ACTIVE[0,${row}]
    
    














  
