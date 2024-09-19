*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
Library    collections

*** Keywords ***
System Logon
    Start Process     ${symvar('BILLING_SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('BILLING_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('BILLING_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('BILLING_User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('BILLING_User_Password')}
    Send Vkey    0
    Sleep    5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

Billing Documents Not Posted to Accounting
    Run Transaction    VFX3
	Sleep	2
	Select Checkbox    wnd[0]/usr/chkRFBSK_AB	
	Sleep	2
	Input Text	wnd[0]/usr/ctxtVKORG	${symvar('sales_organation')}
	Sleep	2
	Input Text	wnd[0]/usr/txtERNAM-LOW    ${symvar('create_by')}
	Sleep	2
	Set Focus	wnd[0]/usr/radP_UTASY
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
    ${Total_row}    Get Row Count    wnd[0]/usr/cntlGRID1/shellcont/shell 
    Log To Console    ${Total_row}
    ${coulumn_value}    Read Table Column    wnd[0]/usr/cntlGRID1/shellcont/shell    VBELN
    
    Set Global Variable    ${coulumn_value}
    Log To Console    **gbStart**Copilot_Status**splitKeyValue**${coulumn_value}**gbEnd**

    Click Element	wnd[0]/mbar/menu[0]/menu[1]/menu[2]
	Sleep	2
	Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Sleep	2
	
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
    Clear Field Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    biling_documents
	Sleep	2
	
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	2

    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
    Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp
	Sleep	2
	Set Focus	wnd[1]/usr/ctxtDY_PATH
	Sleep	2
	
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2


    Open Excel Document    C:\\tmp\\biling_documents.xlsx    Sheet1
    ${column_data}=    Read Excel Column    10    sheet_name=Sheet1
    
    ${Cleaned_List}=    Clean List    ${column_data}     
    Log    ${Cleaned_List}
    ${sliced_data} =    Evaluate    [int(x) for x in ${Cleaned_List}[1:]]
    Log    ${sliced_data}
    
    ${json}    Excel Column To Json    file_path=C:\\tmp\\biling_documents.xlsx    sheet_name=Sheet1    column_index=9
    
    Log To Console    **gbStart**Copilot_Status**splitKeyValue**${json}**gbEnd**
    Close Current Excel Document
    Sleep    2

System Logout
    Run Transaction   /nex
    Sleep    5   


        