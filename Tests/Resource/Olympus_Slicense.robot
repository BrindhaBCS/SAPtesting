*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
Slicense
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSlicense
    Sleep    1
    Take Screenshot    slicense.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]