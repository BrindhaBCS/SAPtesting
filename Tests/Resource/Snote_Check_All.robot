*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
Library    String
Resource    ../Web/Support_Web.robot
Library    ExcelLibrary
Library    openpyxl
*** Variables ***
@{SAP_Note}        3421256    3374186    3312428    3324052    3281776    
${Snote_Pass}    Snotes are available in the System
${Snote_Fail}    Snotes need to be added to the System
${filepath}    C:\\RobotFramework\\sap_testing\\Tests\\Resource\\Prerequisite_Status.xlsx
${sheetname}    Sheet1
*** Keywords ***
System Logon
    Start Process     ${symvar('ABAP_SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('ABAP_SID')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('RBT_USER_PASSWORD')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD}
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
SNOTE
    Run Transaction    /nsnote
    # Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[33]
    # Sleep    1   
    FOR    ${number}    IN    @{SAP_Note}
        Input Text    wnd[0]/usr/txtNUMM-LOW    ${number}
        # Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[8]
        # Sleep    3
        ${SAP_note_error}=    Get Value    wnd[0]/sbar/pane[0]
        IF    '${SAP_note_error}' == 'Unable to find SAP Note that meets specified criteria'
            Log    ${number}=${SAP_note_error}
            Log To Console    ${number}=${SAP_note_error}
        ELSE
            Double Click Current Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell    PRSTATUS
            # Sleep    2
            ${value}=    Get Value    wnd[0]/usr/subSUB_101:SAPLSCW_NA_SCREEN:0101/txtSCWB_S_SCREEN_NOTE-PRSTATUS_TEXT
            Log    ${number}=${value}
            IF    '${value}' == 'Cannot be implemented'
                Log    ${number}=${value}
                Log To Console    ${number}=${value}
                Click Element    wnd[0]/tbar[0]/btn[3]
                # Sleep    1
                Click Element    wnd[0]/tbar[0]/btn[3]
                # Sleep    1
            ELSE IF    '${value}' == 'Completely implemented'
                Log    ${number}=${value}
                Log To Console    ${number}=${value}
                Click Element    wnd[0]/tbar[0]/btn[3]
                # Sleep    1
                Click Element    wnd[0]/tbar[0]/btn[3]
                # Sleep    1
            ELSE IF    '${value}' == 'Can be implemented'
                Click Element    wnd[0]/tbar[0]/btn[3]
                # Sleep    2
                Click Element    wnd[0]/tbar[1]/btn[25]
                Window Handling    wnd[1]    Change processor of SAP Note 000${number}   wnd[1]/usr/btnSPOP-OPTION1
                Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
                Change Of Process    wnd[1]    wnd[1]/usr/btnSPOP-OPTION1
                # Sleep    2
                ${window}    Get Window Title    wnd[1]
                IF    "${window}" == "Queue of correction instructions to be installed"
                    ${status}    Get Value    wnd[1]/usr/txtGV_TEXT2
                    IF    "${status}" == "Confirm completion of the manual activities"
                        ${row}    Get Row Count    wnd[1]/usr/cntlCONTAINER/shellcont/shellcont/shell/shellcont[0]/shell
                        Log To Console    ${row}
                        # Sleep    10
                        Click Element    wnd[1]/tbar[0]/btn[9]
                        # Sleep    10
                        Click Element    wnd[1]/tbar[0]/btn[0]
                        # Sleep    2
                        Run Transaction    /nSE38
                        Input Text    wnd[0]/usr/ctxtRS38M-PROGRAMM    /SDF/JM_NOTE_CHECKPNT_3485517
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[8]
                        # Sleep    10
                        Select Radio Button    wnd[0]/usr/radUPDATE
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[8]
                        # Sleep    2
                        ${window_exist}    Run Keyword And Return Status    Element Should Be Present    wnd[1]
                        IF    '${window_exist}' == 'True'
                            Create Transport    wnd[1]    wnd[1]/tbar[0]/btn[8]    TR-ALM    wnd[2]/tbar[0]/btn[0]
                            # Sleep    2
                        ELSE
                            Log    Transport in SE38 job:/SDF/JM_NOTE_CHECKPNT_3485517 not file_exists
                        END
                        Run Transaction    /nsnote
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[33]
                        # Sleep    2
                        Input Text    wnd[0]/usr/txtNUMM-LOW    ${number}
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[8]
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[25]
                        # Sleep    2
                        Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
                        # Sleep    2
                        ${window1}    Get Window Title    wnd[1]
                        IF    "${window1}" == "Queue of correction instructions to be installed"
                            ${status1}    Get Value    wnd[1]/usr/txtGV_TEXT2
                            IF    "${status1}" == "Confirm completion of the manual activities"
                                ${row}    Get Row Count    wnd[1]/usr/cntlCONTAINER/shellcont/shellcont/shell/shellcont[0]/shell
                                Log To Console    ${row}
                                # Sleep    10
                                Click Element    wnd[1]/tbar[0]/btn[9]
                                # Sleep    10
                                Click Element    wnd[1]/tbar[0]/btn[0]
                                # Sleep    2
                            ELSE IF    "${status1}" == "Implement the automatic correction instructions"
                                Click Element    wnd[1]/tbar[0]/btn[13]
                            END
                        ELSE
                            Log To Console    Queue window doesn't exits after job execution
                        END
                    ELSE IF    "${status}" == "Implement the automatic correction instructions"
                        Click Element    wnd[1]/tbar[0]/btn[13]
                    END
                ELSE
                    Log To Console    Queue window doesn't exits  
                END
                Window Handling    wnd[1]    Confirmation: Manual action    wnd[1]/usr/btnBUTTON_1
                ${title}    Get Window Title    wnd[1]
                IF    "${title}" == "Confirm SAP Note Implementation"
                    Click Element    wnd[1]/usr/btnBUTTON_1
                ELSE IF    "${title}" == "Confirmation: SAP Note read"
                    Click Element    wnd[1]/usr/btnBUTTON_1                
                END
                Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
                Create Transport    wnd[1]    wnd[1]/tbar[0]/btn[8]    TR-ALM    wnd[2]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[1]    Object Editing: Initial Screen    wnd[1]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[1]    Confirm Changes    wnd[1]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[1]    Inactive Objects for ${symvar('ABAP_USER')}    wnd[1]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[2]    Activation Error    wnd[2]/usr/btnBUTTON_1
                # Sleep    5
                ${window_exist}    Run Keyword And Return Status    Element Should Be Present    wnd[1]
                IF    '${window_exist}' == 'True'
                    ${window2}    Get Window Title    wnd[1]
                    IF    "${window2}" == "Queue of correction instructions to be installed"
                        ${status2}    Get Value    wnd[1]/usr/txtGV_TEXT2
                        IF    "${status2}" == "Confirm completion of the manual activities"
                            ${row}    Get Row Count    wnd[1]/usr/cntlCONTAINER/shellcont/shellcont/shell/shellcont[0]/shell
                            Log    ${row}
                            # Sleep    10
                            Click Element    wnd[1]/tbar[0]/btn[9]
                            # Sleep    10
                            Click Element    wnd[1]/tbar[0]/btn[0]
                            # Sleep    2
                        ELSE IF    "${status2}" == "Implement the automatic correction instructions"
                            Click Element    wnd[1]/tbar[0]/btn[13]
                        END
                    ELSE
                        Log   Queue window doesn't exits after activation error
                    END
                ELSE
                    Log    Window wnd[1] does not exist
                END
                Window Handling    wnd[1]    Confirm SAP Note Implementation    wnd[1]/tbar[0]/btn[0]
                # Sleep    5
                Window Handling    wnd[1]    Queue of correction instructions to be installed    wnd[1]/tbar[0]/btn[13]
                # Sleep    5
                Window Handling    wnd[1]    Confirm Changes    wnd[1]/tbar[0]/btn[0]
                # Sleep    5
                Window Handling    wnd[1]    Inactive Objects for ${symvar('ABAP_USER')}    wnd[1]/tbar[0]/btn[0]
                # Sleep    5
                Click Element    wnd[0]/tbar[0]/btn[3]
            ELSE IF    '${value}' == 'Incompletely implemented'
                Click Element    wnd[0]/tbar[0]/btn[3]
                # Sleep    2
                Click Element    wnd[0]/tbar[1]/btn[25]
                Window Handling    wnd[1]    Change processor of SAP Note 000${number}   wnd[1]/usr/btnSPOP-OPTION1
                Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
                Change Of Process    wnd[1]    wnd[1]/usr/btnSPOP-OPTION1
                # Sleep    2
                ${window}    Get Window Title    wnd[1]
                IF    "${window}" == "Queue of correction instructions to be installed"
                    ${status}    Get Value    wnd[1]/usr/txtGV_TEXT2
                    IF    "${status}" == "Confirm completion of the manual activities"
                        ${row}    Get Row Count    wnd[1]/usr/cntlCONTAINER/shellcont/shellcont/shell/shellcont[0]/shell
                        Log To Console    ${row}
                        # Sleep    10
                        Click Element    wnd[1]/tbar[0]/btn[9]
                        # Sleep    10
                        Click Element    wnd[1]/tbar[0]/btn[0]
                        # Sleep    2
                        Run Transaction    /nSE38
                        Input Text    wnd[0]/usr/ctxtRS38M-PROGRAMM    /SDF/JM_NOTE_CHECKPNT_3485517
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[8]
                        # Sleep    2
                        Window Handling    wnd[1]    Execute/test object    wnd[1]/usr/btnBUTTON_1
                        # Sleep    10
                        ${title}    Get Window Title    wnd[0]
                        IF    "${title}" == "/SDF/JM_NOTE_CHECKPNT_3485517 - Note Implementation"
                            Select Radio Button    wnd[0]/usr/radUPDATE
                            # Sleep    2
                            Click Element    wnd[0]/tbar[1]/btn[8]
                            # Sleep    2
                            ${window_exist}    Run Keyword And Return Status    Element Should Be Present    wnd[1]
                            IF    '${window_exist}' == 'True'
                                Create Transport    wnd[1]    wnd[1]/tbar[0]/btn[8]    TR-ALM    wnd[2]/tbar[0]/btn[0]
                                # Sleep    2
                            ELSE
                                Log    Transport in SE38 job:/SDF/JM_NOTE_CHECKPNT_3485517 not file_exists
                            END
                        ELSE
                            ${status}    Get Value    wnd[0]/sbar/pane[0]
                            Log    ${status}
                        END                        
                        Run Transaction    /nsnote
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[33]
                        # Sleep    2
                        Input Text    wnd[0]/usr/txtNUMM-LOW    ${number}
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[8]
                        # Sleep    2
                        Click Element    wnd[0]/tbar[1]/btn[25]
                        # Sleep    2
                        Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
                        # Sleep    2
                        ${window1}    Get Window Title    wnd[1]
                        IF    "${window1}" == "Queue of correction instructions to be installed"
                            ${status1}    Get Value    wnd[1]/usr/txtGV_TEXT2
                            IF    "${status1}" == "Confirm completion of the manual activities"
                                ${row}    Get Row Count    wnd[1]/usr/cntlCONTAINER/shellcont/shellcont/shell/shellcont[0]/shell
                                Log To Console    ${row}
                                # Sleep    10
                                Click Element    wnd[1]/tbar[0]/btn[9]
                                # Sleep    10
                                Click Element    wnd[1]/tbar[0]/btn[0]
                                # Sleep    2
                            ELSE IF    "${status1}" == "Implement the automatic correction instructions"
                                Click Element    wnd[1]/tbar[0]/btn[13]
                            END
                        ELSE
                            Log To Console    Queue window doesn't exits after job execution
                        END
                    ELSE IF    "${status}" == "Implement the automatic correction instructions"
                        Click Element    wnd[1]/tbar[0]/btn[13]
                    END
                ELSE
                    Log To Console    Queue window doesn't exits
                END
                Window Handling    wnd[1]    Confirmation: Manual action    wnd[1]/usr/btnBUTTON_1
                ${title}    Get Window Title    wnd[1]
                IF    "${title}" == "Confirm SAP Note Implementation"
                    Click Element    wnd[1]/usr/btnBUTTON_1
                ELSE IF    "${title}" == "Confirmation: SAP Note read"
                    Click Element    wnd[1]/usr/btnBUTTON_1                
                END
                Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
                Create Transport    wnd[1]    wnd[1]/tbar[0]/btn[8]    TR-ALM    wnd[2]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[1]    Object Editing: Initial Screen    wnd[1]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[1]    Confirm Changes    wnd[1]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[1]    Inactive Objects for ${symvar('ABAP_USER')}    wnd[1]/tbar[0]/btn[0]
                # Sleep    10
                Window Handling    wnd[2]    Activation Error    wnd[2]/usr/btnBUTTON_1
                # Sleep    5
                ${window2}    Get Window Title    wnd[1]
                IF    "${window2}" == "Queue of correction instructions to be installed"
                    ${status2}    Get Value    wnd[1]/usr/txtGV_TEXT2
                    IF    "${status2}" == "Confirm completion of the manual activities"
                        ${row}    Get Row Count    wnd[1]/usr/cntlCONTAINER/shellcont/shellcont/shell/shellcont[0]/shell
                        Log To Console    ${row}
                        # Sleep    10
                        Click Element    wnd[1]/tbar[0]/btn[9]
                        # Sleep    10
                        Click Element    wnd[1]/tbar[0]/btn[0]
                        # Sleep    2
                    ELSE IF    "${status2}" == "Implement the automatic correction instructions"
                        Click Element    wnd[1]/tbar[0]/btn[13]
                    END
                ELSE
                    Log To Console    Queue window doesn't exits after activation error
                END
                Window Handling    wnd[1]    Confirm SAP Note Implementation    wnd[1]/tbar[0]/btn[0]
                # Sleep    5
                Window Handling    wnd[1]    Queue of correction instructions to be installed    wnd[1]/tbar[0]/btn[13]
                # Sleep    5
                Window Handling    wnd[1]    Confirm Changes    wnd[1]/tbar[0]/btn[0]
                # Sleep    5
                Window Handling    wnd[1]    Inactive Objects for ${symvar('ABAP_USER')}    wnd[1]/tbar[0]/btn[0]
                # Sleep    5
                Click Element    wnd[0]/tbar[0]/btn[3]
            END
        END
    END
    Log To Console   System ${symvar('ABAP_SID')} client ${symvar('ABAP_CLIENT')} -- Madatory Snotes Implemented Successfull
    Write Excel    ${filepath}    ${sheetname}    7    2    ${Snote_Pass}
    Write Excel    ${filepath}    ${sheetname}    7    3    Passed