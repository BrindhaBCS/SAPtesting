*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
*** Variables ***
${Input_Doc_Value}        ${symvar('Parked_Document_No')}    
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('MIRO_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('MIRO_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MIRO_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MIRO_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{MIRO_User_Password}
    Send Vkey    0
    Sleep    2
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
MIRO Post Parked
    Run Transaction    /nMIR5
    Sleep    0.5 seconds
    Input Text    wnd[0]/usr/ctxtSO_BUKRS-LOW     ${symvar('Parked_Company_Code')}
    Sleep    0.5 seconds
    Unselect Checkbox    wnd[0]/usr/chkP_IV_OV 
    Sleep    0.5 seconds
    Select Checkbox    wnd[0]/usr/chkP_IV_PAR 
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5 seconds
    ${Get_row_count}    Get Row Count    wnd[0]/usr/cntlGRID1/shellcont/shell
    Log    ${Get_row_count}
    Sleep    0.5 seconds
    Run Transaction    /nMIRO
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[9]
    Sleep    0.5 seconds
    Expand Sap Shell Node    wnd[0]/shellcont/shell    2    Column1
    Sleep    0.5 seconds
    ${Get Current Year}    Get Current Date    result_format=%Y
    FOR    ${index}    IN RANGE    0    ${Get_row_count} 
        ${row}    Evaluate    ${index} + 4
        ${Doc_Value}    Get Sap Shell Item Value    wnd[0]/shellcont/shell    ${row}    Column1
        Log    ${Doc_Value}
        IF    '${Doc_Value}' == '${Input_Doc_Value} ${Get_Current_Year}'
            Double Click Sap Shell Item    wnd[0]/shellcont/shell    ${row}    Column1
            Sleep    0.5 seconds
            ${Get Current Date}    Get Current Date    result_format=%d.%m.%Y
            Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BLDAT    ${Get Current Date}
            Sleep    0.5 seconds
            Send Vkey    0
            Sleep    0.5 seconds
            Click Element    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY
            Sleep    0.5 seconds
            Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY/ssubHEADER_SCREEN:SAPLFDCB:0020/ctxtINVFO-ZFBDT    ${Get Current Date}
            Sleep    0.5 seconds
            Click Element    wnd[0]/tbar[1]/btn[23]
            Sleep    0.5 seconds
            Log To Console    **gbStart**copilot_Post_ParkedDocument**splitKeyValue**The document ${Input_Doc_Value} is Posted successfully...**gbEnd**
            Exit For Loop
        ELSE
            Log To Console    **gbStart**copilot_Post_ParkedDocument**splitKeyValue**The document ${Input_Doc_Value} is not found...**gbEnd**
        END
    END