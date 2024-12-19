*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${ERS_Supplier}    ${symvar('ERS_Supplier')}
${ERS_Company_Code}    ${symvar('ERS_Company_Code')}
${ERS_Plant}    ${symvar('ERS_Plant')}
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
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ERS_User_Password')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ERS_User_Password}
    Send Vkey    0
    Sleep    2
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
   
    Run Transaction   /nex
    

ERS_Verification
    Run Transaction    /nmrrl
    Sleep    1
    Input Text	wnd[0]/usr/ctxtB_BUKRS-LOW	BC01
    Sleep    1
    Input Text	wnd[0]/usr/ctxtB_WERKS-LOW	1040
    Sleep    1
    Input Text	wnd[0]/usr/ctxtB_LIFNR-LOW	1000000030
    Sleep    1
    Select Checkbox	wnd[0]/usr/chkP_ERSDC	
    Sleep    1
    
    Send Vkey    8
    Sleep    1
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Unselect Checkbox 	wnd[0]/usr/chkB_XTEST
    Sleep    2

    Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2

    Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep    10
    Delete Specific File    C:\\tmp\\${FILE_NAME}
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	${FILE_NAME}
	Select From List By key    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/cmbGS_EXPORT-FORMAT    xlsx-TT
	Click Element	wnd[1]/tbar[0]/btn[20]
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp\\
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.5