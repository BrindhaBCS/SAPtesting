*** Settings ***
Library         ExcelLibrary
Library        SAP_Tcode_Library.py   
Library         Collections
Library         Process
Library        openpyxl
# Library        practice_keyword.py
Library        DateTime


*** Variables ***
${Active_work_Process_sm50}    /app/con[0]/ses[0]/wnd[0]/tbar[1]/btn[42]

*** Keywords ***


System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{User_Password}
    Send Vkey    0
    # Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    # Take Screenshot    00_multi_logon_handling.jpg


Transaction_Code_SM50

    Run Transaction     sm50
    Sleep   1
    Send Vkey     0 
    Click Element    ${Active_work_Process_sm50}  
    Sleep    2
    Take Screenshot    SM50.jpg
    Sleep    1

System Logout

    Run Transaction   /nex
    Sleep    5
    # Take Screenshot    logoutpage.j
    Sleep    10
    #Create Pdf    ${output_directory}    ${output_pdf}

