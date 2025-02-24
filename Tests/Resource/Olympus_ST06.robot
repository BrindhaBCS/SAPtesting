*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Variables ***
${TREE_PATH}    wnd[0]/shellcont/shellcont/shell/shellcont[1]/shell  

*** Keywords ***
ST06
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nST06
    Sleep    1
  ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    1
        ${scroll}    Scroll    wnd[0]/usr      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    ST06_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2