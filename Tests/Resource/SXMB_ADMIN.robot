*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}  
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}  
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

SXMB_ADMIN
    Run Transaction    /nSXMB_ADMIN
    Sleep    1
    Take Screenshot    integration engine administration and monitoring.jpg
    Double Click On Tree Item    wnd[0]/usr/cntlSPLITTER_CONTAINER_TR/shellcont/shell    CONF_GLOBAL
    Sleep    2
    Take Screenshot    Details of Integration Engine Configuration Data.jpg
    Click Element    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[9]
    Sleep    1
    Take Screenshot    Display view configuration of the integration engine overview.jpg
    Scroll  /app/con[0]/ses[0]/wnd[0]/usr/tblSAPLSXMSCONFUITCTRL_SXMSCONFVLV    position=150
    Click Element    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[7]
    Sleep    2
    Take Screenshot    Integration Engine Configuration Data.jpg
    Sleep    6