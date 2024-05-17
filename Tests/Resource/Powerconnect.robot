
*** Settings ***
Library    Process
Library    CustomSapGuiLibrary.py
Library    OperatingSystem
Library    String
Library    PDF.py

*** Variables ***
# System Variables
${finish_str}   The Add-on was successfully imported with the displayed queue
${button_id}    wnd[0]/usr/btnBUTTON_NEXT
${status_line}    wnd[0]/usr/sub:SAPLSAINT_UI:0100/txtWA_COMMENT_TEXT-LINE[0,0]
${refresh_id}    wnd[0]/tbar[1]/btn[30]
${certificate_id}    wnd[0]/sbar/pane[0]
${screenshot_directory}     ${OUTPUT_DIR}
${output_pdf}   ${OUTPUT_DIR}\\Saint.pdf
 
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
 
Saint Transation Code
    CustomSapGuiLibrary.Run Transaction     Saint  
    Sleep    2
    Take Screenshot    001_saintfrontpage.jpg

    CustomSapGuiLibrary.get maintenance certificate text    ${certificate_id}
    Sleep    2    
    Take Screenshot    002_certificate.jpg

    Click Element    wnd[0]/mbar/menu[0]/menu[0]/menu[1]
    Sleep    2
    Take Screenshot    003_certificate.jpg

    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnBUTTON_1
    Sleep    2  
    CustomSapGuiLibrary.Take Screenshot    004_saint1.jpg

    CustomSapGuiLibrary.Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    CustomSapGuiLibrary.Take Screenshot    005_saint2.jpg

    CustomSapGuiLibrary.Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Sleep    2    
    CustomSapGuiLibrary.Take Screenshot    006_saint2.jpg


Get Cell Text From SAP Table
    ${foundRow}    CustomSapGuiLibrary.search and select addon rows    ${symvar('addOn')}  
    Log    Found text in row: ${foundRow}  
    Sleep    2
    Take Screenshot    007_addon1.jpg
    CustomSapGuiLibrary.Select Table Row    wnd[0]/usr/subLIST_AREA:SAPLSAINT_UI:0104/tblSAPLSAINT_UIADDON_TO_INSTALL    ${foundRow}
    Sleep    2
    Take Screenshot    008_addon2.jpg
    Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Sleep    2
    Take Screenshot    009_addon2.jpg

Patch selection for the Addon
    Saint Select    wnd[0]/usr/subLIST_AREA:SAPLSAINT_UI:0300/tabsQUEUE_COMP/tabpQUEUE_COMP_FC2/ssubQUEUE_COMP_SCA:SAPLSAINT_UI:0303/cmbGV_01_PATCH_REQ    ${symvar('Patch')}            
    Sleep    2
    Take Screenshot    010_patch1.jpg  
    Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Sleep    2
    Take Screenshot    011_patch2.jpg
    Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Sleep    2
    Take Screenshot    012_patch3.jpg
    Click Element    wnd[1]/usr/btnBUTTON_2
    Sleep    2
    Take Screenshot    013_patch4.jpg
 
Important SAP note handling
    ${content}    CustomSapGuiLibrary.Is Imp Notes Existing    wnd[1]    wnd[1]/tbar[0]/btn[0]
    Log    The window name is: ${content}
    Sleep    2
    Take Screenshot    014_SAPhandling.jpg

Start Options 
    Click Element    wnd[1]/tbar[0]/btn[27] 
    Sleep    2
    Take Screenshot    015_start1.jpg
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
    Sleep    3
    CustomSapGuiLibrary.is errors during disassembling existing    wnd[0]   wnd[0]/tbar[1]/btn[20]
    Sleep    2
    Take Screenshot    021_ignore.jpg
    CustomSapGuiLibrary.is user defined existing    wnd[1]    wnd[1]/tbar[0]/btn[0]        
    Sleep    2
    Take Screenshot    022_User_defined.jpg

Process Until Finish Button Visible  
    ${cell_text_2}    CustomSapGuiLibrary.Get Finish Cell Text    ${finish_str}    ${button_id}    ${status_line}    ${refresh_id}
    Log    ${cell_text_2}
    CustomSapGuiLibrary.Take Screenshot    023_Addon_import1.jpg
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[27]
    Take Screenshot    023_Addon_import2.jpg    

System Logout
    Run Transaction   /nex
    Sleep    2
    Take Screenshot    024_logoutpage.jpg    
    Create Pdf    ${screenshot_directory}   ${output_pdf}    
    Sleep   2