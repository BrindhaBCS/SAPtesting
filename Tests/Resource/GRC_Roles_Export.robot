*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
*** Variables ***
${path_to_download}    C:\\tmp
${Filename}    Roles.xlsx
*** Keywords ***
System Logon
    Start Process    ${symvar('SAP_LOGON_PATH')}
    Connect To Session
    Open Connection     ${symvar('GRC_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('GRC_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('GRC_User')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('GRC_PASSWORD')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{GRC_PASSWORD} 
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex

Display customaized roles
    Run Transaction    /nSE16
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    GRACROLE
    Send Vkey    0
    Input Text    wnd[0]/usr/txtI2-LOW    ZC*
    Click Element    wnd[0]/tbar[1]/btn[8]
    Click Element    wnd[0]/tbar[1]/btn[43]
    Click Element    wnd[1]/tbar[0]/btn[0]
    Input Text      wnd[1]/usr/ctxtDY_PATH  ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${path_to_download}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Filename}
    Click Element    wnd[1]/tbar[0]/btn[0]