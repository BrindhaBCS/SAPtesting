*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary



*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}    
    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_PASSWORD}   
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
System Logout
    Run Transaction   /nex
    Sleep    5
   

SMLG_ABLN
    Run Transaction	    SMLG
	Sleep	2
	Send Vkey	0
	Sleep	2
    Run Keyword And Ignore Error    Delete Specific File    ${symvar('Excel_path')}
    Click Element	wnd[0]/mbar/menu[4]/menu[5]/menu[4]
	Sleep	2
    Click Element    wnd[1]/tbar[0]/btn[0] 
    Sleep    1
    Click Element	wnd[0]/mbar/menu[4]/menu[5]/menu[2]/menu[2]
	Sleep	2
	Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	smlg_report
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\TMP
	Sleep	2
	Set Focus	wnd[1]/usr/ctxtDY_PATH
	Sleep	2
	
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
    Open Excel Document    ${symvar('Excel_path')}    ${symvar('Excel_sheet')}
    Process Excel    file_path=${symvar('Excel_path')}    sheet_name=${symvar('Excel_sheet')}    column_index=0
    
    ${SMLG_json}    Excel To Json    excel_file=${symvar('Excel_path')}   json_file=C:\\tmp\\smlg_report.json  
    Log    ${SMLG_json}
    Log To Console    **gbStart**Copilot_Status_json**splitKeyValue**${SMLG_json}**gbEnd**
    Close Current Excel Document
    
    



    



   