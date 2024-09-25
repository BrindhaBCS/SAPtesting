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

Billing Documents_2 Not Posted to Accounting
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
    
    Open Excel Document    C:\\tmp\\biling_documents.xlsx    Sheet1
    ${column_data}=    Read Excel Column    10    sheet_name=Sheet1
    
    ${Cleaned_List}=    Clean List    ${column_data}     
    Log    ${Cleaned_List}
    ${sliced_data} =    Evaluate    [int(x) for x in ${Cleaned_List}[1:]]
    Log    ${sliced_data}

    IF    ${symvar('Enter_Bill_Document')} in ${coulumn_value}
        Select Document On Text   wnd[0]/usr/cntlGRID1/shellcont/shell    VBELN    ${symvar('Enter_Bill_Document')}
        
        Sleep    2
        Click Element    wnd[0]/tbar[1]/btn[18]
        Sleep    2
    
        Log To Console    **gbStart**Copilot_Status**splitKeyValue**${symvar('Enter_Bill_Document')} successfully Release**gbEnd**
    ELSE
        Log To Console    **gbStart**Copilot_Status**splitKeyValue**${symvar('Enter_Bill_Document')} Does't Exist**gbEnd**
    END
    Delete Specific File    C:\\tmp\\biling_documents.xlsx

System Logout
    Run Transaction   /nex
    Sleep    5 