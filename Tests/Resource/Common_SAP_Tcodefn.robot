*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    PDF.py


*** Variables ***
${SAP_SERVER}     C:\\Program Files\\SAP\\FrontEnd\\SAPGUI\\saplogon.exe     
${logon}    /app/con[0]/ses[0]/wnd[0]/mbar/menu[0]/menu[0]
${FIELD_CLIENT}     wnd[0]/usr/txtRSYST-MANDT
${FIELD_USER}   wnd[0]/usr/txtRSYST-BNAME
${FIELD_PASSWORD}   wnd[0]/usr/pwdRSYST-BCODE
${screenshot_directory}     D:\\SAP_Testing\\sap_testing\\Output\\pabot_results\\0
${output_pdf}   D:\\SAP_Testing\\sap_testing\\Output\\pabot_results\\0\\output.pdf

*** Keywords ***
System Logon
    Start Process     ${SAP_SERVER}     
    Sleep    10s
    Connect To Session
    Open Connection    IDES    
    Input Text    ${FIELD_CLIENT}    001
    Input Text    ${FIELD_USER}    brindha    
    Input Password   ${FIELD_PASSWORD}    Sreesanth@17
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT1  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10
    # Create Pdf    ${screenshot_directory}   ${output_pdf_path}    
    Sleep   2
    Create Pdf    ${screenshot_directory}    ${output_pdf}