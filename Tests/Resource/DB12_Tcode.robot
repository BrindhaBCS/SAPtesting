*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
Library    ExcelLibrary
Library    String
Library    Collections
Library    DateTime
*** Variables ***
${Excel_file_path}    ${symvar('Excel_Name')}
${Excel_Sheet}    ${symvar('Sheet_Name')}

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('DTA_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('DTA_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('DTA_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('DTA_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{DTA_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
DB12_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B27
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E27
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E28
    IF  '${Tcode}' != 'DB12'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        Expand Sap Shell Node    table_shell=wnd[0]/shellcont[1]/shell/shellcont[1]/shell    row_number=100    column=Task
        Double Click Sap Shell Item    table_shell=wnd[0]/shellcont[1]/shell/shellcont[1]/shell    row_number=101    column=Task
        ${sent}    Get Value    element_id=wnd[0]/usr/txtHDB_OVERVIEW-LABEL_DB_STORAGE_DATA
        ${sent_value}    Get Value    element_id=wnd[0]/usr/txtHDB_OVERVIEW-DB_STORAGE_DATA
        ${ra}    Db12 Disk Calculate    data=${sent_value}
        IF    '${ra}' =='None'
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D28   value=3
        ELSE
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D28   value=1
        END
        ${sent_one}    Get Value    element_id=wnd[0]/usr/txtHDB_OVERVIEW-LABEL_DB_STORAGE_LOG
        ${sent_value_one}    Get Value    element_id=wnd[0]/usr/txtHDB_OVERVIEW-DB_STORAGE_LOG
        ${sent_two}    Get Value    element_id=wnd[0]/usr/txtHDB_OVERVIEW-LABEL_DB_STORAGE_TRACE
        ${sent_value_two}    Get Value    element_id=wnd[0]/usr/txtHDB_OVERVIEW-DB_STORAGE_TRACE
        ${Data_Volume}    Set Variable    ${sent} : ${sent_value}
        ${Log_Volume}    Set Variable    ${sent_one} : ${sent_value_one}
        ${Trace_files}    Set Variable    ${sent_two} : ${sent_value_two}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E28    value=${Data_Volume}
        ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E28
        ${new_value_one}    Set Variable    ${current_value}\n${Log_Volume}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E28    value=${new_value_one}
        ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E28
        ${new_one}    Set Variable    ${current_value}\n${Trace_files}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E28    value=${new_one}
        Sleep    0.5
        Expand Sap Shell Node    table_shell=wnd[0]/shellcont[1]/shell/shellcont[1]/shell    row_number=230    column=Task
        Double Click Sap Shell Item    table_shell=wnd[0]/shellcont[1]/shell/shellcont[1]/shell    row_number=155    column=Task
        ${p}    Get Column Value    shell_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    column=SYS_START_TIME
        ${m}    Get Column Value    shell_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    column=SYS_END_TIME
        ${backup}    Set Variable    Backup catalog : Start ${p} End ${m}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E27    value=${backup}
        Click Toolbar Button    table_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    button_id=LOG
        ${y}    Get Column Value    shell_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    column=SYS_START_TIME
        ${q}    Get Column Value    shell_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    column=SYS_END_TIME
        ${backup_two}    Set Variable    Log Backup : Start ${y} End ${q}
        ${current_value_er}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E27
        ${new_yq}    Set Variable    ${current_value_er}\n${backup_two}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E27    value=${new_yq}

        Click Toolbar Button    table_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    button_id=SHOWERRORS
        ${g}    Get Column Value    shell_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    column=SYS_START_TIME
        ${f}    Get Column Value    shell_id=wnd[0]/usr/cntlBACKUPCAT_ALV_CONTAINER/shellcont/shell    column=SYS_END_TIME
        ${backup_three}    Set Variable    Failed Backup: Start ${g} End ${f}
        ${current_value_error}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E27
        ${new_gf}    Set Variable    ${current_value_error}\n${backup_three}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E27    value=${new_gf}

    END