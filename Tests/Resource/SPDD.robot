*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    PDF.py

*** Variables ***
${notes}    wnd[0]/usr/splcSPLITTER_MAIN:SAPLSPAU_UI:1100/ssubDATA_SUBSCREEN:SAPLSPAU_UI:1101/tabsSEL_TABSTRIP/tabpSELTAB_NOTES
${with_assistant}    wnd[0]/usr/splcSPLITTER_MAIN:SAPLSPAU_UI:1100/ssubDATA_SUBSCREEN:SAPLSPAU_UI:1101/tabsSEL_TABSTRIP/tabpSELTAB_MODASS
${without_assistant}    wnd[0]/usr/splcSPLITTER_MAIN:SAPLSPAU_UI:1100/ssubDATA_SUBSCREEN:SAPLSPAU_UI:1101/tabsSEL_TABSTRIP/tabpSELTAB_NOMODASS
${deletions}    wnd[0]/usr/splcSPLITTER_MAIN:SAPLSPAU_UI:1100/ssubDATA_SUBSCREEN:SAPLSPAU_UI:1101/tabsSEL_TABSTRIP/tabpSELTAB_DELETIONS
${screenshot_directory}     ${OUTPUT_DIR}
${output_pdf}   ${OUTPUT_DIR}\\SPDD.pdf

*** Keywords ***
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5
    Connect To Session
    Open Connection     ${symvar('Nike_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER')}    
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS} 
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS')}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Create Pdf    ${screenshot_directory}   ${output_pdf}    
    Sleep   2

Transaction SPDD
    Run Transaction     /nspdd
    Send Vkey    0
    Take Screenshot    001_Strust.jpg
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    002_export.jpg
    SAP_Tcode_Library.Window Handling    wnd[1]    Action Protocol    wnd[1]/usr/btnCONTINUE
    Sleep    2
    Take Screenshot    003_export.jpg
    Click Element     ${notes}
    ${notes_text}    Get Value     ${notes}
    Log    ${notes_text}       
    Click Element     ${with_assistant}
    ${with_assistant_text}    Get Value     ${with_assistant}
    Log    ${with_assistant_text}     
    Click Element     ${without_assistant}
    ${without_assistant_text}    Get Value     ${without_assistant}
    Log    ${without_assistant_text}    
    Click Element     ${deletions}
    ${deletions_text}    Get Value     ${deletions}
    Log    ${deletions_text} 
    Run Keyword IF    '${notes_text}' == 'Notes (0)' and '${with_assistant_text}' == 'With Assistant (0)' and '${without_assistant_text}' == 'Without Assistant (0)' and '${deletions_text}' == 'Deletions (0)'    Log    No modifications   
    Take Screenshot    004_export.jpg     
        
