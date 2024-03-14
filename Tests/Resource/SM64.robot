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

SM64
    Run Transaction    /nSM64
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC1
    Sleep    5
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC2
    Sleep    5
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC3
    Sleep    5
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC4
    Sleep    5
    FOR    ${i}     IN RANGE    1    8
        ${i} =    Evaluate    ${i}*31
        ${selected_rows}    Selected_rows    wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC4/ssubEVTHIST_SCA:RSEVTHIST:4040/cntlBATCH_EVENTS/shellcont/shell    ${i}
        Log To Console    ${i}    
        Take Screenshot    SM64_${i}st.jpg
        Sleep    1
    END
    Sleep    6