*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***
Transaction SMQS
    Run Transaction     /nsmqs
    Send Vkey    0
    Take Screenshot    007_smqs_QRFC Monitor.jpg
    Sleep    1

QRFC Administration     
    Click Element  wnd[0]/mbar/menu[2]/menu[0]
    Take Screenshot     008_smqs_QRFC Administration1.jpg
    Send Vkey    82
    Take Screenshot     009_smqs_QRFC Administration2.jpg
    Send Vkey    82
    Take Screenshot     010_smqs_QRFC Administration3.jpg
    Send Vkey    82
    Take Screenshot     011_smqs_QRFC Administration4.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1

QRFC Administration INBOUND
    Click Element  wnd[0]/mbar/menu[2]/menu[0]
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[1]
    Sleep    1
    Take Screenshot        012_smqs_QRFC Administration INBOUND.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]

QRFC Administration OUTBOUND
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[0]
    Sleep    1
    Take Screenshot        013_smqs_QRFC Administration OUTBOUND.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]


QRFC Administration OUTBOUND SCHEDULER
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[2]
    Sleep    1
    Take Screenshot        014_smqs_QRFC Administration OUTBOUND SCHEDULER.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]

QRFC Administration INBOUND SCHEDULER
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[3]
    Sleep    1
    Take Screenshot        015_smqs_QRFC Administration INBOUND SCHEDULER.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[3]

Display Possible Resources
    Click Element  wnd[0]/mbar/menu[2]/menu[1]
    Sleep    1
    Take Screenshot        016_smqs_Display Possible Resources.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]

