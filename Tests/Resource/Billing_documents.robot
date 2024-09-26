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
    
    Connect To Session
    Open Connection    ${symvar('BILLING_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('BILLING_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('BILLING_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('BILLING_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{BILLING_PASSWORD}
    Send Vkey    0
    
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    

Billing Documents Not Posted to Accounting
    Run Transaction    VFX3
	Select Checkbox    wnd[0]/usr/chkRFBSK_AB	
	Input Text	wnd[0]/usr/ctxtVKORG	${symvar('sales_organation')}
	Input Text	wnd[0]/usr/txtERNAM-LOW    ${symvar('create_by')}
	Set Focus	wnd[0]/usr/radP_UTASY
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	0.5
    Click Element	wnd[0]/mbar/menu[0]/menu[1]/menu[2]
	Sleep	0.5
	Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Sleep	0.5
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.5
    Clear Field Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    biling_documents
	Sleep	0.5
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	0.5
    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
    Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp
	Sleep	0.5
	Set Focus	wnd[1]/usr/ctxtDY_PATH
	Sleep	0.5
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.5


    Open Excel Document    C:\\tmp\\biling_documents.xlsx    Sheet1
    ${column_data}=    Read Excel Column    10    sheet_name=Sheet1
    
    ${Cleaned_List}=    Clean List    ${column_data}     
    Log    ${Cleaned_List}
    ${sliced_data} =    Evaluate    [int(x) for x in ${Cleaned_List}[1:]]
    Log    ${sliced_data}
    
    ${json}    Excel To Json    excel_file=C:\\tmp\\biling_documents.xlsx   json_file=C:\\tmp\\biling_documents.json  
    Log    ${json} 
    Log To Console    **gbStart**Copilot_Status_json**splitKeyValue**${json}**gbEnd**
    Close Current Excel Document
    Sleep    0.5
    Delete Specific File    C:\\tmp\\biling_documents.json
        

System Logout
    Run Transaction   /nex
      


        