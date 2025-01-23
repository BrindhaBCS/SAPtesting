
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    DateTime
*** Variables ***
${TREE_PATH}    wnd[0]/usr/cntlGUI_AREA/shellcont/shell/shellcont[1]/shell
${TREE_PATH_1}    wnd[0]/usr/cntlGUI_AREA/shellcont/shell/shellcont[0]/shell
 
*** Keywords ***
System Logon
    Start Process    ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection     ${symvar('Fiori_Connection')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Fiori_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Fiori_User_Name_1')}
    Sleep    1
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Fiori_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{Fiori_User_Password}
    Send Vkey    0
    Sleep    1
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
System Logout
    Run Transaction    /nex
    Sleep   1
Error_Capturing
    Run Transaction    /nstauthtrace
    Sleep    1
    Select Checkbox    wnd[0]/usr/subSUB_SELECTION:SAPLSUAUTHTRACE:1100/chkP1_DUP
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
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Fiori_Change_Date_Overall_Report
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    1
    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\FIORI\\
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    1
    Remove Rows Before Start Row    C:\\tmp\\FIORI\\Fiori_Change_Date_Overall_Report.xlsx    Sheet1    5
    Sleep    3
    Clean Excel Sheet    C:\\tmp\\FIORI\\Fiori_Change_Date_Overall_Report.xlsx    Sheet1
    Sleep    2
    Generate Html Report    C:\\tmp\\FIORI\\Fiori_Change_Date_Overall_Report.xlsx    C:\\tmp\\FIORI\\Fiori_Change_Date_Overall_Report.html
    Sleep    2
    # Transaction    /n/IWBEP/ERROR_LOG
    Run Transaction    /n/IWBEP/ERROR_LOG
    Sleep    5
    ${row_count}    Get Row Count    ${TREE_PATH}
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    9
        Log    Processing row ${i}
        ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    CHANGE_WBEP_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Sleep    1
    # Transaction    /n/IWFND/ERROR_LOG
    Run Transaction    /n/IWFND/ERROR_LOG
    Sleep    1
    ${row_count}    Get Row Count    ${TREE_PATH_1}
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    8
        Log    Processing row ${i}
        ${selected_rows}    Selected_rows    ${TREE_PATH_1}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    WFND_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Sleep    1
     ${row_count}    Get Row Count    ${TREE_PATH}
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    9
        Log    Processing row ${i}
        ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    WFND_1_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Sleep    1
    Deletefile
Deletefile
    Delete Specific File    file_path=C:\\tmp\\FIORI\\Fiori_Change_Role_extract.xlsx
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\FIORI\\Fiori_Change_Role_extract.txt
    Sleep    1