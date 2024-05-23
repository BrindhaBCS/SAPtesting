*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5
    Connect To Session
    Open Connection     ${symvar('Nike_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT_role')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER_role')}    
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS_role} 
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS_role')}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

delete_role
    Run Transaction    /nPFCG
    Sleep    3
    ${delete_function}    Get Length  ${symvar('Delete_role_names')}
    Log    ${delete_function}
    FOR    ${delete_index}    IN RANGE    ${delete_function}
        ${delete_role_input} =    Run Keyword And Return Status    Input Text    wnd[0]/usr/ctxtAGR_NAME_NEU    ${symvar('Delete_role_names')}[${delete_index}]
        Run Keyword If    not ${delete_role_input}    Exit For Loop
        Sleep    2
        Click Element    wnd[0]/tbar[1]/btn[14]            #delete 
        Take Screenshot
        Sleep    2
        Click Element    wnd[1]/usr/btnBUTTON_1    #yes
        Take Screenshot
        Sleep    3
        Click Element    wnd[1]/tbar[0]/btn[0]    #tick
        Take Screenshot
        Sleep    1
    END