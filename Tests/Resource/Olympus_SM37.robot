*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr
*** Keywords ***
SM37
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    SM37
    Sleep    1
    Input Text	wnd[0]/usr/ctxtBTCH2170-FROM_DATE	${EMPTY}
	Sleep	2
	Input Text	wnd[0]/usr/ctxtBTCH2170-TO_DATE	${EMPTY}
    Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
  ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    10
        ${scroll}    Scroll    wnd[0]/usr      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    SM37_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2