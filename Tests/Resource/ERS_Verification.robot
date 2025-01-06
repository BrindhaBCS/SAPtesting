*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    ExcelLibrary

*** Variables ***
${FILE_NAME}    ERS_Verification.xlsx

*** Keywords ***
System Logon
    
    Start Process     ${symvar('ERS_SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('ERS_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('ERS_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ERS_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ERS_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ERS_User_Password}
    Send Vkey    0
    Sleep   0.5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   0.5
System Logout
    Run Transaction   /nex
ERS_Verification
    Run Transaction    /nmrrl
    Sleep    1
    Input Text	wnd[0]/usr/ctxtB_BUKRS-LOW	${symvar('ERS_Company_Code')}
    Input Text	wnd[0]/usr/ctxtB_WERKS-LOW	${symvar('ERS_Plant')}
    Input Text	wnd[0]/usr/ctxtB_LIFNR-LOW	${symvar('ERS_Supplier')}
    Select Checkbox	wnd[0]/usr/chkP_ERSDC	
    Sleep    1
    Send Vkey    8
    Sleep    1
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep    0.5
    Unselect Checkbox 	wnd[0]/usr/chkB_XTEST
    Sleep    0.5
    Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep    0.5
    Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep    1
    Run Keyword And Ignore Error    Delete Specific File     C:\\tmp\\${FILE_NAME}
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	${FILE_NAME}
	Select From List By key    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    xlsx-TT
	Click Element	wnd[1]/tbar[0]/btn[20]
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp\\
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.5
    # Open Excel Document    C:\\tmp\\${FILE_NAME}    Sheet1
    ${Verification}    Excel To Json    C:\\tmp\\${FILE_NAME}    json_file=C:\\tmp\\Verification.json
    Log To Console    **gbStart**ERS_Verification**splitKeyValue**${Verification}**gbEnd**
	Sleep    1
    Delete Specific File     C:\\tmp\\Verification.json
    Delete Specific File     C:\\tmp\\${FILE_NAME}