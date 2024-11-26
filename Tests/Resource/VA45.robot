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
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('RENTAL_PASSWORD')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{RENTAL_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
Rental Document
    Run Transaction     /nVA45
    Sleep   2
    # Input Text      wnd[0]/usr/ctxtSAUART-LOW   ZMV
    ${date}    Get Current Date    result_format=%Y
    Log To Console      ${date}
    Input Text      wnd[0]/usr/ctxtSVALID-LOW   01.${symvar('rental_month')}.${date}
    Sleep   2
    Input Text      wnd[0]/usr/ctxtSVALID-HIGH  30.${symvar('rental_month')}.${date}
    Sleep   2
    Select Radio Button     wnd[0]/usr/radPVBOFF
    Sleep   2
    Click Element   wnd[0]/tbar[1]/btn[8]
    Sleep   2
    Click Element   wnd[0]/tbar[1]/btn[33]
    Select Layout   wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_CUL_LAYOUT_CHOOSE:0500/cntlD500_CONTAINER/shellcont/shell  Contracts - Header
    Click Element   wnd[1]/tbar[0]/btn[0]
    Click Element   wnd[0]/tbar[1]/btn[45]
    Select Radio Button     wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Click Element     wnd[1]/tbar[0]/btn[0]
    Input Text      wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME  ${EMPTY}
    Input Text      wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME  rental
    Click Element   wnd[1]/tbar[0]/btn[20]
    Input Text      wnd[1]/usr/ctxtDY_PATH      ${EMPTY}
    Input Text      wnd[1]/usr/ctxtDY_PATH      ${download_path}
    Click Element   wnd[1]/tbar[0]/btn[0]
    Process Excel    file_path=C:\\TEMP\\rental.xlsx    sheet_name=Sheet1
    Sleep    0.5
    ${json}    Excel To Json    excel_file=C:\\TEMP\\rental.xlsx    json_file=C:\\TEMP\\rental.json
    log    ${json}
    Log To Console    **gbStart**copilot_Sales_Document_status**splitKeyValue**${json}**gbEnd**
    log to console    ${json}  
    Sleep    0.5
    Delete Specific File    file_path=C:\\TEMP\\rental.json



    
