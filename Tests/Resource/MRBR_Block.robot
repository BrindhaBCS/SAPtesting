*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Variables ***
${Input_Invoice_doc}    ${symvar('Input_Invoice_doc')}
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Block_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('Block_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Block_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Block_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{Block_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
System Logout
    Run Transaction   /nex 
MRBR_Block
    Run Transaction    /nMRBR
    Sleep    0.5
    Input Text    wnd[0]/usr/ctxtSO_BUKRS-LOW    ${symvar('Block_Company_Code')}
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5
    ${Get_Row_Count}    Get Row Count    wnd[0]/usr/cntlGRID1/shellcont/shell
    FOR    ${row_num}    IN RANGE    0    ${Get_Row_Count}    
        ${Invoice_doc}=    Get Sap Table Value    table_id=wnd[0]/usr/cntlGRID1/shellcont/shell    row_num=${row_num}    column_id=BELNR
        IF    '${Input_Invoice_doc}' == '${Invoice_doc}'
            Select Row    table_id=wnd[0]/usr/cntlGRID1/shellcont/shell    row_number=${row_num}
            Click Element    wnd[0]/tbar[1]/btn[9]
            Click Element    wnd[0]/tbar[0]/btn[11]
            Log To Console    **gbStart**copilot_Result**splitKeyValue**${Input_Invoice_doc} Will be Released..........**gbEnd**
            Exit For Loop
        ELSE
            Log To Console    **gbStart**copilot_Result**splitKeyValue**${Input_Invoice_doc} User Input Not Match Actual Current Data !!!**gbEnd**
        END
    END
