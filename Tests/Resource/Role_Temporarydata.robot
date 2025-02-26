*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    DateTime
Library    Replay_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SA_Role_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SA_Role_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SA_Role_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
Get_Temporarydata
    Run Transaction     /nse16
    Sleep    1
    Input Text    element_id=wnd[0]/usr/ctxtDATABROWSE-TABLENAME    text=AGR_USERS
    Send Vkey    0
    Sleep    1
    Input Text    element_id=wnd[0]/usr/ctxtI1-LOW    text=T_*
    Sleep    1
    Click Element    element_id=wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Click Element    element_id=wnd[0]/mbar/menu[6]/menu[5]/menu[2]/menu[2]
    Sleep    1
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Temporarydata
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    0.5 seconds
    Delete Specific File    file_path=C:\\tmp\\Role\\Temporarydata.xlsx
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\Role\\
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    2
    Remove Rows Before Start Row    file_path=C:\\tmp\\Role\\Temporarydata.xlsx    sheet_name=Sheet1    start_row=4
    Sleep    1
    Clean Excel    file_path=C:\\tmp\\Role\\Temporarydata.xlsx    sheet_name=Sheet1
    Sleep    2