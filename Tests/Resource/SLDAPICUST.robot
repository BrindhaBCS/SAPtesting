*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

Transaction SLDAPICUST
    Run Transaction     /nSldapicust
    Sleep   1
    Take Screenshot    070_Sldapicust.jpg

Sldapicust display
    ${destination}  get cell value from gridtable   wnd[0]/usr/cntlCONTAINER/shellcont/shell
    Log     ${destination}
    Run Transaction     /nsm59
    Click Element   wnd[0]/mbar/menu[1]/menu[5]
    Input Text   wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[0,24]       SLD_BCSCLNTPO
    Sleep   5
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep  5s
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   5s
    Take Screenshot    071_display.jpg
    Sleep   5s
    Click Element   wnd[0]/usr/tabsTAB_SM59/tabpSIGN
    Sleep   5s
    Take Screenshot    072_display.jpg  
 

