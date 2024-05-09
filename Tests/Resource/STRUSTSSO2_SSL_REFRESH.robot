*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    PDF.py

*** Variables ***
${screenshot_directory}     ${OUTPUT_DIR}
${PDF_Dir}    ${OUTPUT_DIR}\\STRUSTSSO2_SSL_REFRESH.pdf

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
    Sleep    2
    Create Pdf    ${screenshot_directory}   ${PDF_Dir}
    Sleep    2

STRUSTSSO2_SSL
    Run Transaction    /nSTRUSTSSO2
    Sleep    2
    Take Screenshot    01_ssl.jpg
STRUSTSSO2_SSL_System_PSE
    Double Click On Tree Item    wnd[0]/shellcont/shell    PROG<SYST>    
    Sleep    2
    Take Screenshot    02_SSL_System_PSE1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    03_SSL_System_PSE2.jpg
    Sleep    2
STRUSTSSO2_SSL_Sever_Standard       
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT    
    Sleep    2
    Take Screenshot    04_SSL_Sever_Standard1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    05_SSL_Sever_Standard2.jpg
    Sleep    2

STRUSTSSO2_SSL client SSL Client Anonymous
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Take Screenshot    06_SSL client SSL Client Anonymous1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    07_SSL client SSL Client Anonymous2.jpg
    Sleep    2

STRUSTSSO2_SSL client SSL Client Standard
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    Take Screenshot    08_SSL client SSL Client Standard1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    09_SSL client SSL Client Standard2.jpg
    Sleep    2