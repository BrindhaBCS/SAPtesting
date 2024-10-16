*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime

*** Variables ***
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Replace}    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[11]
${Execute}    wnd[0]/tbar[1]/btn[8]
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

Control mandant changes
     Run Transaction    /nSCU3
    Sleep    2
    Take Screenshot    Control_mandant_changes1.jpg
    Click Element    wnd[1]/usr/btnSPOP-VAROPTION1
    Sleep    2
    Click Element    wnd[0]/usr/btnBUTTON_AUSWERTEN
    Sleep    2
    Input Text    wnd[0]/usr/ctxtCUSOBJ-LOW    T000
    Sleep    2
    Send Vkey    0
    Sleep    2
    # Calculate past one month date
    ${past_month_date}=    Evaluate    (datetime.datetime.now() - datetime.timedelta(days=30)).strftime('%d.%m.%Y')    datetime
    # Calculate current date
    ${current_date}=    Evaluate    datetime.datetime.now().strftime('%d.%m.%Y')    datetime
    Sleep    1
    Input Text    wnd[0]/usr/ctxtDBEG    ${past_month_date}
    Sleep    2
    Log    ${past_month_date}
    Input Text    wnd[0]/usr/ctxtDEND    ${current_date}
    Sleep    2
    Log    ${current_date}
    Take Screenshot    Control_mandant_changes2.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_mandant_changes3.jpg
    ${Take logs}    Get Value    wnd[0]/usr/lbl[0,25]
    Log    ${Take logs}
    Log To Console    ${Take logs}
    Click Element    ${BACK}
    Sleep    1
    Log To Console    Control mandant changes Completed
    