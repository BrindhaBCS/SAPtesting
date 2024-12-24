*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py

*** Variables ***
${TREE_PATH}    wnd[0]/usr/tblRSWBO004CTL_DLVUNITS 
${TREE_PATH2}    wnd[0]/usr/tblRSWBO004CTL_NAMESPACES

*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABLN_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
 
   
System Logout
    Run Transaction   /nex
    # Sleep    2

ABB_SE06
    Run Transaction    /nSE06
    Sleep    1
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    007_SE06_0.jpg
    Click Element	wnd[0]/tbar[1]/btn[17]
	Sleep	0.5s
    Take Screenshot    007_SE06_Modifiable_SystemChangeOption.jpg
    ${row_count}    Get Row Count    wnd[0]/usr/tblRSWBO004CTL_DLVUNITS 
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    7
        Log    Processing row ${i}
        ${selected_rows}    Scroll    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    007_SE06_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    ${row_count}    Get Row Count    wnd[0]/usr/tblRSWBO004CTL_NAMESPACES 
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    9
        Log    Processing row ${i}
        ${selected_rows}    Scroll    ${TREE_PATH2}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    007_SE06_Modifiable_NameRangeTable_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END

Non_Modifiable
    Select From List By key    wnd[0]/usr/cmbGV_SYSTEM_CHANGEABLE	N
	Sleep	2
    Take Screenshot    007_SE06_Non_Modifiable_SystemChangeOptionTable_0.jpg
    ${row_count}    Get Row Count    wnd[0]/usr/tblRSWBO004CTL_DLVUNITS 
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    7
        Log    Processing row ${i}
        ${selected_rows}    Scroll    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    007_SE06_Non_Modifiable_SystemChangeOptionTable_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    ${row_count}    Get Row Count    wnd[0]/usr/tblRSWBO004CTL_NAMESPACES 
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    0    ${row_count + 1}    9
        Log    Processing row ${i}
        ${selected_rows}    Scroll    ${TREE_PATH2}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    007_SE06_Non_Modifiable_NameRangeTable_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1