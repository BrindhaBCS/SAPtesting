*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    ExcelLibrary
Library    String
Library    Collections
*** Variables ***
${Input_Document_Number}        ${symvar('Input_Document_Number')}    
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('KG_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('KG_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('KG_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('KG_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{KG_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
Sales Document get value
    Run Transaction    /nVKM1
    Sleep    0.5
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5
    Open Excel Document    C:\\tmp\\${symvar('job_id')}\\SalesDocument.xlsx    Sheet1
    ${column_data}=    Read Excel Column    5    sheet_name=Sheet1
    ${sliced}=    Evaluate    [item.strip() for item in ${column_data}[1:] if item.strip()] 
    Log    ${sliced}
    ${sliced_data} =    Evaluate    [int(x) for x in ${sliced}[1:]]
    Log    ${sliced}
    Log To Console    ${sliced}
    ${i}    Get Length   ${sliced}
    Log    ${i}
    Close Current Excel Document
    Sleep    2
    FOR    ${index}    IN RANGE    0    ${i}
        ${col}=    Evaluate    ${index} + 3
        ${Get_Document}    Run Keyword And Ignore Error    Get Value    wnd[0]/usr/lbl[21,${col}]
        ${Get_Document_Number}    Set Variable    ${Get_Document[1]}
        Log    ${Get_Document_Number}
        IF    '${Input_Document_Number}' == '${Get_Document_Number}'
            Select Checkbox    wnd[0]/usr/chk[1,${col}]
            Sleep    0.5
            Click Element    wnd[0]/tbar[1]/btn[34]
            Sleep    0.5
            Click Element    wnd[0]/tbar[0]/btn[11]
            Sleep    0.5
            Click Element    wnd[0]/tbar[0]/btn[3]
            Sleep    0.5
            Log To Console    **gbStart**copilot_Sales_Document**splitKeyValue**The document ${Input_Document_Number} is released successfully...**gbEnd**
            Exit For Loop
        ELSE
            Log To Console    **gbStart**copilot_Sales_Document**splitKeyValue**The document ${Input_Document_Number} is not found...**gbEnd**
        END
    END
    Sleep    0.5
    Delete Specific File    C:\\tmp\\${symvar('job_id')}\\SalesDocument.xlsx