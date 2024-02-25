*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

Transaction STRUST
    Run Transaction     /nstrust
    Send Vkey    0
    Take Screenshot    029_PSE.jpg
    Sleep    2
    
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    030_PSE.jpg
    Sleep    2

SSL server standard        
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT    
    Sleep    2
    Take Screenshot    031_SSLSDFAULT.jpg
    Sleep    2

    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    032_SSLSDFAULT.jpg
    Sleep    2

SSL client SSL Client (Anonymous)
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Take Screenshot    033_SSLCANONYM.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    034_SSLCANONYM.jpg
    Sleep    2

SSL client SSL Client (Standard)
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    Take Screenshot    035_SSLCDFAULT.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    036_SSLCDFAULT.jpg
    Sleep    2

WS Security Other System Encryption
    Double Click On Tree Item    wnd[0]/shellcont/shell    WSSEWSSCRT    
    Sleep    2
    Take Screenshot    037_WSSEWSSCRT.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    038_WSSEWSSCRT.jpg
    Sleep    2
SSF Logon Ticket
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSFASSO2    
    Sleep    2
    Take Screenshot    039_SSFASSO2.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    040_SSFASSO2.jpg
