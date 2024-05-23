*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5
    Connect To Session
    Open Connection     ${symvar('Nike_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT_role')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER_role')}    
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS_role} 
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS_role')}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

uploading_role
    Run Transaction    /nPFCG
    Sleep    2
    ${upload_function}    Get Length  ${symvar('uploading_file_names')}
    Log    ${upload_function}  
    FOR    ${upload_index}    IN RANGE    ${upload_function}
        Sleep    2
        Click Element    wnd[0]/mbar/menu[0]/menu[7]                  
        Sleep    3
        Clear Field Text    wnd[1]/usr/ctxtDY_FILENAME
        Sleep    2 
        Clear Field Text    wnd[1]/usr/ctxtDY_PATH
        Sleep    2
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('uploading_path')}
        Sleep    2 
        ${upload_role_input} =    Run Keyword And Return Status    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${symvar('uploading_file_names')}[${upload_index}]
        Run Keyword If    not ${upload_role_input}    Exit For Loop
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]    
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]  
        Sleep    3
        ${true_condition}    Get Value    wnd[0]/sbar/pane[0]
        IF    '${true_condition}' == 'The file does not exist'
            Take Screenshot    Role_not exist01.jpg
            Sleep    2
            Log    ${true_condition}
            Log To Console    ${true_condition} 
            Sleep    3
            Click Element    wnd[1]/tbar[0]/btn[12]
            Sleep    2                        
        ELSE IF   '${true_condition}' != 'The file does not exist'
            Take Screenshot    upload_role_02.jpg
            Sleep    2
            #--genrate--mass generation 
            Click Element    wnd[0]/mbar/menu[3]/menu[1]    
            Sleep    2
            Select Radio Button    wnd[0]/usr/radPRT_ALL    
            Sleep    2
            Click Element    wnd[0]/usr/btn%_SEL_SHT_%_APP_%-VALU_PUSH    
            Sleep    2
            Input Text    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,0]    ${symvar('upload_role_names')}[${upload_index}]
            Sleep    2
            Click Element    wnd[1]/tbar[0]/btn[8]            
            Sleep    2
            Select Checkbox    wnd[0]/usr/chkAUTO_GEN        
            Sleep    2
            Click Element    wnd[0]/tbar[1]/btn[8]   
            Sleep    2
            Click Element    wnd[1]/usr/btnBUTTON_2        
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]    
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]    
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]   
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]   
            Sleep    2
            Take Screenshot    upload_role_03.jpg
        END 
    END