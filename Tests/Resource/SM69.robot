
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
    Sleep    1
    Merger.copy images    ${source_directory}      ${symvar('target_directory')}  

Transaction SM69

    Run Transaction     /nsm69
    Send Vkey    0
    Take Screenshot    001_sm69.jpg
    Sleep    1

External Operating System Commands

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    23    
    Sleep    1
    Take Screenshot    002_sm69.jpg

SM69 Scroll

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    46    
    Sleep    1
    Take Screenshot    003_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    69    
    Sleep    1
    Take Screenshot    004_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    92    
    Sleep    1
    Take Screenshot    005_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    103   
    Sleep    1
    Take Screenshot    006_sm69.jpg

