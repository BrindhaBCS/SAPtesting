*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    CustomSapGuiLibrary.py

*** Variables ***
# System Variables
# ${continue_id}    wnd[1]/tbar[0]/btn[0]
# ${text_id}    wnd[1]/usr/txtMESSTXT1
# ${status_line}    wnd[0]/usr/txtPAT100-PATCH_STEP
${no_Queue_id}    wnd[0]/usr/txtPAT100-STAT_LINE2
${finish_str}   Confirm queue
${status_line}    wnd[0]/usr/sub:SAPLSAINT_UI:0100/txtWA_COMMENT_TEXT-LINE[0,0]
${refresh_id}   wnd[0]/tbar[1]/btn[30]
${button_id}    wnd[0]/mbar/menu[0]/menu[5]
${comp_id}  wnd[1]/usr/tabsQUEUE_CALC/tabpQUEUE_CALC_FC1/ssubQUEUE_CALC_SCA:SAPLOCS_ALV_UI:0306/cntlCONTROL_ALL_COMP/shellcont/shell


*** Keywords *** 
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5s
    Connect To Session
    Sleep    5
    Open Connection     ${symvar('Nike_connection')}
    Sleep   5
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER')}    
    Sleep    1
    # ${CFG_PASS}   OperatingSystem.Get Environment Variable    CFG_PASS
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS} 
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS')}  

    Sleep   2
    Send Vkey    0
    Sleep    5
    Take Screenshot    01_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg

Spam Transaction
    Run Transaction     spam  
    Sleep    5
    Take Screenshot    B01_spam.jpg

Certificate Verification
    Get Maintenance Certificate Text    wnd[0]/sbar/pane[0]
    Sleep    2
    Take Screenshot    C01_Certificate.jpg

Loading package    
    CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[0]/menu[1]
    Sleep    2
    Take Screenshot    D01_Load_1.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnSPOP-OPTION1
    Sleep    2
    Take Screenshot    D02_Load_2.jpg
    CustomSapGuiLibrary.Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot    D03_Load_3.jpg

Display/Define
    CustomSapGuiLibrary.Click Element    wnd[0]/usr/btnPAT100-QUEUE
    Sleep    2
    Take Screenshot    E01_Display.jpg
    # Select Item From Guilabel    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell    ${symvar('addOn')} 
    # Take Screenshot    E02_Display.jpg       

Spam Component selection
    ${row}    CustomSapGuiLibrary.Select Spam Based On Text    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell     ${symvar('patch_comp')}
    Log    ${row}
    Select Table Row    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell    ${row}
    Sleep    2
    Take Screenshot    08_Spam_component1.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    09_Spam_component2.jpg

Spam Patch selection
    ${patch_value}  CustomSapGuiLibrary.Spam Search and Select Label    wnd[1]/usr  ${symvar('patch_vers')}
    Log    ${patch_value}   
    Sleep    2
    Take Screenshot    09_patch_select.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    10_Spam_patch1.jpg

Important SAP note handling
    CustomSapGuiLibrary.Is Imp Notes Existing   wnd[1]  wnd[1]/tbar[0]/btn[0]
    Take Screenshot    G01_SAP_note.jpg
    # CustomSapGuiLibrary.Click Element    wnd[2]/tbar[0]/btn[0]

    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnBUTTON_2
    Take Screenshot  G02_Modification.jpg  
   
Importing queue from support package
    CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[3]
    # CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    H01_Imp_que_1.jpg
    #import queue-start options
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[27] 
    Take Screenshot    H02_Start_options.jpg

    #CLicking "Start in background immediately"
    Sleep   1
    CustomSapGuiLibrary.Select Radio Button    wnd[1]/usr/tabsSTART_OPTIONS/tabpSTART_FC1/ssubSTART_OPTIONS_SCA:SAPLOCS_UI:0701/radLAY0700-RB1_DIA
    Sleep   1
    Take Screenshot    H03_Start_bkgd.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    H04_import.jpg    
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[25]
    Take Screenshot    H05_Start_bkgd_3.jpg
    Sleep    3
    CustomSapGuiLibrary.Click Element    wnd[0]/tbar[1]/btn[20]
    Sleep    2
    Take Screenshot    H05_ignore.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Take Screenshot    G03_install_success.jpg
    CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[5]
    Sleep    2
    Take Screenshot    G03_Confirm_queue.jpg
    CustomSapGuiLibrary.Click Element   wnd[1]/tbar[0]/btn[27]
    Take Screenshot    G03_Donottsend.jpg

Additional logon
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT_1')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER_1')}    
    Sleep    1
    # ${CFG_PASS}   OperatingSystem.Get Environment Variable    CFG_PASS
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS} 
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS')}  

Confirm Queue    
    ${cell_text_1}    CustomSapGuiLibrary.Get Finish Cell Text1    ${finish_str}    ${button_id}    ${status_line}    ${refresh_id}
    Log    ${cell_text_1}
    #CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[5]
    Take Screenshot    G01_Confirmed_queue.jpg
    #Status check: No queue has been defined
    CustomSapGuiLibrary.No Queue Pending    ${no_Queue_id}
    Take Screenshot    G02_Status_Confirmed_queue1.jpg
    #Click DoNOTSEND
    CustomSapGuiLibrary.Click Element   wnd[1]/tbar[0]/btn[27]
    Take Screenshot    G03_Status_Confirmed_queue2.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
