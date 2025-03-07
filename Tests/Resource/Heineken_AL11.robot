*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr
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
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{'Heineken_User_Password'}
    Send Vkey    0
    Multiple Logon Handling   wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
 
AL11
    Run Transaction    AL11
	Sleep	2
     ${row_count}    Get Row Count    ${TREE_PATH}
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    32
        Log    Processing row ${i}
        ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    AL11_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END

System logout
    Run Transaction    /nex
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}