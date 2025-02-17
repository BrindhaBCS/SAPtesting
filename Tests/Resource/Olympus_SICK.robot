*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SICK
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSICK
    Sleep    1
    Take Screenshot    SICK.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2  