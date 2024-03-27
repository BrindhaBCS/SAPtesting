*** Settings ***
Library        SAP_Tcode_Library.py
Library         Process



*** Variables ***

${CLIENT}    wnd[0]/usr/ctxtSEQG3-GCLIENT
${user_field}    wnd[0]/usr/txtSEQG3-GUNAME
${List_Button_sm12}    wnd[0]/tbar[1]/btn[8]

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


SM12_Transation_Code
    Run Transaction    /nsm12             
    Sleep    3
    Take Screenshot    sm12.jpg
    Input Text    ${CLIENT}    *
    Sleep    1
    Input Text    ${user_field}    *              
    Click Element    ${List_Button_sm12}
    Sleep    3
    Take Screenshot    lockEntryList.jpg
    

System Logout
    Run Transaction   /nex
    Sleep    5
    # Take Screenshot    logoutpage.j
    Sleep    10
    #Create Pdf    ${output_directory}    ${output_pdf}
