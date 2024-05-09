*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    PDF.py

*** Variables ***
${screenshot_directory}     ${OUTPUT_DIR}
${PDF_Dir}    ${OUTPUT_DIR}\\SMGW_REFRESH.pdf

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
SMGW_T_CODE
    Run Transaction    /nSMGW 
    Sleep    2
    Take Screenshot    01_SMGW.jpg
    Sleep    1
    Click Element    wnd[0]/mbar/menu[2]/menu[0]
    Sleep    2
    Take Screenshot    02_SMGW_Goto_logged_on_ client.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Element    wnd[0]/mbar/menu[2]/menu[6]/menu[4]/menu[0]
    Sleep    1
    Take Screenshot    03_SMGW_Manitain_ACL_files_Secinfo_info.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsTAB_APPL/tabpTAB_APPL_FC2
    Sleep    1
    Take Screenshot    04_SMGW_Manitain_ACL_files_Reginfo.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsTAB_APPL/tabpTAB_APPL_FC3
    Sleep    1
    Take Screenshot    05_SMGW_Manitain_ACL_files_Prxyinfo.jpg
    Sleep    2
