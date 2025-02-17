*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SMT1
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSMT1
    Sleep    1
    Take Screenshot    STM1.JPG01
    Click Element	wnd[0]/usr/tabsTRUST_STRIP/tabpTRUST_STRIP_FC2
	Sleep	2
    Take Screenshot    STM1.JPG02
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2