*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

Transaction STMS
    Run Transaction     /nSTMS
    Sleep   1
    Take Screenshot    073_stms.jpg
    Click Element   wnd[0]/mbar/menu[0]/menu[4]
    Sleep   1
    Take Screenshot    074_stms.jpg
    
    Rows From Stms    wnd[0]/usr/cntlGRID1/shellcont/shell
    Sleep   1
    Take Screenshot    075_stms.jpg

    Click Element    wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpATTR
    Sleep    2
    Take Screenshot    076_stms.jpg

    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
    Sleep   1
    Take Screenshot    077_stms.jpg    
    
    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
    Sleep   1
    Take Screenshot    078_stms.jpg
    
Import Overview
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    079_stms.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    080_stms.jpg
    Click Element   wnd[0]/tbar[1]/btn[5]
    Sleep   1
    Take Screenshot    081_stms.jpg

Transport Routes
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    082a_stms.jpg
    Click Element   wnd[0]/tbar[1]/btn[19]
    Sleep   1
    Take Screenshot    082b_stms.jpg
   

Transport Layers
    Click Element   wnd[0]/mbar/menu[2]/menu[1]
    Sleep   1
    Take Screenshot    083_stms.jpg

