*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SA_Role_User_Name')}
    Sleep   1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SA_Role_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SA_Role_User_Password}
    Send Vkey    0
    Sleep    2
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
    Sleep   2

Create_new_user
    Run Transaction    /nSU01
    Sleep   1
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('New_User_Name')}
    Sleep   1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    3
    Window Handling    wnd[1]    Address Maintenance      wnd[1]/usr/btnBUTTON_2
    Sleep    3
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpADDR/ssubMAINAREA:SAPLSUID_MAINTENANCE:1900/txtSUID_ST_NODE_PERSON_NAME-NAME_LAST    ${symvar('New_User_Last_Name')}
    Click Element     wnd[0]/usr/tabsTABSTRIP1/tabpLOGO
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD    ${symvar('New_User_Password')}
    Input Text    wnd[0]/usr/tabsTABSTRIP1/tabpLOGO/ssubMAINAREA:SAPLSUID_MAINTENANCE:1101/pwdSUID_ST_NODE_PASSWORD_EXT-PASSWORD2    ${symvar('New_User_Password')}
    Sleep    2   
    

Login_New_User
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SA_Role_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('SA_Role_Client_Id')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('New_User_Name')}
    Sleep   1
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('New_User_Password')}
    Send Vkey    0
    Sleep    3
    Input Password    wnd[1]/usr/pwdRSYST-NCODE    ${symvar('User_Reset_Current_Password')}       #%{Change_Date_User_Password}
    Sleep    2
    Input Password    wnd[1]/usr/pwdRSYST-NCOD2    ${symvar('User_Reset_Current_Password')}    #%{Change_Date_User_Password}
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Window Handling    wnd[1]    Copyright    wnd[1]/tbar[0]/btn[0]
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1