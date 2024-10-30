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
ST03_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B25
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E25
    IF  '${Tcode}' != 'ST03'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        Select Dropdown Shell    shell_id=wnd[0]/shellcont/shell/shellcont[0]/shell    context_button=UMOD    menu_item=UMTC
        Sleep    0.5
        Expand Node    tree_id=wnd[0]/shellcont/shell/shellcont[1]/shell    node_id=B
        Expand Node    tree_id=wnd[0]/shellcont/shell/shellcont[1]/shell    node_id=B.A
        Double Click On Tree Item    tree_id=wnd[0]/shellcont/shell/shellcont[1]/shell    id=B.A.999
        ${A}    Check Value In Table    table_path=wnd[0]/usr/ssubSUBSCREEN_0:SAPWL_ST03N:1100/ssubWL_SUBSCREEN_1:SAPWL_ST03N:1110/tabsG_TABSTRIP/tabpTA00/ssubWL_SUBSCREEN_2:SAPWL_ST03N:1130/cntlALVCONTAINER/shellcont/shell    input_value=DIALOG    column_name=TASKTYPE    second_column_name=MPROCTI
        ${B}    Check Value In Table    table_path=wnd[0]/usr/ssubSUBSCREEN_0:SAPWL_ST03N:1100/ssubWL_SUBSCREEN_1:SAPWL_ST03N:1110/tabsG_TABSTRIP/tabpTA00/ssubWL_SUBSCREEN_2:SAPWL_ST03N:1130/cntlALVCONTAINER/shellcont/shell    input_value=DIALOG    column_name=TASKTYPE    second_column_name=MCPUTI
        ${Time}    Set Variable    Previous week:Aver.poc.time :${A}---CPU.time :${B}
        Expand Node    tree_id=wnd[0]/shellcont/shell/shellcont[1]/shell    node_id=B.B
        Double Click On Tree Item    tree_id=wnd[0]/shellcont/shell/shellcont[1]/shell    id=B.B.999
        Click Element    wnd[1]/usr/btnBUTTON_1
        ${C}    Check Value In Table    table_path=wnd[0]/usr/ssubSUBSCREEN_0:SAPWL_ST03N:1100/ssubWL_SUBSCREEN_1:SAPWL_ST03N:1110/tabsG_TABSTRIP/tabpTA00/ssubWL_SUBSCREEN_2:SAPWL_ST03N:1130/cntlALVCONTAINER/shellcont/shell    input_value=DIALOG    column_name=TASKTYPE    second_column_name=MPROCTI
        ${D}    Check Value In Table    table_path=wnd[0]/usr/ssubSUBSCREEN_0:SAPWL_ST03N:1100/ssubWL_SUBSCREEN_1:SAPWL_ST03N:1110/tabsG_TABSTRIP/tabpTA00/ssubWL_SUBSCREEN_2:SAPWL_ST03N:1130/cntlALVCONTAINER/shellcont/shell    input_value=DIALOG    column_name=TASKTYPE    second_column_name=MCPUTI
        ${Time_o}    Set Variable    Today:Aver.poc.time :${C}---CPU.time :${D}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E25    value=${Time}
        ${cur}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E25
        ${write}    Set Variable    ${cur}\n${Time_o}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E25    value=${write}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D25   value=1
    END