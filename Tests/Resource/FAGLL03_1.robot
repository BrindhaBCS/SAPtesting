*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py



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
    ${logon_status}    Multiple logon Handling     wnd[1]
    IF    '${logon_status}' == "Multiple logon found. Please terminate all the logon & proceed"
        Log To Console    **gbStart**Sales_Document_status**splitKeyValue**${logon_status}**gbEnd**

    END

System Logout
    Run Transaction   /nex
    Sleep    5
FAGLL03_1
    Run Transaction    /nFAGLL03
	Sleep	2
	Input Text    wnd[0]/usr/ctxtSD_SAKNR-LOW    ${symvar('GR_IR_GL_Account')}
	Sleep	2
	Select Radio Button    wnd[0]/usr/radX_CLSEL
	Sleep	2
    Input Text    wnd[0]/usr/ctxtSO_AUGDT-LOW    12022025
	Sleep    2
    Input Text    wnd[0]/usr/ctxtPA_STIDA    12.2.2025
	Sleep	2	
	Click Element    wnd[0]/tbar[1]/btn[8]
	Sleep	2
	Click Element    wnd[0]/tbar[1]/btn[33]
	Sleep	2
	Set Focus    wnd[1]/usr/lbl[14,10]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Set Focus    wnd[0]/usr/lbl[28,10]
	Sleep	2
	Click Element    wnd[0]/tbar[1]/btn[38]
	Sleep	2
    Take Screenshot    FAGLL03.jpg
	Click Element    wnd[1]/tbar[0]/btn[0]
	Sleep	2     
    
    

