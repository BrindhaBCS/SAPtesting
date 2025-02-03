*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Report_Library.py

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Cop_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('Cop_Client_Id')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Cop_User_Name')}
    Sleep   1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Cop_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{Cop_User_Password}
    Send Vkey    0
    Sleep    1
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
    Sleep   1
Report_Table_TS4
    Run Transaction     /nse16
    Sleep    1
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    CWBNTCUST
    Send Vkey    0
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5 seconds
    ${status}    Run Keyword And Return Status    Click Element    wnd[0]/tbar[1]/btn[43]
    IF    '${status}' == 'True'
        Click Element    wnd[0]/tbar[1]/btn[43]
        Sleep    1
        Clear Field Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
        Sleep    0.5s
        Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Snote_TS4_Report
        Sleep    0.5s
        Select From List By Label    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    Spreadsheet(*.xlsx)
        Sleep    0.5s
        Click Element    wnd[1]/tbar[0]/btn[20]
        Sleep    1
        Clear Field Text    wnd[1]/usr/ctxtDY_PATH
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\Copilot\\
        Sleep    0.5s
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    0.5s
    ELSE    
        Click Element    wnd[0]/mbar/menu[1]/menu[5]
        Sleep    1
        Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    1
        Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Snote_TS4_Report
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[20]
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\Copilot\\
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    1
    END
OUtput
    
    Cop Webexcel Scrap    file_path=C:\\Users\\Administrator\\Downloads\\data.csv    output_file=C:\\tmp\\Copilot\\TS4_OutputData.xlsx
    Sleep    2
    Remove Rows Before Start Row    file_path=C:\\tmp\\Copilot\\Snote_TS4_Report.xlsx    sheet_name=Sheet1    start_row=5
    Sleep    2
    Clean Excel    file_path=C:\\tmp\\Copilot\\Snote_TS4_Report.xlsx    sheet_name=Sheet1
    Sleep    2
    Cop Sapexcel Scrap    input_file=C:\\tmp\\Copilot\\Snote_TS4_Report.xlsx    output_file=C:\\tmp\\Copilot\\TS4_OutputData.xlsx
    Sleep    2
    Cop Excel Compare    input_file=C:\\tmp\\Copilot\\TS4_OutputData.xlsx    output_file=C:\\tmp\\Copilot\\Final_TS4Report.xlsx
    Sleep    2
Deletefile
    Delete Specific File    file_path=C:\\Users\\Administrator\\Downloads\\data.csv
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\Copilot\\TS4_OutputData.xlsx
    Sleep    1 
    Delete Specific File    file_path=C:\\tmp\\Copilot\\Snote_TS4_Report.xlsx
    Sleep    1 