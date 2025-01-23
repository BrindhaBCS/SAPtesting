*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    DateTime
Library    Report_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SA_Role_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SA_Role_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SA_Role_User_Password}
    Send Vkey    0
    Sleep    1
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep    1
TEST_System_Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('New_User_Name')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Reset_Current_Password ')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{User_Reset_Current_Password}
    Send Vkey    0
    Sleep    1
System Logout
    Run Transaction     /nex

Create_date
    Run Transaction     /nse16
    Sleep    1
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    AGR_DEFINE
    Send Vkey    0
    Input Text    wnd[0]/usr/ctxtI4-LOW    ${symvar('Create_From_Date')}
    Sleep    0.5 seconds
    ${Get Current Date}    Get Current Date    result_format=%d.%m.%Y
    Input Text    wnd[0]/usr/ctxtI4-HIGH    ${symvar('Create_To_Date')}
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5 seconds
    #Clicking edit and giving download
    Click Element    wnd[0]/mbar/menu[1]/menu[5]
    Sleep    0.5 seconds
    #selecting xlsx format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Create_Role_extract
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\Role\\
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    0.5 seconds
    Roles extract    C:\\tmp\\Role\\Create_Role_extract.xlsx    Sheet1    C:\\tmp\\Role\\Create_Role_extract.txt
    Sleep    0.5 seconds
    #tcode se16
    Run Transaction     /nse16
    Sleep    1
    clear field text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    AGR_TCODES
    Send Vkey    0
    Sleep    0.5 seconds
    Click Element    wnd[0]/usr/btn%_I1_%_APP_%-VALU_PUSH
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[23]
    Sleep    0.5 seconds
    Input Text    wnd[2]/usr/ctxtDY_PATH    C:\\tmp\\Role\\
    Sleep    0.5 seconds
    Input Text    wnd[2]/usr/ctxtDY_FILENAME    Create_Role_extract.txt
    Sleep    0.5 seconds
    Click Element    wnd[2]/tbar[0]/btn[0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5 seconds
    #Clicking edit and giving download
    Click Element    wnd[0]/mbar/menu[1]/menu[5]
    Sleep    0.5 seconds
    #selecting xlsx format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Create_Tcode_extract
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\Role\\
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    1
    ${tcode_length}    Input Role Extract    C:\\tmp\\Role\\Create_Tcode_extract.xlsx    Sheet1
    Log    ${tcode_length}
    Log To Console    ${tcode_length}
    Sleep    1
    #Tcode_SU01
    Run Transaction    /nsu01
    Sleep    1
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}           #userfiled
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
    Sleep    0.5 seconds
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
    Sleep    1
    ${tech}    Get Sap Cell Value AGR NAME    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0
    Sleep    1
    IF    '${tech}' != ''
        Delete Allrole Save
        Sleep    1
        Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
        Sleep    0.5 seconds
        Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}         #userfiled
        Sleep    0.5 seconds
        Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
        Sleep    0.5 seconds
        Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
        Sleep    0.5 seconds
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG                    #role bar button
        Sleep    1
        ${roles_tcodes_items}    Evaluate    list(${tcode_length}.items())
        FOR    ${item}    IN    @{roles_tcodes_items}
            ${role}    ${tcodes}    Set Variable    ${item}
            Log    Role: ${role}
            Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0    ${role}
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[11]
            Sleep    1
            Run Transaction    /nstauthtrace
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[7]
            Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
            Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('New_User_Name')}
            Click Element    wnd[0]/tbar[1]/btn[6]
            System Logout
            Sleep    1
            TEST_System_Logon
            Sleep    1
            ${index}    Set Variable    1
            FOR    ${tcode}    IN    @{tcodes}
                Log    TCODE: ${tcode}
                Sleep    1
                Run Transaction    /n${tcode}
                Sleep    3
                ${CLEANED_TEXT}=  Remove String  ${role}    /
                Log  ${CLEANED_TEXT}
                ${CLEANED_TEXT_Two}=  Remove String  ${tcode}    /
                Log  ${CLEANED_TEXT_Two}
                Take Screenshot    ${index}_${CLEANED_TEXT}_${CLEANED_TEXT_Two}.jpg
                Sleep    1
                ${think}    Get Value    wnd[0]/sbar/pane[0]
                Sleep    1
                ${index}    Evaluate    ${index} + 1
                IF    '${think}' == 'You are not authorized to use transaction ${tcode}'
                    Log    !!!!! ${tcode} You are not authorized to use transaction.
                    Log To Console    !!!!! ${tcode} You are not authorized to use transaction.
                ELSE
                    Log   ${tcode} You are transaction will be authorized.
                    Log To Console   ${tcode} You are transaction will be authorized.
                END
            END
            System Logout
            System Logon
            Run Transaction    /nsu01
            Sleep    1
            Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
            Sleep    0.5 seconds
            Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[7]
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[19]
            Sleep    0.5 seconds
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    0.5 seconds
            Delete Allrole Save
            Sleep    0.5 seconds
            Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
            Sleep    0.5 seconds
            Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}         #userfiled
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
            Sleep    0.5 seconds
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG                    #role bar button
            Sleep    1 
        END
    ELSE    
        ${roles_tcodes_items}    Evaluate    list(${tcode_length}.items())
        FOR    ${item}    IN    @{roles_tcodes_items}
            ${role}    ${tcodes}    Set Variable    ${item}
            Log    Role: ${role}
            Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0    ${role}
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[11]
            Sleep    1
            Run Transaction    /nstauthtrace
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[7]
            Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
            Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('New_User_Name')}
            Click Element    wnd[0]/tbar[1]/btn[6]
            System Logout
            Sleep    1
            TEST_System_Logon
            Sleep    1
            ${index}    Set Variable    1
            FOR    ${tcode}    IN    @{tcodes}
                Log    TCODE: ${tcode}
                Sleep    1
                Run Transaction    /n${tcode}
                Sleep    3
                ${CLEANED_TEXT}=  Remove String  ${role}    /
                Log  ${CLEANED_TEXT}
                ${CLEANED_TEXT_Two}=  Remove String  ${tcode}    /
                Log  ${CLEANED_TEXT_Two}
                Take Screenshot    ${index}_${CLEANED_TEXT}_${CLEANED_TEXT_Two}.jpg
                Sleep    1
                ${think}    Get Value    wnd[0]/sbar/pane[0]
                Sleep    0.5 seconds
                ${index}    Evaluate    ${index} + 1
                IF    '${think}' == 'You are not authorized to use transaction ${tcode}'
                    Log    !!!!! ${tcode} You are not authorized to use transaction.
                    Log To Console    !!!!! ${tcode} You are not authorized to use transaction.
                ELSE
                    Log   ${tcode} You are transaction will be authorized.
                    Log To Console   ${tcode} You are transaction will be authorized.
                END
            END
            System Logout
            System Logon
            Run Transaction    /nsu01
            Sleep    1
            Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
            Sleep    0.5 seconds
            Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[7]
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[19]
            Sleep    0.5 seconds
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    0.5 seconds
            Delete Allrole Save
            Sleep    0.5 seconds
            Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
            Sleep    0.5 seconds
            Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}         #userfiled
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
            Sleep    0.5 seconds
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG                    #role bar button
            Sleep    0.5 seconds
        END
    END
    System Logout
    System Logon
    Run Transaction    /nstauthtrace
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Send Vkey    vkey_id=45
    Sleep    1 
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Clear Field Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    1
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Create_Date_Overall_Report
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    1
    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\Role\\
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    1
    Copy Images    source_dir=${OUTPUT_DIR}    target_dir=C:\\tmp\\Role\\Screendir\\Create\\
    Sleep    1
    Remove Rows Before Start Row    file_path=C:\\tmp\\Role\\Create_Date_Overall_Report.xlsx    sheet_name=Sheet1    start_row=5
    Sleep    3
    Clean Excel Sheet    file_path=C:\\tmp\\Role\\Create_Date_Overall_Report.xlsx    sheet_name=Sheet1
    Sleep    2
    Sarole Html Report    excel_file=C:\\tmp\\Role\\Create_Date_Overall_Report.xlsx    html_file=C:\\tmp\\Role\\Create_Date_Overall_Report.html    highlight_text="No authorization in user master record"

Deletefile
    Delete Specific File    file_path=C:\\tmp\\Role\\Create_Role_extract.xlsx
    Delete Specific File    file_path=C:\\tmp\\Role\\Create_Role_extract.txt
    Delete Specific File    file_path=C:\\tmp\\Role\\Create_Tcode_extract.xlsx
    Delete Specific File    file_path=C:\\tmp\\Role\\Create_Date_Overall_Report.xlsx
    Sleep    1