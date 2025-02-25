*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr
*** Keywords ***
St02
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Run Transaction    /nST02
    Sleep    1
    ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    10
        ${scroll}    Scroll    wnd[0]/usr      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    ST02_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Run Transaction    /nex










    # ${counter}=    Set Variable    1
    # FOR    ${i}    IN RANGE    0    ${row_count + 1}    100
    #     Log    Processing row ${i}
    #     ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
    #     Log To Console    Selected rows: ${selected_rows}
    #     Take Screenshot    ST02_${counter}.jpg
    #     ${counter}=    Evaluate    ${counter} + 1
    #     Sleep    1
    # END
    # Click Element	wnd[0]/tbar[0]/btn[3]