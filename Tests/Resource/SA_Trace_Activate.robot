*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    DateTime
Library    Replay_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SA_Role_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SA_Role_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SA_Role_User_Password}
    Send Vkey    0
    Sleep    1
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep    1
System Logout
    Run Transaction     /nex
Trace_status
    Run Transaction    /nstauthtrace
    Sleep    1
    ${trace_status}    Get Value    element_id=wnd[0]/usr/txtSC_100_TRACESTATUS
    IF    '${trace_status}' == 'Trace is switched off'
        Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
        Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('New_User_Name')}
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[6]
        Sleep    1
        Log To Console    **gbStart**copilot_status_trace**splitKeyValue**AUTHORIZATION TRACE HAS BEEN SUCCESSFULLY ENABLED...**gbEnd**
    ELSE IF    '${trace_status}' == 'Authorization trace is switched on'
        Click Element    wnd[0]/tbar[1]/btn[7]
        Sleep    1
        Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
        Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('New_User_Name')}
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[6]
        Sleep    1
        Log To Console    **gbStart**copilot_status_trace**splitKeyValue**ALREADY AUTHORIZATION TRACE HAS BEEN ON AND DEACTIVATED AND ENABLED NOW...** **gbEnd**
    END