
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***
Transaction SM69

    Run Transaction     /nsm69
    Send Vkey    0
    # Take Screenshot    001_sm69.jpg
    Sleep    1

External Operating System Commands

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    23    
    Sleep    1
    # Take Screenshot    002_sm69.jpg

SM69 Scroll

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    46    
    Sleep    1
    # Take Screenshot    003_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    69    
    Sleep    1
    # Take Screenshot    004_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    92    
    Sleep    1
    # Take Screenshot    005_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    103   
    Sleep    1
    # Take Screenshot    006_sm69.jpg