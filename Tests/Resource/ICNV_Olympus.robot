*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
*** Variables ***

${Olympus_SAP_SERVER}    ${symvar('Olympus_SAP_SERVER')}
${Olympus_SAP_connection}    ${symvar('Olympus_SAP_connection')}

*** Keywords ***
System Logon
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
ICNV  
    Run Transaction    /nICNV
    Sleep   2
    Take Screenshot    053_ICNV_01.jpg
    Sleep    1
System Logout
    Run Transaction    /nex
    Sleep    1
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}