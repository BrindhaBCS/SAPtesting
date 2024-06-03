
*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    CustomSapGuiLibrary.py
Library    PDF.py

*** Variables ***
# **System Variables**
${finish_str}   Confirm queue
${status_line}    wnd[0]/usr/txtPAT100-PATCH_STEP
${refresh_id}   wnd[0]/tbar[1]/btn[30]
${no_Queue_id}    wnd[0]/usr/txtPAT100-STAT_LINE2
${button_id}    wnd[0]/mbar/menu[0]/menu[5]    
${screenshot_directory}     ${OUTPUT_DIR}
${output_pdf}   ${OUTPUT_DIR}\\Spam.pdf
${spam_status_id}    wnd[0]/usr/txtPAT100-STOPREASO
${spam_status}    (SPDD_SPAU_CHECK)    
${execute_id}    wnd[0]/tbar[1]/btn[8]


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

Spam Transaction
    Run Transaction     spam  
    Sleep    5
    Take Screenshot    001_spam.jpg

Certificate Verification
    Get Maintenance Certificate Text    wnd[0]/sbar/pane[0]
    Sleep    2
    Take Screenshot   001a_Certificate.jpg

Version check
    CustomSapGuiLibrary.Click Element    wnd[0]/usr/btnPATCH_STATUS
    Sleep    2
    Take Screenshot    002a_Pre_upgrade_Version_1.jpg
    
    ${row}    CustomSapGuiLibrary.Select Spam Version    wnd[1]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell     ${symvar('addOn')}
    Log    ${row}
    Take Screenshot    002b_Pre_upgrade_Version_1.jpg
    
    CustomSapGuiLibrary.Select Table Row    wnd[1]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ${row}
    Sleep    6
    Take Screenshot    002c_Pre_upgrade_Version_1.jpg
    Click Element    wnd[1]/tbar[0]/btn[0]

Loading package    
    CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[0]/menu[1]
    Sleep    2
    Take Screenshot    003_Load_1.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnSPOP-OPTION1
    Sleep    2
    Take Screenshot    004_Load_2.jpg
    CustomSapGuiLibrary.Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot    005_Load_3.jpg

Display/Define
    CustomSapGuiLibrary.Click Element    wnd[0]/usr/btnPAT100-QUEUE
    Sleep    2
    Take Screenshot    006_Display.jpg
    
Spam Component selection
    ${row}    CustomSapGuiLibrary.Select Spam Based On Text    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell     ${symvar('patch_comp')}
    Log    ${row}
    Take Screenshot    007_Spam_component1.jpg
    Select Table Row    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell    ${row}
    Sleep    2
    Take Screenshot    008_Spam_component2.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    009_Spam_component3.jpg

Spam Patch selection
    ${patch_value}  CustomSapGuiLibrary.Spam Search and Select Label    wnd[1]/usr  ${symvar('patch_vers')}
    Log    ${patch_value}   
    Sleep    2
    Take Screenshot    010_patch_select1.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    011_patch_select2.jpg

Important SAP note handling
    CustomSapGuiLibrary.Is Imp Notes Existing   wnd[1]  wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    012_SAP_note.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnBUTTON_2
    Sleep   2
    Take Screenshot    013_Modification.jpg  
   
Importing queue from support package
    CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[3]
    Sleep   2
    Take Screenshot    014_Imp_que_1.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[27] 
    Sleep   2
    Take Screenshot    015_Imp_que_2.jpg

Start Options
    CustomSapGuiLibrary.Select Radio Button    wnd[1]/usr/tabsSTART_OPTIONS/tabpSTART_FC1/ssubSTART_OPTIONS_SCA:SAPLOCS_UI:0701/radLAY0700-RB1_DIA
    Sleep   2
    Take Screenshot    016_prep_dial.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/usr/tabsSTART_OPTIONS/tabpSTART_FC2
    Sleep   2
    Take Screenshot    017_import_select.jpg
    CustomSapGuiLibrary.Select Radio Button    wnd[1]/usr/tabsSTART_OPTIONS/tabpSTART_FC2/ssubSTART_OPTIONS_SCA:SAPLOCS_UI:0702/radLAY0700-RB2_BTCHIM
    Sleep   2
    Take Screenshot    018_import_bkgd.jpg

Import Option
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    019_import1.jpg    
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[25]
    Take Screenshot    020_import2.jpg
    Sleep    2
    CustomSapGuiLibrary.is errors during disassembling existing    wnd[0]   wnd[0]/tbar[1]/btn[20]
    Sleep    2
    Take Screenshot    021_ignore.jpg
    CustomSapGuiLibrary.is spam user defined existing    wnd[1]    wnd[1]/tbar[0]/btn[0]        
    Sleep    2
    Take Screenshot    022_User_defined.jpg


Confirm Queue
    ${cell_text_1}    CustomSapGuiLibrary.Get Finish Cell Text1    ${finish_str}    ${button_id}    ${status_line}    ${refresh_id}
    Log    ${cell_text_1}
    Sleep   2
    Take Screenshot    023_Confirmed_queue.jpg
    CustomSapGuiLibrary.No Queue Pending    ${no_Queue_id}
    Sleep   2
    Take Screenshot    024_Status_Confirmed_queue1.jpg
    CustomSapGuiLibrary.Click Element   wnd[1]/tbar[0]/btn[27]
    Sleep   2
    Take Screenshot    025_Status_Confirmed_queue2.jpg

Version check post upgrade
    CustomSapGuiLibrary.Click Element    wnd[0]/usr/btnPATCH_STATUS
    Sleep    2
    Take Screenshot    026a_Post_upgrade_Version_1.jpg
    
    ${row}    CustomSapGuiLibrary.Select Spam Version    wnd[1]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell     ${symvar('addOn')}
    Log    ${row}
    Take Screenshot    026b_Post_upgrade_Version_1.jpg
    
    CustomSapGuiLibrary.Select Table Row    wnd[1]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ${row}
    Sleep    6
    Take Screenshot    026c_Post_upgrade_Version_1.jpg

System Logout
    Run Transaction   /nex
    Sleep    2
    Create Pdf    ${screenshot_directory}   ${output_pdf}    
    Sleep   2