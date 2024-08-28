*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
   

*** Keywords ***
System Logon
    Start Process     ${symvar('SALES_SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SALES_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('SALES_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SALES_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SALES_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

VF01
    Run Transaction    /nvf01
	Sleep	2
    Set Focus    wnd[0]/usr/tblSAPMV60ATCTRL_ERF_FAKT/ctxtKOMFK-VBELN[0,0]
	Sleep	2
	Send Vkey	0
	Sleep	2
    Set Focus	wnd[0]/usr/tblSAPMV60ATCTRL_UEB_FAKT/ctxtVBRP-MATNR[1,0]
	Sleep	2
	Send Vkey	2
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP_OVERVIEW/tabpPFKO
	Sleep	2
	
	Click Element	wnd[0]/tbar[0]/btn[11]
	Sleep	2

    ${document_status}    Get Value    wnd[0]/sbar/pane[0]
    Log To Console    ${document_status}
    ${document_number}=    Extract Order Number    ${document_status}
    Set Global Variable    ${document_number}
    Log To Console    **gbStart**Copilot_Status**splitKeyValue**${document_number}**gbEnd**


System Logout
    Run Transaction   /nex
    Sleep    5


    

	






        