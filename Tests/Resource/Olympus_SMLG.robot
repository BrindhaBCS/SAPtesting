*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SMLG
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSMLG
    Sleep    1
    Take Screenshot    SMLG.jpg
    Click Element	wnd[0]/tbar[1]/btn[5]
	Sleep	2
    Take Screenshot    Load.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2