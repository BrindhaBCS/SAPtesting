*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
 
 
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('abhinbevSID')}  
    Sleep    5  
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('clientno')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('diaUsername')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('diaUserpassword')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{abinberpassword}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

Pre_SE16
    Run Transaction  SE16
    Sleep    2
    Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	HTTP_WHITELIST
	Send Vkey    0 
    Click Element	wnd[0]/tbar[1]/btn[8]
    ${tablecount}=    Count GUI Table Rows    wnd[0]/usr/lbl
    ${actual_rowcount}=    Evaluate    ${tablecount}-4
    ${MANDT_values}   ${ENTRY_TYPE_values}   ${SORTKEY_values}   ${PROTOCOL_values}   ${HOST_values} =    Get Table Text    wnd[0]/usr/lbl    ${tablecount}  
    Log To Console    MANDT_values=${MANDT_values}
    Set Global Variable    MANDT_values=${MANDT_values}
    Log To Console   ENTRY_TYPE_values=${ENTRY_TYPE_values}
    Set Global Variable    ENTRY_TYPE_values=${ENTRY_TYPE_values}
    Log To Console   SORTKEY_values=${SORTKEY_values}
    Set Global Variable    SORTKEY_values=${SORTKEY_values}
    Log To Console   PROTOCOL_values=${PROTOCOL_values}
    Set Global Variable    PROTOCOL_values=${PROTOCOL_values}
    Log To Console    HOST_values= ${HOST_values}
    Set Global Variable    HOST_values=${HOST_values}
    Log To Console    **gbStart**MANDT_values**splitKeyValue**${MANDT_values}**gbEnd**
    Log To Console    **gbStart**ENTRY_TYPE_values**splitKeyValue**${ENTRY_TYPE_values}**gbEnd**
    Log To Console    **gbStart**SORTKEY_values**splitKeyValue**${SORTKEY_values}**gbEnd**   
    Log To Console    **gbStart**PROTOCOL_values**splitKeyValue**${PROTOCOL_values}**gbEnd**
    Log To Console    **gbStart**HOST_values**splitKeyValue**${HOST_values}**gbEnd**



    