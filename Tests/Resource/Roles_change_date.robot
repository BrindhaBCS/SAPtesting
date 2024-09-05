*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    DateTime
*** Variables ***
${GLOBAL_TCODE_LENGTH}
${GLOBAL_ROLE_LENGTH}
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SA_Role_User_Name')}
    Sleep   1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SA_Role_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SA_Role_User_Password}
    Send Vkey    0
    Sleep    3
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
TEST_System_Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('New_User_Name')}
    Sleep   1
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Reset_Current_Password ')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{User_Reset_Current_Password}
    Send Vkey    0
    Sleep    3

System Logout
    Run Transaction     /nex
    Sleep   2

Change_Date
    Run Transaction     /nse16
    Sleep    2
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    AGR_DEFINE
    Send Vkey    0
    Input Text    wnd[0]/usr/ctxtI8-LOW    ${symvar('Change_From_Date')}
    Sleep    2
    ${Get Current Date}    Get Current Date    result_format=%d.%m.%Y
    Input Text    wnd[0]/usr/ctxtI8-HIGH    ${symvar('Change_To_Date')}
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    #Clicking edit and giving download
    Click Element    wnd[0]/mbar/menu[1]/menu[5]
    Sleep    2
    #selecting xlsx format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    2
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Change_Role_extract
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    2
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    2
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    2
    ${role_length}    Roles extract    C:\\tmp\\Change_Role_extract.xlsx    Sheet1    C:\\tmp\\Change_Role_extract.txt
    Set Global Variable    ${GLOBAL_ROLE_LENGTH}    ${role_length}  # Set it as a global variable
    Log    ${GLOBAL_ROLE_LENGTH}
    Sleep    2
    Run Transaction     /nse16
    Sleep    2
    clear field text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    AGR_TCODES
    Send Vkey    0
    Sleep    2
    Click Element    wnd[0]/usr/btn%_I1_%_APP_%-VALU_PUSH
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[23]
    Sleep    2
    Input Text    wnd[2]/usr/ctxtDY_PATH    C:\\tmp\\
    Sleep    2
    Input Text    wnd[2]/usr/ctxtDY_FILENAME    Change_Role_extract.txt
    Sleep    2
    Click Element    wnd[2]/tbar[0]/btn[0]
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    #Clicking edit and giving download
    Click Element    wnd[0]/mbar/menu[1]/menu[5]
    Sleep    2
    #selecting xlsx format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    2
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Change_Tcode_extract
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    2
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    2
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    1
    ${role_length}    Roles Extract    file_location=C:\\tmp\\Change_Tcode_extract.xlsx    sheet_name=Sheet1
    Set Global Variable    ${GLOBAL_ROLE_LENGTH}    ${role_length}            # global variable
    Log    ${role_length}
    ${tcode_length}    Tcode Extract    C:\\tmp\\Change_Tcode_extract.xlsx    Sheet1
    Set Global Variable    ${GLOBAL_TCODE_LENGTH}    ${tcode_length}  # Set it as a global variable
    Log    ${GLOBAL_TCODE_LENGTH}
    Sleep    1
     #Tcode_SU01
    Run Transaction    /nsu01
    Sleep    1
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}           #userfiled
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
    Sleep    1
    ${last_name}    Get Value    wnd[0]/usr/tabsTABSTRIP1/tabpADDR/ssubMAINAREA:SAPLSUID_MAINTENANCE:1900/txtSUID_ST_NODE_PERSON_NAME-NAME_LAST
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
    Sleep    1
    ${tech}    Get Sap Cell Value AGR NAME    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0
    IF  '${tech}' != ''
        Delete Allrole Save
        Sleep    1
        Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
        Sleep    1
        Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}         #userfiled
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
        Sleep    1
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG                    #role bar button
        Sleep    1
        ${desc}    Get Length    ${GLOBAL_ROLE_LENGTH}
        FOR    ${loop}    IN RANGE    0    ${desc}
            ${value} =    Set Variable    ${GLOBAL_ROLE_LENGTH[${loop}]}
            Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0    ${value}
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[11]
            Sleep    1
            Run Transaction    /nstauthtrace
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[7]
            Sleep    1
            Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
            Sleep    1
            Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('New_User_Name')}
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[6]
            Sleep    1
            System Logout
            Sleep    1
            TEST_System_Logon
            Sleep    1
            # second loop based current value
            ${aesc}    Set Variable    1
            FOR    ${j}    IN RANGE    ${loop}    ${loop + ${aesc}}
                ${input} =    Set Variable    ${GLOBAL_TCODE_LENGTH[${j}]}
                Sleep    1
                Run Transaction    /n${input}
                Sleep    4
                Take Screenshot    tcode_${j}.jpg
                Sleep    2
                ${think}    Get Value    wnd[0]/sbar/pane[0]
                Sleep    1
                IF    '${think}' == 'You are not authorized to use transaction ${input}'
                    Sleep    1
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
                    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Create_Date_${input}_${value}
                    Sleep    1
                    Click Element    wnd[1]/tbar[0]/btn[20]
                    Sleep    1
                    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
                    Sleep    1
                    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
                    Sleep    1
                    Click Element    wnd[1]/tbar[0]/btn[11]
                    Sleep    1
                    Run Transaction    /nsu01
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}        #userfiled
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
                    Sleep    1
                    Delete Allrole Save
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]            #displayicon
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]                #change&displayicon
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG        #role bar button
                    Sleep    1
                    Exit For Loop
                ELSE    
                    Log    ${input} You are transaction will be authorized.
                    Log To Console    ${input} You are transaction will be authorized.
                    System Logout
                    System Logon
                    Run Transaction    /nsu01
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Create_Date_User_Name')}
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
                    Sleep    1
                    Delete Allrole Save
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Create_Date_User_Name')}         #userfiled
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG                    #role bar button
                    Sleep    1
                    Exit For Loop
                END
            END
        END
    ELSE    
        ${desc}    Get Length    ${GLOBAL_ROLE_LENGTH}
        FOR    ${loop}    IN RANGE    0    ${desc}
            ${value} =    Set Variable    ${GLOBAL_ROLE_LENGTH[${loop}]}
            Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0    ${value}
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[11]
            Sleep    1
            Run Transaction    /nstauthtrace
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[7]
            Sleep    1
            Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
            Sleep    1
            Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('Create_Date_User_Name')}
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[6]
            Sleep    1
            System Logout
            Sleep    1
            TEST_System_Logon
            Sleep    1
            ${aesc}    Set Variable    1
            FOR    ${j}    IN RANGE    ${loop}    ${loop + ${aesc}}
                ${input} =    Set Variable    ${GLOBAL_TCODE_LENGTH[${j}]}
                Sleep    1
                Run Transaction    /n${input}
                Sleep    4
                Take Screenshot    tcode_${j}.jpg
                Sleep    2
                ${think}    Get Value    wnd[0]/sbar/pane[0]
                Sleep    1
                IF    '${think}' == 'You are not authorized to use transaction ${input}'
                    Sleep    1
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
                    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Create_Date_${input}_${value}
                    Sleep    1
                    Click Element    wnd[1]/tbar[0]/btn[20]
                    Sleep    1
                    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
                    Sleep    1
                    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
                    Sleep    1
                    Click Element    wnd[1]/tbar[0]/btn[11]
                    Sleep    1
                    Run Transaction    /nsu01
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Create_Date_User_Name')}
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
                    Sleep    1
                    Delete Allrole Save
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Create_Date_User_Name')}
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
                    Sleep    1
                    Exit For Loop
                ELSE    
                    Log    ${input} You are transaction will be authorized.
                    Log To Console    ${input} You are transaction will be authorized.
                    System Logout
                    System Logon
                    Run Transaction    /nsu01
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Create_Date_User_Name')}
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
                    Sleep    1
                    Delete Allrole Save
                    Sleep    1
                    Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
                    Sleep    1
                    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Create_Date_User_Name')}         #userfiled
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
                    Sleep    1
                    Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
                    Sleep    1
                    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG                    #role bar button
                    Sleep    1
                    Exit For Loop
                END
            END
        END
    END

Delete_file
    Delete Specific File    file_path=C:\\tmp\\Change_Role_extract.xlsx
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\Change_Role_extract.txt
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\Change_Tcode_extract.xlsx
    Sleep    1