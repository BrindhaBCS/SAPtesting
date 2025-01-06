*** Settings ***
Library    Process
Library    OperatingSystem
Library     ExcelLibrary
Library    String
Library    SAP_Tcode_Library.py
Library     DateTime
*** Variables ***
${download_path}    C:\\TEMP

*** Keywords *** 
System Logon
    Start Process    ${symvar('SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('Rental_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Rental_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Rental_User')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('RENTAL_PASSWORD')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{RENTAL_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex

Download PDF
    Run Transaction   /nVF03
    Input Text      wnd[0]/usr/ctxtVBRK-VBELN   707326112
    Click Element   wnd[0]/mbar/menu[0]/menu[11]
    Click Element   wnd[1]/tbar[0]/btn[37]
    