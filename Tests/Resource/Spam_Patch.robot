*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    CustomSapGuiLibrary.py

*** Variables ***
${EXE_PAD}    C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\saplogon.exe
${TITLE_PAD}  SAP Logon 760
${Connection_Name}    RBT
${SAP_CLIENT}   000
${SAP_USER}   DDIC
${SAP_PASSWORD}   Sym@rocks2023    
${patch_comp}    ST-PI
${patch_vers}    SAPK-74022INSTPI



# System Variables
${continue_id}    wnd[1]/tbar[0]/btn[0]
${text_id}    wnd[1]/usr/txtMESSTXT1
${status_line}    wnd[0]/usr/txtPAT100-PATCH_STEP
${no_Queue_id}    wnd[0]/usr/txtPAT100-STAT_LINE2
${finish_str}   Confirm queue
${status_line}    wnd[0]/usr/sub:SAPLSAINT_UI:0100/txtWA_COMMENT_TEXT-LINE[0,0]
${refresh_id}   wnd[0]/tbar[1]/btn[30]
${button_id}    wnd[0]/mbar/menu[0]/menu[5]

*** Keywords *** 
Spam Transaction
    Run Transaction     spam  
    Sleep    5
    Take Screenshot    02_spam.jpg

Certificate Verification
    Get Maintenance Certificate Text    wnd[0]/sbar/pane[0]
    Sleep    2
    Take Screenshot    03_Certificate.jpg

Loading package
    
    CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[0]/menu[1]
    Sleep    2
    Take Screenshot    04_Load_1.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnSPOP-OPTION1
    Sleep    2
    Take Screenshot    05_Load_2.jpg
    CustomSapGuiLibrary.Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot    06_Load_3.jpg

Display/Define
    CustomSapGuiLibrary.Click Element    wnd[0]/usr/btnPAT100-QUEUE
    Sleep    2
    Take Screenshot    07_Display.jpg

Spam Component selection
    ${row}    CustomSapGuiLibrary.Select Spam Based On Text    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell     ${patch_comp}
    Log    ${row}
    Select Table Row    wnd[1]/usr/cntlCOMP_ONLY_CONTROL/shellcont/shell    4
    Sleep    2
    Take Screenshot    08_Spam_component1.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    09_Spam_component2.jpg

Spam Patch selection
    ${patch_value}  CustomSapGuiLibrary.Spam Search and Select Label    wnd[1]/usr  ${patch_vers}
    Log    ${patch_value}   
    Sleep    2
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Take Screenshot    10_Spam_patch1.jpg

Important SAP note handling
    CustomSapGuiLibrary.Is Imp Notes Existing   wnd[1]  wnd[1]/tbar[0]/btn[0]
    Take Screenshot    11_SAP_note.jpg
    CustomSapGuiLibrary.Click Element    wnd[2]/tbar[0]/btn[0]
   
    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnBUTTON_2
    Take Screenshot  12_Modification.jpg  
   
Importing queue from support package
    CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[3]
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    13_Imp_que_1.jpg
    #import queue-start options
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[27] 
    Take Screenshot    14_Start_options.jpg

    #CLicking "Start in background immediately"
    Sleep   1
    CustomSapGuiLibrary.Select Radio Button    wnd[1]/usr/tabsSTART_OPTIONS/tabpSTART_FC1/ssubSTART_OPTIONS_SCA:SAPLOCS_UI:0701/radLAY0700-RB1_BTCHIM
    Sleep   1
    Take Screenshot    15_Start_bkgd.jpg
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    16_Start_bkgd_2.jpg    
    CustomSapGuiLibrary.Click Element    wnd[1]/tbar[0]/btn[25]
    Take Screenshot    17_Start_bkgd_3.jpg
    Sleep    1


Confirm Queue
    
    ${cell_text_1}    CustomSapGuiLibrary.Get Finish Cell Text1    ${finish_str}    ${button_id}    ${status_line}    ${refresh_id}
    Log    ${cell_text_1}
    #CustomSapGuiLibrary.Click Element    wnd[0]/mbar/menu[0]/menu[5]
    Take Screenshot    18_Confirmed_queue.jpg
    #Status check: No queue has been defined
    CustomSapGuiLibrary.No Queue Pending    ${no_Queue_id}
    Take Screenshot    19_Status_Confirmed_queue1.jpg
    #Click DoNOTSEND
    CustomSapGuiLibrary.Click Element   wnd[1]/tbar[0]/btn[27]
    Take Screenshot    20_Status_Confirmed_queue2.jpg

