*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    PDF.py
# Test Tags    pdftest


*** Variables ***
${screenshot_directory}     C:\\RobotFramework\\sap_testing\\newoutput_RBT\\43b1080b-5963-4972-916c-fc8f30b71de3\\pabot_results\\0
# ${output_pdf}   C:\\RobotFramework\\sap_testing\\newoutput_RBT\\43b1080b-5963-4972-916c-fc8f30b71de3\\pabot_results\\0\\output.pdf
${output_directory}    ${CURDIR}\\..\\..\\newoutput_RBT\\43b1080b-5963-4972-916c-fc8f30b71de3\\pabot_results\\0
${output_pdf}    ${output_directory}\\output1.pdf

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

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10
    # Create Pdf    ${screenshot_directory}   ${output_pdf_path}    
    # Sleep   2
    # Create Pdf    ${output_directory}    ${output_pdf}

# *** Test Cases ***

# Sample pdf Test
#     System Logon
#     System Logout
