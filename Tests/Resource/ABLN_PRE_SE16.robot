*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
library    ExcelLibrary
Library    Merger.py
 
*** Variables ***
${back}    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[15]
*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}  
    Sleep    5  
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('diaUserpassword')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

Pre_SE16
    Run Transaction  SE16
    Sleep    2
    Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	HTTP_WHITELIST
	Send Vkey    0 
    Click Element	wnd[0]/tbar[1]/btn[8]
    Take Screenshot    003_preSE16_00.jpg
    ${tablecount}=    Count GUI Table Rows    wnd[0]/usr/lbl
    ${actual_rowcount}=    Evaluate    ${tablecount}-4

Download the table
    Run Keyword And Ignore Error    Delete Specific File    ${symvar('excel_filePath_SE16')}
    Run Keyword And Ignore Error    Delete Specific File    ${symvar('json_FilePath_SE16')}
    Click Element	wnd[0]/mbar/menu[6]/menu[5]/menu[2]/menu[2]
    Sleep    5
    Select Radio Button    	wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Set Focus	wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
	Click Element	wnd[1]/tbar[0]/btn[0]
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	pre_SE16_report
    Sleep    2
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp
	Sleep	2
	Set Focus	wnd[1]/usr/ctxtDY_PATH
	Sleep	2
    Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	5
    Close Current Excel Document
    Process Excel   file_path=${symvar('excel_filePath_SE16')}    sheet_name=Sheet1    column_index=0
    # Clean Excel Sheet    file_path=C:\\tmp\\pre_SE16_report.xlsx    sheet_name=Sheet1
    
    ${pre_SE16_json}    Excel To Json SE16   excel_file=${symvar('excel_filePath_SE16')}   json_file=${symvar('json_FilePath_SE16')} 
    Log    ${pre_SE16_json}
    Set Global Variable    ${pre_SE16_json}
    Log To Console    **gbStart**pre_SE16_json**splitKeyValue**${pre_SE16_json}**gbEnd**
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    2

close
    Run Transaction    /nex
    Sleep  2

 


    