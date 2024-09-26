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
    

Billing Documents_2 Not Posted to Accounting
    Run Transaction    VFX3
	Select Checkbox    wnd[0]/usr/chkRFBSK_AB	
	Input Text	wnd[0]/usr/ctxtVKORG	${symvar('sales_organation')}
	Input Text	wnd[0]/usr/txtERNAM-LOW    ${symvar('create_by')}
	Set Focus	wnd[0]/usr/radP_UTASY
	Click Element	wnd[0]/tbar[1]/btn[8]
    ${Total_row}    Get Row Count    wnd[0]/usr/cntlGRID1/shellcont/shell 
    Log To Console    ${Total_row}
    ${coulumn_value}    Read Table Column    wnd[0]/usr/cntlGRID1/shellcont/shell    VBELN
    Set Global Variable    ${coulumn_value}
    ${get_length}    Get Length    ${coulumn_value}

    FOR    ${i}    IN RANGE    0    ${get_length}
        Log To Console    ${i}
        ${column_item}    Evaluate    ${coulumn_value}[${i}]
        IF    '${column_item}' == '${symvar('Enter_Bill_Document')}'
            
            Select Document On Text   wnd[0]/usr/cntlGRID1/shellcont/shell    VBELN    ${symvar('Enter_Bill_Document')}
            Click Element    wnd[0]/tbar[1]/btn[18]
            Log To Console    **gbStart**Copilot_Status**splitKeyValue**${symvar('Enter_Bill_Document')} successfully Release**gbEnd**
            Exit For Loop
        ELSE
            Log To Console    **gbStart**Copilot_Status**splitKeyValue**${symvar('Enter_Bill_Document')} Does't Exist**gbEnd**
        END
    END    
    Delete Specific File    file_path=C:\\tmp\\biling_documents.xlsx

System Logout
    Run Transaction   /nex