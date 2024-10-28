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
ST06_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B11
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E11
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E12
    IF    '${Tcode}' != 'ST06'
        Log To Console    Check Your Transaction
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        TRY
            Expand St06
            select node    tree_id=wnd[0]/shellcont/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    node_id=${SPACE*10}4
            ${ans}    Select Node St06    tree_id=wnd[0]/shellcont/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    node_id=${SPACE*10}4
            Log    ${ans}
            ${A}    Check Value In Table    table_path=wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell    input_value=Idle    column_name=_DESCR1    second_column_name=_VALUE1
            ${new_value}    Set Variable    ${A}
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E11    value=${new_value}
            Double Click Node In Sap    element_path=wnd[0]/shellcont/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[1]/shell    row_number=7
            Sleep    0.5
            ${B}    Check Value In Table    table_path=wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell    input_value=/usr/sap    column_name=FSYSNAME    second_column_name=CAPACITY
            ${C}    Check Value In Table    table_path=wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell    input_value=/usr/sap    column_name=FSYSNAME    third_column_name=FREE
            ${D}    Check Value In Table    table_path=wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell    input_value=/usr/sap    column_name=FSYSNAME    fourth_column_name=FREE_PERCENT
            ${Data_One}    Set Variable    ${B} Size--${C} Free(MB)--${D} Free(%)
            ${E}    Check Value In Table    table_path=wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell    input_value=/sapmnt    column_name=FSYSNAME    second_column_name=CAPACITY
            ${F}    Check Value In Table    table_path=wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell    input_value=/sapmnt    column_name=FSYSNAME    third_column_name=FREE
            ${G}    Check Value In Table    table_path=wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell    input_value=/sapmnt    column_name=FSYSNAME    fourth_column_name=FREE_PERCENT
            ${Data_Two}    Set Variable    ${E} Size--${F} Free(MB)--${G} Free(%)
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E12    value=${Data_One}
            ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E12
            ${new_value_one}    Set Variable    ${current_value}\n${Data_Two}
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E12    value=${new_value_one}
        EXCEPT
            Log To Console    Check System Idle capacity..
        END
    END