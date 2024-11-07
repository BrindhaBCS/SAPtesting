*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime

*** Variables ***
${BACK}    wnd[0]/tbar[0]/btn[3]
${Execute}    wnd[0]/tbar[1]/btn[8]


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

Control table logging

    Run Transaction    /nSE16
    Sleep    2
    Take Screenshot    Control_table_logging1.jpg
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    DD09L
    Sleep    2
    Send Vkey    0
    Sleep    2
    Take Screenshot    Control_table_logging2.jpg
    ${past_month_date}=    Evaluate    (datetime.datetime.now() - datetime.timedelta(days=30)).strftime('%d.%m.%Y')    datetime
    # Calculate current date
    log    ${past_month_date}
    ${current_date}=    Evaluate    datetime.datetime.now().strftime('%d.%m.%Y')    datetime
    Log    ${current_date}
    Input Text    wnd[0]/usr/ctxtI11-LOW    ${past_month_date}
    Sleep    2
    Input Text    wnd[0]/usr/ctxtI11-HIGH    ${current_date}
    Sleep    2
    Input Text    wnd[0]/usr/ctxtI8-LOW    X
    Sleep    2
    Take Screenshot    Control_table_logging3.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_table_logging4.jpg
    Sleep    1
    ${Number of Entries}    Get Value    wnd[0]/sbar
    Sleep    2
    Log    ${Number of Entries}
    Log To Console    ${Number of Entries}
    Click Element    ${BACK}
    Log To Console    Control table logging completed
Generate report
   Image Resize    ${symvar('MCR_directory')}
    Sleep    2
    Copy Images    ${symvar('MCR_directory')}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1
    