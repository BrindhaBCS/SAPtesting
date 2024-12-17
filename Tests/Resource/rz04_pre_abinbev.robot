*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
Library    Collections



*** Keywords ***
System Logon
    Start Process     ${symvar('ABLN_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('ABLN_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABLN_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABLN_User_Name')}    
    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABLN_PASSWORD}   
    Send Vkey    0
    # Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    # Take Screenshot    00_multi_logon_handling.jpg
System Logout
    Run Transaction   /nex
    Sleep    5
   

rz04_ABLN
    Run Transaction	    rz04
    Sleep    2
    Run Keyword And Ignore Error    Delete Specific File    C:\\tmp\\rz04_report.xlsx
    Click Element	wnd[0]/mbar/menu[3]/menu[5]/menu[2]/menu[2]
	Sleep	2
	Select Radio Button	wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Sleep	2
	
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	rz04_report
	Sleep	2
	Caret Position	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	4
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	2
    Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\TMP
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2

    Open Excel Document    C:\\tmp\\rz04_report.xlsx    Sheet1
    Process Excel    file_path=C:\\tmp\\rz04_report.xlsx    sheet_name=Sheet1    column_index=0
    
    
    ${rz04_json}    Excel To Json    excel_file=C:\\tmp\\rz04_report.xlsx   json_file=C:\\tmp\\rz04_report.json  
    Log    ${rz04_json}
    Log To Console    **gbStart**Copilot_Status_rz04**splitKeyValue**${rz04_json}**gbEnd**
    Close Current Excel Document
    Sleep    5

    Set Focus	wnd[0]/usr/lbl[2,5]
	Sleep	2
	
	Send Vkey	2
	Sleep	2

    ${header}    Get Value    wnd[0]/usr/lbl[2,1] 
    Log    ${header}
    ${host_name}    Get Value    wnd[0]/usr/lbl[2,3] 
    Log    ${host_name}
    ${operatio_mode}    Get Value    wnd[0]/usr/lbl[2,4] 
    log    ${operatio_mode}



Daymode
    Set Focus	wnd[0]/usr/lbl[31,9]
	Sleep	2
	
	Send Vkey	2
	Sleep	2
    
    ${app_server}    Get Value    wnd[1]/usr/txtSPFID-APSERVER 
    Log    ${app_server}
    ${operation_mode}    Get Value    wnd[1]/usr/txtSPFID-BANAME 
    Log    ${operation_mode}
    ${Dilog_proc}    Get Value    wnd[1]/usr/txtSPFID-WPNODIA 
    Log    ${Dilog_proc}  
    ${Dia_standby}    Get Value   wnd[1]/usr/txtSPFID-WPNORES
    Log    ${Dia_standby}
    ${Background}    Get Value    wnd[1]/usr/txtSPFID-WPNOBTC 
    Log    ${Background}
    ${job_class_a}    Get Value    wnd[1]/usr/txtSPFID-WPNOBTCA 
    Log    ${job_class_a}
    ${Update_process}    Get Value    wnd[1]/usr/txtSPFID-WPNOVB 
    Log    ${Update_process}
    ${v2_update_process}    Get Value    wnd[1]/usr/txtSPFID-WPNOV2 
    Log    ${v2_update_process}
    ${spool_process}    Get Value    wnd[1]/usr/txtSPFID-WPNOSPO 
    Log    ${spool_process}
    ${active_process}    Get Value    wnd[1]/usr/txtSPFID-WPNO 
    Log    ${active_process}
    ${max_configurable}    Get Value    wnd[1]/usr/txtSPFID-WPMAXCONFIG 
    Log    ${max_configurable}
    ${max_no_wps}    Get Value    wnd[1]/usr/txtSPFID-WPMAXNO 
    Log    ${max_no_wps}

    ${day_mo}    Create List  
    SAP_Tcode_Library.Append To List    ${day_mo}    app_server:${app_server}
    SAP_Tcode_Library.Append To List    ${day_mo}    operation_mode:${operation_mode}
    SAP_Tcode_Library.Append To List    ${day_mo}    Dilog_proc:${Dilog_proc}
    SAP_Tcode_Library.Append To List    ${day_mo}    Dia_standby:${Dia_standby}
    SAP_Tcode_Library.Append To List    ${day_mo}    Background:${Background}
    SAP_Tcode_Library.Append To List    ${day_mo}    job_class_a:${job_class_a}
    SAP_Tcode_Library.Append To List    ${day_mo}    Update_process:${Update_process}
    SAP_Tcode_Library.Append To List    ${day_mo}    v2_update_process:${v2_update_process}
    SAP_Tcode_Library.Append To List    ${day_mo}    spool_process:${spool_process}
    SAP_Tcode_Library.Append To List    ${day_mo}    active_process:${active_process}
    SAP_Tcode_Library.Append To List    ${day_mo}    max_configurable:${max_configurable}
    SAP_Tcode_Library.Append To List    ${day_mo}    max_no_wps:${max_no_wps}

    Log    ${day_mo}    
    Log To Console    **gbStart**Daymode_details**splitKeyValue**${day_mo}**gbEnd** 

    

    Click Element    wnd[1]/tbar[0]/btn[15] 


Nightmode
    
    Set Focus	wnd[0]/usr/lbl[31,12]
	Sleep	2
	
	Send Vkey	2
	Sleep	2
    

    ${app_server}    Get Value    wnd[1]/usr/txtSPFID-APSERVER 
    Log    ${app_server}
    ${operation_mode}    Get Value    wnd[1]/usr/txtSPFID-BANAME 
    Log    ${operation_mode}
    ${Dilog_proc}    Get Value    wnd[1]/usr/txtSPFID-WPNODIA 
    Log    ${Dilog_proc}  
    ${Dia_standby}    Get Value   wnd[1]/usr/txtSPFID-WPNORES
    Log    ${Dia_standby}
    ${Background}    Get Value    wnd[1]/usr/txtSPFID-WPNOBTC 
    Log    ${Background}
    ${job_class_a}    Get Value    wnd[1]/usr/txtSPFID-WPNOBTCA 
    Log    ${job_class_a}
    ${Update_process}    Get Value    wnd[1]/usr/txtSPFID-WPNOVB 
    Log    ${Update_process}
    ${v2_update_process}    Get Value    wnd[1]/usr/txtSPFID-WPNOV2 
    Log    ${v2_update_process}
    ${spool_process}    Get Value    wnd[1]/usr/txtSPFID-WPNOSPO 
    Log    ${spool_process}
    ${active_process}    Get Value    wnd[1]/usr/txtSPFID-WPNO 
    Log    ${active_process}
    ${max_configurable}    Get Value    wnd[1]/usr/txtSPFID-WPMAXCONFIG 
    Log    ${max_configurable}
    ${max_no_wps}    Get Value    wnd[1]/usr/txtSPFID-WPMAXNO 
    Log    ${max_no_wps}

    ${night_mo}    Create List  
    SAP_Tcode_Library.Append To List    ${night_mo}    app_server:${app_server}
    SAP_Tcode_Library.Append To List    ${night_mo}    operation_mode:${operation_mode}
    SAP_Tcode_Library.Append To List    ${night_mo}    Dilog_proc:${Dilog_proc}
    SAP_Tcode_Library.Append To List    ${night_mo}    Dia_standby:${Dia_standby}
    SAP_Tcode_Library.Append To List    ${night_mo}    Background:${Background}
    SAP_Tcode_Library.Append To List    ${night_mo}    job_class_a:${job_class_a}
    SAP_Tcode_Library.Append To List    ${night_mo}    Update_process:${Update_process}
    SAP_Tcode_Library.Append To List    ${night_mo}    v2_update_process:${v2_update_process}
    SAP_Tcode_Library.Append To List    ${night_mo}    spool_process:${spool_process}
    SAP_Tcode_Library.Append To List    ${night_mo}    active_process:${active_process}
    SAP_Tcode_Library.Append To List    ${night_mo}    max_configurable:${max_configurable}
    SAP_Tcode_Library.Append To List    ${night_mo}    max_no_wps:${max_no_wps}

    Log    ${night_mo}    
    Log To Console    **gbStart**nightmode_details**splitKeyValue**${night_mo}**gbEnd**    
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[15]