*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
Library    String
*** Variables ***
@{SAP_Note}    3421256    3374186    3312428    3281776    
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('RBT_SAP_CONNECTION')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('RBT_CLIENT_ID')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('RBT_USER_NAME')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('RBT_USER_PASSWORD')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{RBT_USER_PASSWORD}
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
System Logout
    Run Transaction   /nex
    Sleep    3
    Take Screenshot    logoutpage.jpg
SNOTE
    Run Transaction    /nsnote
    Sleep    2
    Set Focus    wnd[0]/usr/lbl[5,3]
    Sleep    2
    Send Vkey    2
    Sleep    2
    Take Screenshot    snote_1.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[33]
    Sleep    1   
    FOR    ${number}    IN    @{SAP_Note}
        Input Text    wnd[0]/usr/txtNUMM-LOW    ${number}
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[8]
        Sleep    3
        ${SAP_note_error}=    Get Value    wnd[0]/sbar/pane[0]
        IF    '${SAP_note_error}' == 'Unable to find SAP Note that meets specified criteria'
            Log    ${number}=${SAP_note_error}
            Log To Console    ${number}=${SAP_note_error}
        ELSE
            Double Click Current Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell    PRSTATUS
            Sleep    2
            ${value}=    Get Value    wnd[0]/usr/subSUB_101:SAPLSCW_NA_SCREEN:0101/txtSCWB_S_SCREEN_NOTE-PRSTATUS_TEXT
            Log    ${number}=${value}
            IF    '${value}' == 'Cannot be implemented'
                Log    ${number}=${value}
                Log To Console    ${number}=${value}
                Click Element    wnd[0]/tbar[0]/btn[3]
                Sleep    1
                Click Element    wnd[0]/tbar[0]/btn[3]
                Sleep    1
            ELSE IF    '${value}' == 'Can be implemented'
                Click Element    wnd[0]/tbar[0]/btn[3]
                Sleep    2
                Click Element    wnd[0]/tbar[1]/btn[25]
                Sleep    10
                Log    ${number}=${value}
                Log To Console    ${number}=${value}
            END
        END
    END
