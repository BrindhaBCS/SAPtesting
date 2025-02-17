*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SM14
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSM14
    Sleep    1
    Take Screenshot    SM14.jpg01
    Click Element	wnd[0]/usr/tabsFOLDER/tabpUPDATE/ssubSUBSUPDATE:SAPMSM14:1010/btnALL_REQUESTS
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Take Screenshot    SM14.jpg02
	Click Element	wnd[0]/usr/tabsFOLDER/tabpSERVERS
	Sleep	2
    Take Screenshot    SM14.jpg03
	Click Element	wnd[0]/usr/tabsFOLDER/tabpGROUPS
	Sleep	2
    Take Screenshot    SM14.jpg04
	Click Element	wnd[0]/usr/tabsFOLDER/tabpPARAMETERS
	Sleep	2
    Take Screenshot    SM14.jpg05
    Click Element    wnd[0]/tbar[0]/btn[3]