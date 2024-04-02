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

uploading_role
    Run Transaction    /nPFCG
    Sleep    2
    FOR    ${upload_index}    IN RANGE    0    1000
        Sleep    1
        Click Element    wnd[0]/mbar/menu[0]/menu[7]        
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[0]            
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('uploading_path')}
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${EMPTY}
        Sleep    1  
        ${upload_role_input} =    Run Keyword And Return Status    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${symvar('uploading_file_names')}[${upload_index}]
        Run Keyword If    not ${upload_role_input}    Exit For Loop
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[0]    
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[0]   
        Take Screenshot    upload_role_01.jgp
        Sleep    1
    #--genrate--mass generation
        Click Element    wnd[0]/mbar/menu[3]/menu[1]    
        Sleep    1
        Select Radio Button    wnd[0]/usr/radPRT_ALL    
        Sleep    1
        Click Element    wnd[0]/usr/btn%_SEL_SHT_%_APP_%-VALU_PUSH    
        Sleep    1
        Input Text    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,0]    ${symvar('upload_role_names')}[${upload_index}]
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[8]            
        Sleep    1
        Select Checkbox    wnd[0]/usr/chkAUTO_GEN        
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[8]   
        Sleep    1
        Click Element    wnd[1]/usr/btnBUTTON_2        
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]    
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]    
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]   
        Sleep    1
        Take Screenshot    upload_role_02.jgp
    END