*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***






Transaction WE20
    Run Transaction     /nwe20
    Sleep   1
    Take Screenshot    084_WE20.jpg

Partner type LS
    Select Node     wnd[0]/shellcont/shell  LS
    Sleep   1
    Take Screenshot    085_typeLS.jpg
    Click Element   wnd[0]/tbar[1]/btn[46]
    Sleep   1
    Take Screenshot    086_typeLS.jpg
    Input Text  wnd[1]/usr/ctxtGSO_PTYP-LOW     LS
    Sleep   1
    Take Screenshot    087_typeLS.jpg
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Take Screenshot    088_typeLS.jpg
    Get No Entries Found Text   wnd[0]/sbar/pane[0]
    Sleep   1  
    Take Screenshot    089_typeLS.jpg

Partner type LI
    Select Node     wnd[0]/shellcont/shell  LI
    Sleep   1
    Take Screenshot    090_typeLI.jpg
    Click Element   wnd[0]/tbar[1]/btn[46]
    Sleep   1
    Take Screenshot    091_typeLI.jpg
    Input Text  wnd[1]/usr/ctxtGSO_PTYP-LOW     LI
    Sleep   1
    Take Screenshot    092_typeLI.jpg
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Take Screenshot    093_typeLI.jpg
    Get No Entries Found Text   wnd[0]/sbar/pane[0]
    Sleep   1
    Take Screenshot    094_typeLI.jpg

