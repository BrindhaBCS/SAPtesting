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
    Open Connection    ${symvar('KG_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('KG_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('KG_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('KG_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{KG_User_Password}
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
    ${json}    excel to json    file_path=C:\\tmp\\SalesDocument.xlsx    sheet_name=Sheet1    
    log    ${json}
    Log To Console    **gbStart**copilot_Sales_Document_status**splitKeyValue**${json}**gbEnd**
    log to console    ${json}  
