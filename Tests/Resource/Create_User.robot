*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    SAP_Tcode_Library.py

*** Keywords *** 
System Logon
    Start Process    ${symvar('User_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('User_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('User_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{USER_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex

Create User
    Run Transaction    /nSU01
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('ALM_User')}
    Click Element    wnd[0]/tbar[1]/btn[8]
    # Sleep    5
    Window Handling    wnd[1]    Address Maintenance      wnd[1]/usr/btnBUTTON_2
    # Sleep    5
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpADDR/ssubMAINAREA:SAPLSUID_MAINTENANCE:1900/txtSUID_ST_NODE_PERSON_NAME-NAME_LAST    ${symvar('ALM_User')}
    Input Text
    Click Element     wnd[0]/usr/tabsTABSTRIP1/tabpLOGO
    # Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD    ${symvar('ALM_pass')}
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD2    ${symvar('ALM_pass')}
    # Sleep    2
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpPROF
    For i in range 0 row
    Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell    0    PROFILE    ${from_excel}
    end
    # Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[11]
    ${output}   Get Value    wnd[0]/sbar/pane[0]
    Log To Console    **gbStart**copilot_status**splitKeyValue**${output}**gbEnd**

