*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

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
    Sleep    10

SM14
    Run Transaction    /nSM14
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[13]
    Sleep    2
    Take Screenshot    sm14_1.jpg
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3] 
    Sleep    2
    Click Element    wnd[0]/usr/tabsFOLDER/tabpSERVERS
    Sleep    5
    Take Screenshot    sm14_2.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsFOLDER/tabpGROUPS
    Sleep    10
    Take Screenshot    sm14_3.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsFOLDER/tabpPARAMETERS
    Sleep    2
    Set Focus    wnd[0]/usr/tabsFOLDER/tabpPARAMETERS/ssubSUBSUPDATE:SAPMSM14:1050/tblSAPMSM14PARAMETERLISTE
    Sleep    3
    
    FOR    ${i}    IN RANGE    ${symvar('max_scroll')}
        ${start_row}    Get Scroll Position    wnd[0]/usr/tabsFOLDER/tabpPARAMETERS/ssubSUBSUPDATE:SAPMSM14:1050/tblSAPMSM14PARAMETERLISTE
        # Log    ${start_row}
        Send Vkey    82    
        Take Screenshot    SM14${i+1}parameter.jpg
        Sleep    1
        ${end_row}    Get Scroll Position    wnd[0]/usr/tabsFOLDER/tabpPARAMETERS/ssubSUBSUPDATE:SAPMSM14:1050/tblSAPMSM14PARAMETERLISTE
        # Log    ${end_row}
        Run Keyword If    '${start_row}' == '${end_row}'    Exit For Loop
       
               
    END
    Sleep    6