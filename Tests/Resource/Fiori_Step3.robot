*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    DateTime

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Fiori_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('Fiori_Client_Id')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Fiori_User_Name')}
    Sleep   1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Fiori_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{Fiori_User_Password}
    Send Vkey    0
    Sleep    1
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction    /nex
    Sleep   1
Error_Capturing
    Run Transaction    /nstauthtrace
    Sleep    1
    Select Checkbox    wnd[0]/usr/subSUB_SELECTION:SAPLSUAUTHTRACE:1100/chkP1_DUP
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Send Vkey    vkey_id=45
    Sleep    1 
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Clear Field Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    1
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Fiori_LaunchPad_Report
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    1
    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\FIORI\\
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    2
    # Transaction    /n/IWBEP/ERROR_LOG
    Run Transaction    /n/IWBEP/ERROR_LOG
    Sleep    1
    Take Screenshot    Web_Error1.jpg
    Sleep    1
    # Transaction    /n/IWFND/ERROR_LOG
    Run Transaction    /n/IWFND/ERROR_LOG
    Sleep    1
    Take Screenshot    Web_Error1.jpg
    Sleep    1
Deletefile
    Delete Specific File    file_path=C:\\tmp\\FIORI\\Fiori_Create_Role_extract.xlsx
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\FIORI\\Fiori_Create_Role_extract.txt
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\FIORI\\Fiori_Create_Tcode_extract.xlsx
    Sleep    1    