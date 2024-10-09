*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
Library    ExcelLibrary
*** Variables *** 
${Results_Directory_Path}    ${CURDIR}
${Customer_Code}    ${symvar('Overdue_Customer_Code')}
${Company_Code}    ${symvar('Overdue_Company_Code')}
${FILE_NAME}    Totaloverdue.xlsx
${FILE_OVERDUE}    Listoverdue.xlsx

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    4
    Connect To Session
    Open Connection    ${symvar('Overdue_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Overdue_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Overdue_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Overdue_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
checking for Customer Overdue
	Run Transaction    /nfbl5n
	Sleep	2
	Input Text    wnd[0]/usr/ctxtDD_KUNNR-LOW    ${Customer_Code}
	Sleep    0.5
	Input Text    wnd[0]/usr/ctxtDD_BUKRS-LOW    ${Company_Code}
	Sleep    0.5
    Send Vkey    vkey_id=8
	Sleep    0.5
	Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep    0.5
	Delete Specific File    C:\\tmp\\${FILE_NAME}
	Sleep    0.5
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	${FILE_NAME}
	Sleep    0.5
	Select From List By key    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    xlsx-TT
    Sleep    0.5
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	0.5
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp\\
	Sleep	0.5
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep    0.5
	${Total}    Print Account Row    C:\\tmp\\Totaloverdue.xlsx
	Log To Console    **gbStart**copilot_Status_One**splitKeyValue**Total Amount Of Open Items Is ${Total}**gbEnd**
    Sleep    0.5
	Set Focus	wnd[0]/usr/lbl[56,8]
	Sleep    0.5
	Send Vkey    2
	Sleep    0.5
	Click Element	wnd[0]/tbar[1]/btn[38]
	Sleep    0.5
	sendVKey    4
	Sleep    0.5
	Click Element	wnd[2]/tbar[0]/btn[0]
	Sleep    0.5
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep    0.5
	Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep    0.5
	Delete Specific File    C:\\tmp\\${FILE_OVERDUE}
	Sleep    0.5
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	${FILE_OVERDUE}
	Sleep    0.5
	Select From List By key    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    xlsx-TT
    Sleep    0.5
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	0.5
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp\\
	Sleep	0.5
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.5
	${Over}    Print Account Row    C:\\tmp\\Listoverdue.xlsx
	Log To Console    **gbStart**copilot_Status_Two**splitKeyValue**Total Overdue Amount ${over}**gbEnd**
	Sleep    0.5
	Delete Specific File    file_path=C:\\tmp\\Totaloverdue.xlsx
	Delete Specific File    file_path=C:\\tmp\\Listoverdue.xlsx



	
	

	
	