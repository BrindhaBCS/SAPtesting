*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py
*** Keywords ***
System Logon
    Start Process     ${symvar('Heineken_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Heineken_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Heineken_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Heineken_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Heineken_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Heineken_User_Password}
    Send Vkey    0
    Multiple Logon Handling   wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

Oac0_Tcode
    Run Transaction    /nOac0
    Sleep    2
    Take Screenshot    Oac0.jp
    Sleep    2
        ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    97
        ${scroll}    Scroll    wnd[0]/usr/tblSAPLSCMS_CREPC_SREP      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    Oac0_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
     END
    Run Transaction    /nex
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}
    
