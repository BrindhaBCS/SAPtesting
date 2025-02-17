*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
AL11
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nAL11
    Sleep    1
    # Table Scroll   wnd[0]/usr/cntlEXT_COM/shellcont/shell    23 
    # Sleep    2
  ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    5    30
        ${scroll}    Scroll   wnd[0]/usr/cntlGRID1/shellcont/shell      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    ST06_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
   