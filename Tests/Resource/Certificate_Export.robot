*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    String
*** Variables ***
${file_path}    ${CURDIR}\\${symvar('filename')}
*** Keywords ***
System Logon
    Start Process     ${symvar('TH5_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('TH5_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('TH5_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('TH5_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('TH5_PASSWORD')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{TH5_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   4
System Logout
    Run Transaction   /nex
    Sleep    5
Transaction STRUST
    Run Transaction     /nstrustsso2
    Send Vkey    0
    Take Screenshot    strustsso2.jpg
    Sleep    2
SSL server standard     
    Click Element    wnd[0]/tbar[1]/btn[25]   
    Sleep    4
    Expand Element    wnd[0]/shellcont/shell    SSLSDFAULT   
    Sleep    2
    Take Screenshot    instance1.jpg
    
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT1   
    Sleep    2
    Take Screenshot    instance2.jpg
    Sleep    2

    Set Caret Position    wnd[0]/usr/txtPSE-OWNCERT-SUBJECT    32
    Send Vkey    2    
    Sleep  2
    # Click Element    wnd[0]/tbar[1]/btn[25]
    # Sleep  2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    instance3.jpg
    Sleep    2

    Click Element    wnd[0]/usr/btnEXPORT
    Sleep    5
    Select Radio Button    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/radB64
    Sleep    2
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${file_path}   
    Sleep    2
    Take Screenshot    instance4.jpg
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Take Screenshot    instance5.jpg
    Sleep    2
    Log To Console    Your Certificate Export Sucessfully , Path:${file_path}
    Sleep    1