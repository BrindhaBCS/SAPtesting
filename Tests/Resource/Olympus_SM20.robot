*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SM20
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSM20
    Sleep    1
    Take Screenshot    SM20.jpg01
    Click Element	wnd[0]/usr/tabsTABSTRIP/tabpMISC
	Sleep	2
    Take Screenshot    SM20.jpg02
	Click Element	wnd[0]/usr/tabsTABSTRIP/tabpLAYO
	Sleep	2
    Take Screenshot    SM20.jpg03
	Click Element	wnd[0]/usr/tabsTABSTRIP/tabpSTAT
	Sleep	2
    Take Screenshot    SM20.jpg04
    Click Element    wnd[0]/tbar[0]/btn[3]
