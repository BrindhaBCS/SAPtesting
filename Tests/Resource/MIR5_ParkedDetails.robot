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
MIR5 Parked details
    Run Transaction    /nMIR5
    Sleep    0.5 seconds
    Input Text    wnd[0]/usr/ctxtSO_BUKRS-LOW     bc01
    Sleep    0.5 seconds
    Unselect Checkbox    wnd[0]/usr/chkP_IV_OV 
    Sleep    0.5 seconds
    Select Checkbox    wnd[0]/usr/chkP_IV_PAR 
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5 seconds
    Click Element    wnd[0]/mbar/menu[0]/menu[2]/menu[2]
    Sleep    0.5 seconds
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[0]
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    ParkedDetail
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[20]
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    0.5 seconds
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[12]
    Sleep    0.5 seconds
    Process Excel    file_path=C:\\tmp\\ParkedDetail.xlsx    sheet_name=Sheet1    column_index=0
    Sleep    0.5 seconds
    ${json}    Excel To Json    excel_file=C:\\tmp\\ParkedDetail.xlsx     json_file=C:\\tmp\\ParkedDetail.json
    Log    ${json}
    Log To Console    **gbStart**copilot_Parked_Document_List**splitKeyValue**${json}**gbEnd**
    Log To Console    ${json}  
    Sleep    0.5 seconds
    Delete Specific File    file_path=C:\\tmp\\ParkedDetail.json
    Delete Specific File    file_path=C:\\tmp\\ParkedDetail.xlsx