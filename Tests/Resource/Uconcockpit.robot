*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py


*** Variables ***
${source_directory}     ${OUTPUT_DIR}

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    #Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    # Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    # Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    # Take Screenshot    logoutpage.jpg
    # Sleep    10

Transaction Uconcockpit
    Run Transaction     /nUconcockpit
    Send Vkey    0
    Take Screenshot    047_Uconcockpit.jpg
    Sleep    2

RFC Basic Scenario
    Select From List by Label   wnd[0]/usr/cmbP_SCEN    RFC Basic Scenario
    Sleep    2
    Take Screenshot    048_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    049_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot    050_Uconcockpit.jpg
Role Building Scenario
    Select From List by Label   wnd[0]/usr/cmbP_SCEN    Role Building Scenario
    Sleep    2
    Take Screenshot    051_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    052_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot    053_Uconcockpit.jpg
    Merger.copy images    ${source_directory}      ${symvar('target_directory')}  
