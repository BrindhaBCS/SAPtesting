*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
STZAD
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSTMS
    Sleep    1
    Take Screenshot    STMS01.jpg
    Click Element	wnd[0]/tbar[1]/btn[19]
	Sleep	2
    Take Screenshot    STMS02.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element	wnd[0]/tbar[1]/btn[18]
	Sleep	2
    Take Screenshot    STMS03.jpg
    Double Click Current Cell	wnd[0]/usr/cntlGRID1/shellcont/shell
	Sleep	2
    Take Screenshot    STMS04.jpg
    Click Element	wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
	Sleep	2
    Take Screenshot    STMS05.jpg
    Click Element	wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
	Sleep	2
    Take Screenshot    STMS06.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2

Connection_test    
    Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[0]
	Sleep	2
    Take Screenshot    STMS07.jpg
