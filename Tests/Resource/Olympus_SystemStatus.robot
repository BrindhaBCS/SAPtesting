*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SystemStatus
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Click Element	wnd[0]/mbar/menu[4]/menu[11]
	Sleep	2
    Take Screenshot    SystemStatus.jpg
    Click Element	wnd[1]/tbar[0]/btn[17]
	Sleep	2
    Take Screenshot    Kernal.jpg
    Close Window	wnd[2]
	Sleep	2
    Click Element	wnd[1]/usr/btnPRELINFO
	Sleep	2
    
    Take Screenshot    SAP_systemdata.jpg
    Click Element	wnd[2]/usr/tabsVERSDETAILS/tabpPROD_VERS
	Sleep	2
    Take Screenshot    installationdetails.jpg
    Close Window	wnd[2]
	Sleep	2
	Close Window	wnd[1]
	Sleep	2
 
   
