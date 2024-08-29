*** Settings ***
Library    Process
Library     CustomSapGuiLibrary.py
Library    OperatingSystem

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    3s
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   5s

SM02
    Run Transaction     /nSM02
    Sleep   3s
    ${log_value}        Get Lable Value     wnd[0]/usr      ${symvar('search_texts')}
    Log To Console      ${log_value}
    IF    '${log_value}' == 'Certificate got expired'
        Log To Console    **gbStart**status**splitKeyValue**TRUE**gbEnd**
    ELSE
        Log To Console    **gbStart**status**splitKeyValue**FALSE**gbEnd**
    END

        

System Logout
    Run Transaction     /nex
    Sleep   5
