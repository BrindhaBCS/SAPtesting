*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
Library    ExcelLibrary
*** Variables *** 
${Results_Directory_Path}    ${CURDIR}
${Customer_Code}    ${symvar('Customer_Code')}
${Company_Code}    ${symvar('Company_Code')}
${FILE_NAME}    openitems.xlsx

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    4
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
checking for Customer Overdue
	Run Transaction    /nfbl5n
	Sleep	2
	Input Text    wnd[0]/usr/ctxtDD_KUNNR-LOW    ${Customer_Code}
	Sleep    1

	Input Text    wnd[0]/usr/ctxtDD_BUKRS-LOW    ${Company_Code}
	Sleep    1
    Send Vkey    vkey_id=8
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[56,8]
	Sleep	2
	Send Vkey    2
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[38]
	Sleep	2
	sendVKey    4
	Sleep	2
	Click Element	wnd[2]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep	2
	Delete Specific File    C:\\Robot framework\\Saptesting\\Tests\\Resource\\${FILE_NAME}
	Sleep    2
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	${FILE_NAME}
	Sleep	2
	Select From List By key    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    xlsx-TT
    Sleep    3
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	${Results_Directory_Path}
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	${json}    Excel To Json    excel_file=C:\\Robot framework\\Saptesting\\Tests\\Resource\\${FILE_NAME}    json_file=C:\\tmp\\openitems.json
	Sleep    2
	Log To Console    **gbStart**copilot_Json**splitKeyValue**${json}**gbEnd**
    Log To Console    ${json}  
	Sleep    2
	Delete Specific File    file_path=C:\\tmp\\openitems.json

	
	

	
	