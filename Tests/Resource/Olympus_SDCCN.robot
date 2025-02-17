*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SDCCN
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSDCCN
    Sleep    1
    Take Screenshot    Sdccn01.jpg
    Click Element	wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpOUTBOX
	Sleep	2
    Take Screenshot    Sdccn02.jpg
	Click Element	wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpDEL_ITEMS
	Sleep	2
    Take Screenshot    Sdccn03.jpg
	Click Element	wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpSHOWLOG
	Sleep	2
    Take Screenshot    Sdccn04.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]