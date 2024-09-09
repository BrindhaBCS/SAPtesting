*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    CustomSapGuiLibrary.py

*** Variables ***
# System Variables
${continue_id}    wnd[1]/tbar[0]/btn[0]
${text_id}    wnd[1]/usr/txtMESSTXT1
${status_line}    wnd[0]/usr/txtPAT100-PATCH_STEP
${no_Queue_id}    wnd[0]/usr/txtPAT100-STAT_LINE2
${finish_str}   Confirm queue
# ${status_line}    wnd[0]/usr/sub:SAPLSAINT_UI:0100/txtWA_COMMENT_TEXT-LINE[0,0]
${refresh_id}   wnd[0]/tbar[1]/btn[30]
${button_id}    wnd[0]/mbar/menu[0]/menu[5]
${comp_id}    wnd[1]/usr/tabsQUEUE_CALC/tabpQUEUE_CALC_FC1/ssubQUEUE_CALC_SCA:SAPLOCS_ALV_UI:0306/cntlCONTROL_ALL_COMP/shellcont/shell

*** Keywords *** 
System Logon
    Start Process    ${symvar('ABAP_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('ABAP_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_PATCHCLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
Spam Certificate Verification
    Run Transaction     /nspam  
    Get Maintenance Certificate Text    wnd[0]/sbar/pane[0]
    Sleep    2
    Take Screenshot    01_spam.jpg
Loading package
    @{packages}    Generate Package Sequence    ${symvar('supportpackage')}    ${symvar('Current_Version')}
    # Log To Console    @{packages}
    FOR    ${package}    IN    @{packages}
        Click Element    wnd[0]/mbar/menu[0]/menu[0]/menu[0]
        Sleep    2
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('supportpackage_path')}
        Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${package}
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    5
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    5
        ${status1}    Get Value    wnd[0]/sbar/pane[0]
        Log To Console    ${status1}
    END
    Take Screenshot    02_spam.jpg

Display/Define
    Click Element    wnd[0]/usr/btnPAT100-QUEUE
    Take Screenshot    03_spam.jpg

Spam Component selection
    ${row}    Select Spam Based On Text    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell     ${symvar('patch_comp')}
    Log    ${row}
    Select Table Row    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell    ${row}
    Sleep    2
    Take Screenshot    08_Spam_component1.jpg
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    09_Spam_component2.jpg
Spam Patch selection
    ${patch_value}  Spam Search and Select Label    wnd[1]/usr  ${symvar('Current_Version')}
    Log    ${patch_value}   
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    07_spam.jpg

Important SAP note handling
    Is Imp Notes Existing   wnd[1]  wnd[1]/tbar[0]/btn[0]
    Take Screenshot    08_spam.jpg
    Click Element    wnd[2]/tbar[0]/btn[0]
    Click Element    wnd[1]/usr/btnBUTTON_2
    Take Screenshot    09_spam.jpg
   
Importing queue from support package
    Click Element    wnd[0]/mbar/menu[0]/menu[3]
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[27]
    Take Screenshot    10_spam.jpg
    Select Radio Button    wnd[1]/usr/tabsSTART_OPTIONS/tabpSTART_FC1/ssubSTART_OPTIONS_SCA:SAPLOCS_UI:0701/radLAY0700-RB1_BTCHIM
    Take Screenshot    11_spam.jpg
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[25]
    Take Screenshot    12_spam.jpg

Confirm Queue
    
    ${cell_text_1}    Get Finish Cell Text1    ${finish_str}    ${button_id}    ${status_line}    ${refresh_id}
    Log    ${cell_text_1}
    No Queue Pending    ${no_Queue_id}
    Click Element   wnd[1]/tbar[0]/btn[27]
    Take Screenshot    13_spam.jpg
    Log To Console    **gbStart**copilot_status**splitKeyValue**ST-PI support package version is updated to the latest**gbEnd**

