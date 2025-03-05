*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    multiple_selection.py

*** Keywords ***
System Logon
    Start Process    ${symvar('GR_IR_SERVER')}
    Connect To Session
    Open Connection     ${symvar('GR_IR_Connection')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('GR_IR_Client')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('GR_IR_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('GR_IR_PASSWORD')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{GR_IR_PASSWORD}
    Send Vkey    0   
    ${logon_status}    Multiple logon Handling     wnd[1]   wnd[1]/usr/radMULTI_LOGON_OPT2
    IF    '${logon_status}' == "Multiple logon found. Please terminate all the logon & proceed"
        Log To Console    **gbStart**Sales_Document_status**splitKeyValue**${logon_status}**gbEnd**

    END

System Logout
    Run Transaction   /nex
    Sleep    5

F.13_tcode
    Run Transaction    /nF.13
	Sleep	2
	Input Text    wnd[0]/usr/ctxtBUKRX-LOW    ${symvar('GR_IR_Company_Code')}
	Sleep	2
    Select Checkbox    wnd[0]/usr/chkX_SAKNR	
	Sleep	2
	### Delete Specific files
    Delete Specific File    ${symvar('download_path')}\\GL_Account.txt

    ### Copy To Clipboard
    Click Element   wnd[0]/usr/btn%_KONTS_%_APP_%-VALU_PUSH
    Get Column Excel To Text Create    C:\\tmp\\GRIR_Requirement.xlsx   C:\\tmp\\GL_Account.txt     G/L     GL Account
    Click Element   wnd[1]/tbar[0]/btn[23]
    Input Text    wnd[2]/usr/ctxtDY_PATH    C:\\tmp\\
    Input Text    wnd[2]/usr/ctxtDY_FILENAME    GL_Account.txt
    Click Element    wnd[2]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep   2
    # ##
    Sleep	2
	Unselect Checkbox    wnd[0]/usr/chkX_TESTL 	
	Sleep	5
	Click Element	wnd[0]/mbar/menu[0]/menu[2]
    Sleep    2
	Send Vkey    0
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[13]
	Sleep	2
	Click Element	wnd[1]/usr/btnSOFORT_PUSH
	Sleep	2
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   2
	Click Element	wnd[1]/tbar[0]/btn[11]
	Sleep	2
    ${GR_IR_Message}    Get Value    wnd[0]/sbar/pane[0]
    Take Screenshot    f13.jpg
    Sleep    2
    Log To Console    **gbStart**Message_status**splitKeyValue**${GR_IR_Message} Background job Scheduled..**gbEnd**
    





