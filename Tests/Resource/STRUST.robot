*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py


*** Variables ***
# ${SYMPHONY_JOB_ID}    12345
${SCREENSHOT_PATH}   ${OUTPUT_DIR}

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    2s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    #Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    # Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    # Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    1
    # Take Screenshot    logoutpage.jpg
    # Sleep    10
Transaction STRUST
    Run Transaction     /nstrust
    Send Vkey    0
    Take Screenshot    029_PSE.jpg
    Sleep    2
    
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    030_PSE.jpg
    Sleep    2

SSL server standard        
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT    
    Sleep    2
    Take Screenshot    031_SSLSDFAULT.jpg
    Sleep    2

    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    032_SSLSDFAULT.jpg
    Sleep    2

SSL client SSL Client (Anonymous)
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Take Screenshot    033_SSLCANONYM.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    034_SSLCANONYM.jpg
    Sleep    2

SSL client SSL Client (Standard)
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    Take Screenshot    035_SSLCDFAULT.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    036_SSLCDFAULT.jpg
    Sleep    2

WS Security Other System Encryption
    Double Click On Tree Item    wnd[0]/shellcont/shell    WSSEWSSCRT    
    Sleep    2
    Take Screenshot    037_WSSEWSSCRT.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    038_WSSEWSSCRT.jpg
    Sleep    2
SSF Logon Ticket
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSFASSO2    
    Sleep    2
    Take Screenshot    039_SSFASSO2.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    040_SSFASSO2.jpg
    Log    ${SCREENSHOT_PATH}     
    Merger.Create Pdf    ${symvar('symphony_job_id')}    ${SCREENSHOT_PATH}    
  