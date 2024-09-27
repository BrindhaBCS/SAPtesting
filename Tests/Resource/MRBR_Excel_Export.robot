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
MRBR_Excel_Export
    Run Transaction    /nMRBR
    Sleep    0.5
    Input Text    wnd[0]/usr/ctxtSO_BUKRS-LOW    ${symvar('Block_Company_Code')}
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[2]
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Click Element    wnd[1]/tbar[0]/btn[0]
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    MRBR_Block
    Click Element    wnd[1]/tbar[0]/btn[20]
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    2
    Process Excel    file_path=C:\\tmp\\MRBR_Block.xlsx    sheet_name=Sheet1
    Sleep    5
    ${json}    Excel To Json    excel_file=C:\\tmp\\MRBR_Block.xlsx     json_file=C:\\tmp\\MRBR_Block.json
    log    ${json}
    Log To Console    **gbStart**copilot_Json**splitKeyValue**${json}**gbEnd**
    log to console    ${json}  
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\MRBR_Block.json
