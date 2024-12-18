*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
library    ExcelLibrary
*** Keywords ***
 
 
System Logon
    Start Process     ${symvar('abinbev_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('abhinbev_SID')}  
    Sleep    5  
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('abinbev_clientno')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('abinbev_diaUsername')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('abinbev_diaUserpassword')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{diaUserpassword}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

Pre_SE16
    Run Transaction  SE16
    Sleep    2
    Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	HTTP_WHITELIST
	Send Vkey    0 
    Click Element	wnd[0]/tbar[1]/btn[8]
    ${tablecount}=    Count GUI Table Rows    wnd[0]/usr/lbl
    ${actual_rowcount}=    Evaluate    ${tablecount}-4
    Download the table
    # ${MANDT_values}   ${ENTRY_TYPE_values}   ${SORTKEY_values}   ${PROTOCOL_values}   ${HOST_values} =    Get Table Text    wnd[0]/usr/lbl    ${tablecount}  
    # Log To Console    MANDT_values=${MANDT_values}
    # Set Global Variable    ${MANDT_values}
    # Log To Console   ENTRY_TYPE_values=${ENTRY_TYPE_values}
    # Set Global Variable    ${ENTRY_TYPE_values}
    # Log To Console   SORTKEY_values=${SORTKEY_values}
    # Set Global Variable    ${SORTKEY_values}
    # Log To Console   PROTOCOL_values=${PROTOCOL_values}
    # Set Global Variable    ${PROTOCOL_values}
    # Log To Console    HOST_values= ${HOST_values}
    # Set Global Variable    ${HOST_values}
    # Log To Console    **gbStart**MANDT_values**splitKeyValue**${MANDT_values}**gbEnd**
    # Log To Console    **gbStart**ENTRY_TYPE_values**splitKeyValue**${ENTRY_TYPE_values}**gbEnd**
    # Log To Console    **gbStart**SORTKEY_values**splitKeyValue**${SORTKEY_values}**gbEnd**   
    # Log To Console    **gbStart**PROTOCOL_values**splitKeyValue**${PROTOCOL_values}**gbEnd**
    # Log To Console    **gbStart**HOST_values**splitKeyValue**${HOST_values}**gbEnd**

Download the table
    Run Keyword And Ignore Error    Delete Specific File    C:\\tmp\\smlg_report.xlsx
    Click Element	wnd[0]/mbar/menu[6]/menu[5]/menu[2]/menu[2]
    Sleep    5
    Select Radio Button    	wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Set Focus	wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Click Element	wnd[1]/tbar[0]/btn[0]
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	pre_SE16_report
    Sleep    2
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\TMP
	Sleep	2
	Set Focus	wnd[1]/usr/ctxtDY_PATH
	Sleep	2
    Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
    Open Excel Document    C:\\tmp\\pre_SE16_report.xlsx    Sheet1
    Process Excel    file_path=C:\\tmp\\pre_SE16_report.xlsx    sheet_name=Sheet1    column_index=0    
    ${pre_SE16_json}    Excel To Json    excel_file=C:\\tmp\\pre_SE16_report.xlsx   json_file=C:\\tmp\\pre_SE16_report.json  
    Log    ${pre_SE16_json}
    Set Global Variable    ${pre_SE16_json}
    Log To Console    **gbStart**Copilot_Status_json_Pre_SE16**splitKeyValue**${pre_SE16_json}**gbEnd**
    Close Current Excel Document


    