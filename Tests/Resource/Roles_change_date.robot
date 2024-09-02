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
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Change_Date_User_Name')}
    Sleep   1
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('New_User_Password')}
    Send Vkey    0
    Sleep    3
    Input Password    wnd[1]/usr/pwdRSYST-NCODE    ${symvar('User_Reset_Password')}       #%{Change_Date_User_Password}
    Sleep    2
    Input Password    wnd[1]/usr/pwdRSYST-NCOD2    ${symvar('User_Reset_Password')}    #%{Change_Date_User_Password}
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Window Handling    wnd[1]    Copyright    wnd[1]/tbar[0]/btn[0]
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
    Sleep   2

Change Date
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
    Sleep    5
    ${tcode_length}    Tcode Extract    C:\\tmp\\Change_Tcode_extract.xlsx    Sheet1
    Set Global Variable    ${GLOBAL_TCODE_LENGTH}    ${tcode_length}  # Set it as a global variable
    Log    ${GLOBAL_TCODE_LENGTH}
    Sleep    5
Create new user
    Run Transaction    /nSU01
    Sleep   1
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Change_Date_User_Name')}
    Sleep   1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    5
    Window Handling    wnd[1]    Address Maintenance      wnd[1]/usr/btnBUTTON_2
    Sleep    5
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpADDR/ssubMAINAREA:SAPLSUID_MAINTENANCE:1900/txtSUID_ST_NODE_PERSON_NAME-NAME_LAST    ${symvar('New_User_Last_Name')}
    Click Element     wnd[0]/usr/tabsTABSTRIP1/tabpLOGO
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD    ${symvar('New_User_Password')}
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD2    ${symvar('New_User_Password')}
    Sleep    2   
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
    Sleep    1
    ${tech}    Get Sap Cell Value AGR NAME    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0
    IF  '${tech}' != ''
        Delete Allrole Save
        Sleep    1
        Clear Field Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME
        Sleep    2
        Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Change_Date_User_Name')}           #userfiled
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
        Sleep    1
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG                    #role bar button
        Sleep    2
        ${desc}    Get Length    ${GLOBAL_ROLE_LENGTH}
        FOR    ${loop}    IN RANGE    0    ${desc}
            ${value} =    Set Variable    ${GLOBAL_ROLE_LENGTH[${loop}]}
            Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${loop}    ${value}
            Sleep    1
        END
    ELSE    
        ${desc}    Get Length    ${GLOBAL_ROLE_LENGTH}
        FOR    ${loop}    IN RANGE    0    ${desc}
            ${value} =    Set Variable    ${GLOBAL_ROLE_LENGTH[${loop}]}
            Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${loop}    ${value}
            Sleep    1
        END
    END
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    3
    Run Transaction    /nstauthtrace
    Sleep    3
    Click Element    wnd[0]/tbar[1]/btn[7]
    Sleep    4
    Set Focus    wnd[0]/usr/ctxtSC_100_TRACE_USER
    Sleep    2
    Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
    Sleep    2
    Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('Change_Date_User_Name')}
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[6]
    Sleep    3 
Test_User
    ${aesc}    Get Length    ${GLOBAL_TCODE_LENGTH}
    FOR    ${j}    IN RANGE    0    ${aesc}
        ${input} =    Set Variable    ${GLOBAL_TCODE_LENGTH[${j}]}
        Sleep    1
        Run Transaction    /n${input}
        Sleep    1
        Take Screenshot    tcode_${j}.jpg
        Sleep    1
    END
Own_User
    Run Transaction    /nstauthtrace
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    # Click Element    wnd[0]/mbar/menu[0]/menu[1]/menu[2]                #excel_extract
    # Sleep    1
    Send Vkey    vkey_id=45
    Sleep    1 
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    2
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Change_Date_Overall_Report
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    2
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    2
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    2
    # Send Mail    from_email=suryaprakash.r@basiscloudsolutions.com    password=********    to_mail=@{mail}    subject="Status of stauthtrace"     content=Today_Create_date_file_report   file_path=C:\\tmp\\Create_date_report.xlsx

Deletefile
    Delete Specific File    file_path=C:\\tmp\\Change_Role_extract.xlsx
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\file_name=Change_Role_extract.txt
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\file_name=Change_Tcode_extract.xlsx
    Sleep    1