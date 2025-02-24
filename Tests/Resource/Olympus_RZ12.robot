*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
RZ12
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nRZ12
    Sleep    1
    Take Screenshot    RZ12.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2  