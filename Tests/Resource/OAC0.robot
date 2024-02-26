*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

Transaction OACO
    Run Transaction     /nOAC0
    Sleep   1
    Take Screenshot
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       35
    Sleep   1
    Take Screenshot    054_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       70
    Sleep   1
    Take Screenshot    055_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       105
    Sleep   1
    Take Screenshot    056_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       140
    Sleep   1
    Take Screenshot    057_OACO.jpg

