*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${BACK}    wnd[0]/tbar[0]/btn[3]



*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    2

Audit log configuration
    Run Transaction    SM19
    Sleep    2
    Take Screenshot    Audit_log_configuration1.jpg
    Click Element	wnd[0]/usr/tabsTABSTRIP2/tabpADMIN
	Sleep	2
    Take Screenshot    Audit_log_configuration2.jpg
    Click Element    ${BACK}
    Sleep    1
    Log To Console    Audit log configuration completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1