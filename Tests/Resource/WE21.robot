*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py


*** Variables ***
${screenshot_directory}     ${OUTPUT_DIR}

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
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
    Sleep    5
    # Take Screenshot    logoutpage.jpg
    # Sleep    10

Transaction WE21
    Run Transaction     /nwe21
    Sleep   1
    Take Screenshot    095_WE21.JPG
 
Transactional RFC
    Select Node     wnd[0]/shellcont/shell  A
    Sleep   1
    Take Screenshot    096_rfc.JPG
    Click Element   wnd[0]/mbar/menu[0]/menu[2]
    Sleep   1
    Take Screenshot    097_rfc.JPG
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    098_rfc.JPG

File Port
    Select Node     wnd[0]/shellcont/shell  D
    Sleep   1
    Take Screenshot    099_fileport.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    100_fileport.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    101_fileport.jpg

ABAP-PI
    Select Node     wnd[0]/shellcont/shell  S
    Sleep   1
    Take Screenshot    102_ABAP-PI.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    103_ABAP-PI.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    104_ABAP-PI.jpg
XML File
    Select Node     wnd[0]/shellcont/shell  X
    Sleep   1
    Take Screenshot    105_XML.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    106_XML.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    107_XML.jpg

XML HTTP
    Select Node     wnd[0]/shellcont/shell  H
    Sleep   1
    Take Screenshot    108_HTTP.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    109_HTTP.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    110_HTTP.jpg
    Merger.create pdf    ${screenshot_directory}    
    Sleep    2
    
