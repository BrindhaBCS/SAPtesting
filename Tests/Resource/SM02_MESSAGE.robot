*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String


   

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

SM02
    Run Transaction     /nSM02
    Sleep   3
    
    ${report}=    Get Certificate Value   wnd[0]/usr    ${symvar('messages')}
    Log To Console    ${report}
    
    ${search_text_found}=    Evaluate    'Certificate is not found' in ${report}
    Log To Console    search${search_text_found}
    IF    ${search_text_found} 
        Log To Console    The system message list is empty
        Click Element    wnd[0]/tbar[1]/btn[34] 
        Sleep    2  
        System Messages    ${symvar('Text_box_ids')}    ${symvar('messages')}
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        RETURN
    ELSE IF  ${report} == ${symvar('messages')}
        Log To Console    ${report}
        RETURN
        
    ELSE    
        Log To Console    ${report}
        
    END

 
System Logout
    Run Transaction     /nex
    Sleep   5
