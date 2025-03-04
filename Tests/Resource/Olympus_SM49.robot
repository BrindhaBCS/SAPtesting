*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr/cntlEXT_COM/shellcont/shell
*** Keywords ***
SM49
    # Connect To Session
    # Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    # Sleep    1  
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Run Transaction    /nSM49
    Sleep    1
    ${row_count}    Get Row Count    ${TREE_PATH}
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    24
        Log    Processing row ${i}
        ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    005_SM49_01_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
    Run Transaction    /nex

