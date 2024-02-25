*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

Transaction SHMM
    Run Transaction     /nshmm
    Send Vkey    0
    Take Screenshot    027_shmm.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsTAB_0100/tabpTAB_0100_TUNE
    Take Screenshot    028_shmm_shared_Memory.jpg
