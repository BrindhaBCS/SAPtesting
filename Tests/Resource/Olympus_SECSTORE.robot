*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SECSTORE
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSECSTORE
    Sleep    1
    Take Screenshot    SECSTORE01.jpg
    Click Element	wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_KEY
	Sleep	2
    Take Screenshot    SECSTORE02.jpg
	Click Element	wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_GLOB
	Sleep	2
    Take Screenshot    SECSTORE03.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]