*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${File_path}    ${CURDIR}\\keyfile.txt
@{GIVE_TASK_DESCRIPTIONS}    Health Monitoring    Performance Monitoring    Integration Monitoring    

*** Keywords ***
System Logon
    Start Process     ${symvar('ABAP_SAP_SERVER')}
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('ABAP_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABAP_PASSWORD')}  
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    # Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
    # Sleep    2

System Logout
    Run Transaction     /nex
 
System Registration
    Run Transaction     /n/SDF/ALM_SETUP
    Sleep    2
    ${already exist}    Get Value    wnd[0]/usr/txtLMSIDCOM
    IF  '${already exist}' != 'None'
        Click Element    wnd[0]/usr/btn%P016025_1000
        Sleep    10
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Click Element    wnd[0]/usr/btn%P017010_1000
        Sleep    2
        
    END
    Input Text    wnd[0]/usr/ctxtDEST    BCS_ALM
    Sleep    2
    Send Vkey    0
    Sleep    2
    Click Element    wnd[0]/usr/btnUPD
    Sleep    2
    Click Element    wnd[1]/usr/btnPASTE
    Sleep    2
    ${get text}    Get File Content   ${File_path} 
    Log    ${get text}
    Input Text    wnd[1]/usr/cntlSEC_AP_CONTROL/shellcont/shell    ${get text}
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Click Element    wnd[2]/tbar[0]/btn[0]
    Sleep    2
    Input Text    wnd[0]/usr/txtAUTHUSER    ALM_USER
    Sleep    2
    Click Element    wnd[0]/usr/btnREG
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Click Element    wnd[0]/usr/btn%P018047_1000
    Sleep    2
    
