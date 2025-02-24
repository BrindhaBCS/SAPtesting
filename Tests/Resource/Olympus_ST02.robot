*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr
*** Keywords ***
St02
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
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