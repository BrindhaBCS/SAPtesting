*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Rpa_Connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Rpa_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Rpa_UserName')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Rpa_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Rpa_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
    
IBD_checkwithcurrentmonth
    Run Transaction    transaction=/nVL06i
    Sleep    1
    Click Element    element_id=wnd[0]/usr/btnBUTTON7
    Sleep    1
    ${start_date_month}    Get Start Day Of Month
    Input Text    element_id=wnd[0]/usr/ctxtIT_LFDAT-LOW    text=${start_date_month}
    ${end_date_month}    Get Last Day Of Month
    Input Text    element_id=wnd[0]/usr/ctxtIT_LFDAT-HIGH    text=${end_date_month}
    Input Text    element_id=wnd[0]/usr/ctxtIT_WBSTK-LOW    text=A
    Click Element    element_id=wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Click Element    element_id=wnd[0]/tbar[1]/btn[32]
    Click Toolbar Button    table_id=wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER1_LAYO/shellcont/shell    button_id=&FIND
    Input Text    element_id=wnd[2]/usr/txtGS_SEARCH-VALUE    text=Means of Trans. ID
    Click Element    element_id=wnd[2]/tbar[0]/btn[0]
    Click Element    element_id=wnd[2]/tbar[0]/btn[12]
    Click Element    element_id=wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/btnAPP_WL_SING
    Click Element    element_id=wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Click Element    element_id=wnd[0]/mbar/menu[0]/menu[5]/menu[1]
    Input Text    element_id=wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    text=Fulllist
    Select From List By Label    element_id=wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    value=Spreadsheet(*.xlsx)
    Click Element    element_id=wnd[1]/tbar[0]/btn[20] 
    Input Text    element_id=wnd[1]/usr/ctxtDY_PATH    text=C:\\tmp\\RPA\\
    Delete Specific File    file_path=C:\\tmp\\RPA\\Fulllist.xlsx
    Click Element    element_id=wnd[1]/tbar[0]/btn[0]
    Sleep    5
    Delete Specific File    file_path=C:\\tmp\\RPA\\Fulllist.json
    Sleep    1
    ${currenrtmonthjson}    Excel To Json    excel_file=C:\\tmp\\RPA\\Fulllist.xlsx    json_file=C:\\tmp\\RPA\\Fulllist.json
    Log To Console    message=**gbStart**copilot_status_currenrtmonth_list**splitKeyValue**${currenrtmonthjson}**splitKeyValue**object**gbEnd**
    Sleep    3
    ${result_transport}    Search Transport Id    json_file=C:\\tmp\\RPA\\Fulllist.json    transport_id=${symvar('Rpa_vehicle_number')}
    Log To Console    message=**gbStart**copilot_status_transport_result**splitKeyValue**${result_transport}**splitKeyValue**object**gbEnd**
    Sleep    3