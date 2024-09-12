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

Transaction STMS
    Run Transaction     /nSTMS
    Sleep   1
    Take Screenshot    073_stms.jpg
    Click Element   wnd[0]/mbar/menu[0]/menu[4]
    Sleep   1
    Take Screenshot    074_stms.jpg
    
    Rows From Stms    wnd[0]/usr/cntlGRID1/shellcont/shell
    Sleep   1
    Take Screenshot    075_stms.jpg

    Click Element    wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpATTR
    Sleep    2
    Take Screenshot    076_stms.jpg

    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
    Sleep   1
    Take Screenshot    077_stms.jpg    
    
    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
    Sleep   1
    Take Screenshot    078_stms.jpg
    
Import Overview
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    079_stms.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    080_stms.jpg
    Click Element   wnd[0]/tbar[1]/btn[5]
    Sleep   1
    Take Screenshot    081_stms.jpg

Transport Routes
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    082a_stms.jpg
    Click Element   wnd[0]/tbar[1]/btn[19]
    Sleep   1
    Take Screenshot    082b_stms.jpg
   

Transport Layers
    Click Element   wnd[0]/mbar/menu[2]/menu[1]
    Sleep   1
    Take Screenshot    083_stms.jpg
    Log    Symphony Job ID: ${symvar('symphony_job_id')}
  

    Merger.Create Pdf    ${symvar('symphony_job_id')}    ${screenshot_directory}    
    Sleep    2
