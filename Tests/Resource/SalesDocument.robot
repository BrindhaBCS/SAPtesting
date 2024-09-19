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
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Sales_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('Sales_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Sales_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Sales_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{Sales_User_Password}
    Send Vkey    0
    Sleep    2
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    2
Sales Document with CreditBlocks
    Run Transaction    /nVKM1
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Click Element    wnd[0]/mbar/menu[3]/menu[1]/menu[2]
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    SalesDocument
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    0.5 seconds
    Sleep    1
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[12]
    Sleep    1
    Open Excel Document    C:\\tmp\\SalesDocument.xlsx    Sheet1
    ${column_data}=    Read Excel Column    6    sheet_name=Sheet1
    ${sliced}=    Evaluate    [item.strip() for item in ${column_data}[1:] if item.strip()] 
    Log    ${sliced}
    ${sliced_data} =    Evaluate    [int(x) for x in ${sliced}[1:]]
    Log    ${sliced_data}
    Log To Console    ${sliced_data}
    ${i}    Get Length   ${sliced_data}
    Log    ${i}
    ${json}    Excel Column To Json    file_path=C:\\tmp\\SalesDocument.xlsx    sheet_name=Sheet1    column_index=5
    Log To Console    **gbStart**copilot_salesdocument**splitKeyValue**${json}**gbEnd**
    Close Current Excel Document
    Sleep    5
    FOR    ${index}    IN RANGE    0    ${i}
        ${col}=    Evaluate    ${index} + 3
        ${Get_Document}    Run Keyword And Ignore Error    Get Value    wnd[0]/usr/lbl[21,${col}]
        ${Get_Document_Number}    Set Variable    ${Get_Document[1]}
        Log    ${Get_Document_Number}
        IF    '${Input_Document_Number}' == '${Get_Document_Number}'
            Select Checkbox    wnd[0]/usr/chk[1,${col}]
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[34]
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[11]
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[3]
            Exit For Loop
        ELSE
            Log    Yours input not match
        END
    END