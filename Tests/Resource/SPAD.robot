*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

Transaction SPAD
    Run Transaction     /nSPAD
    Sleep   1
    Take Screenshot    058_spad.jpg
    
ARCH Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    ARCH
    Take Screenshot    059_spad_arch.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1
    Take Screenshot    060_spad_arch.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    061_spad_arch.jpg
    
LOCL Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LOCL
    Take Screenshot    062_spad_locl.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1
    Take Screenshot    063_spad_locl.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    064_spad_locl.jpg

LP01 Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LP01
    Take Screenshot    065_spad_lp01.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1    
    Take Screenshot    066_spad_lp01.jpg    
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    067_spad_lp01.jpg

ZPDF Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    ZPDF
    Take Screenshot    068_spad_zpdf.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1
    Take Screenshot    069_spad_zpdf.jpg
