*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process

# *** Variables ***
# ${SAP_SERVER}     C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\saplogon.exe  
# ${inputuser}    /app/con[0]/ses[0]/wnd[0]/usr/txtRSYST-BNAME
# ${password}    /app/con[0]/ses[0]/wnd[0]/usr/pwdRSYST-BCODE
# ${Submit}    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[0]
*** Keywords ***
start
    Start Process    ${sapvar('sap_server')}
    Sleep    2
    Connect To Session
    Sleep    2
    Open Connection    ${sapvar('server')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${sapvar('user_name')}
    Sleep    2
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${sapvar('password')}
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[0]
    Sleep    2
    Multiple logon Handling     wnd[1]    wnd[1]/usr/radMULTI_LOGON_OPT2    wnd[1]/tbar[0]/btn[0]
    Sleep   1

sm14_transaction
    Run Transaction    sm14
    Sleep    2
    Click Element    wnd[0]/usr/tabsFOLDER/tabpUPDATE
    Sleep    2
    Take Screenshot    update.jpg
    Click Element    wnd[0]/usr/tabsFOLDER/tabpSERVERS
    Sleep    2
    Take Screenshot    server.jpg
    Click Element    wnd[0]/usr/tabsFOLDER/tabpGROUPS
    Sleep    2
    Take Screenshot    groups.jpg
    Click Element    wnd[0]/usr/tabsFOLDER/tabpPARAMETERS
    Sleep    2
    Take Screenshot    parameters.jpg
    # Click Element    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[15]
    # Sleep    2
    # Click Element    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[15]
    # Sleep    2
    # Click Element    /app/con[0]/ses[0]/wnd[1]/usr/btnSPOP-OPTION1
    # Sleep    2

stop
    Run Transaction    /nex
    Sleep    2