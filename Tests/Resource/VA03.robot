
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem        

*** Variables ***      
${department}    wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4302/ctxtVBKD-ABTNR
${order_no}        13029138
   
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg

Verify idoc
    Run Transaction   /nVA02
    Sleep    10s
    Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${symvar('order_no')}
    Sleep    2s
    Send Vkey    0
    Click Element    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/btnBT_OUTPUT
    Sleep    5s
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2s
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Sleep    5s
    Click Element    wnd[0]/mbar/menu[0]/menu[2]
    Sleep    2s 
    Display sales document

Display sales document 
    Run Transaction   /nVA03
    Sleep    10s
    Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${symvar('order_no')}
    Sleep    2s
    Send Vkey    0
    Click Element    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/btnBT_OUTPUT
    Sleep    10s
    ${idoc_status}    Verify The Idoc Jobs    wnd[0]/usr/tblSAPDV70ATC_NAST3    ZBA0    wnd[0]/tbar[1]/btn[26]
    Log To Console   ${idoc_status} 
    
System Logout
    Run Transaction   /nex
    Sleep    10        
    Take Screenshot    logoutpage.jpg
    Sleep    10


