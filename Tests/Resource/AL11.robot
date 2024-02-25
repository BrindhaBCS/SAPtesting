
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

Transaction AL11

    Run Transaction     /nal11
    Send Vkey    0
    Take Screenshot    025_al11.jpg
    Sleep    2
    Table Scroll   wnd[0]/usr/cntlEXT_COM/shellcont/shell    23 
    Sleep    2
    Take Screenshot    026_al11.jpg