*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py


*** Variables ***
${source_directory}     ${OUTPUT_DIR}

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    #Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Merger.copy images    ${source_directory}      ${symvar('target_directory')}  


Transaction OACO
    Run Transaction     /nOAC0
    Sleep   1
    Take Screenshot    053_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       35
    Sleep   1
    Take Screenshot    054_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       70
    Sleep   1
    Take Screenshot    055_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       105
    Sleep   1
    Take Screenshot    056_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       140
    Sleep   1
    Take Screenshot    057_OACO.jpg
    # Merger.create pdf    ${screenshot_directory}    
    # Sleep    2

