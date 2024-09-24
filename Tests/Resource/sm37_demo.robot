*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
*** Variables ***
${SAP_SERVER}     C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\saplogon.exe
*** Keywords ***
oprn
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

close
    Run Transaction    /nex