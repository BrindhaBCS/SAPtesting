*** Settings ***
Library    Process
Library    CustomSapGuiLibrary.py
Library    OperatingSystem
Library    String

*** Variables ***
# System Variables
${finish_str}   The Add-on was successfully imported with the displayed queue
${button_id}    wnd[0]/usr/btnBUTTON_NEXT
${status_line}    wnd[0]/usr/sub:SAPLSAINT_UI:0100/txtWA_COMMENT_TEXT-LINE[0,0]
${refresh_id}    wnd[0]/tbar[1]/btn[30]
${certificate_id}    wnd[0]/sbar/pane[0]

 
*** Keywords ***
System Logon
    Start Process    ${symvar('EXE_PAD')}
    Sleep   5s
    Connect To Session
    Sleep    5
    Open Connection     ${symvar('Connection_Name')}
    Sleep   5
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('SAP_CLIENT')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SAP_USER')}    
    Sleep    1
    # ${SAP_PASSWORD}   OperatingSystem.Get Environment Variable    SAP_PASSWORD
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}    
    Sleep   2
    Send Vkey    0
    Sleep    5
    Take Screenshot    01_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
 
Saint Transation Code
    CustomSapGuiLibrary.Run Transaction     Saint  
    Sleep    2
    CustomSapGuiLibrary.Take Screenshot    saintfrontpage.jpg
    Sleep    1
    CustomSapGuiLibrary.get maintenance certificate text    ${certificate_id}    
    CustomSapGuiLibrary.Take Screenshot    certificate.jpg
    Sleep   5
    Click Element    wnd[0]/mbar/menu[0]/menu[0]/menu[1]
    Sleep    3
    CustomSapGuiLibrary.Click Element    wnd[1]/usr/btnBUTTON_1
    Sleep    3  
    CustomSapGuiLibrary.Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    10
    CustomSapGuiLibrary.Take Screenshot    Saint1.jpg
   
    CustomSapGuiLibrary.Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Sleep    2    
    CustomSapGuiLibrary.Take Screenshot    saint2.jpg


Get Cell Text From SAP Table
   
    ${foundRow}    CustomSapGuiLibrary.find addon rows    wnd[0]/usr/subLIST_AREA:SAPLSAINT_UI:0104/tblSAPLSAINT_UIADDON_TO_INSTALL    ${symvar('addOn')}
    Log    Found text in row: ${foundRow}
    FOR    ${row_index}    IN    @{foundRow}
        CustomSapGuiLibrary.Select Table Row    wnd[0]/usr/subLIST_AREA:SAPLSAINT_UI:0104/tblSAPLSAINT_UIADDON_TO_INSTALL    ${row_index}
    END
    
    Take Screenshot    saint4.jpg
    Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Sleep    4

Patch selection for the Addon
    Saint Patch Select    ${symvar('addOn')}    ${symvar('Patch')}
    Log    ${symvar('addOn')}
    Log    ${symvar('Patch')}
    Sleep    10
    Take Screenshot    saint5.1.jpg
    Sleep    10
    Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Take Screenshot    saint5.2.jpg
 
    ##Click Continue
    Click Element    wnd[0]/usr/btnBUTTON_NEXT
    Take Screenshot    saint6.jpg
 
    #Clicking "No" for Add Modification Adjustment Transports to the Queue
    Click Element    wnd[1]/usr/btnBUTTON_2
    Take Screenshot    saint7.jpg
 

Important SAP note handling
    ${content}    CustomSapGuiLibrary.Is Imp Notes Existing    wnd[1]    wnd[1]/tbar[0]/btn[0]
    Log    The window name is: ${content}


FOR ST/BNWVS 

    #***clicking Start options: Add-on Installation**
    Click Element    wnd[1]/tbar[0]/btn[27] 
    Take Screenshot    saint8.jpg

    #CLicking "Start in background immediately"
    Sleep   1
    Select Radio Button    wnd[1]/usr/tabsSTART_OPTIONS/tabpSTART_FC1/ssubSTART_OPTIONS_SCA:SAPLOCS_UI:0701/radLAY0700-RB1_BTCHIM
    Sleep   1
    Take Screenshot    saint9.jpg
    Sleep   4

    #Clicking continue
    Click Element   wnd[0]/tbar[0]/btn[0] 
    Take Screenshot    saint10.jpg
    Click Element    wnd[1]/tbar[0]/btn[25]
    Sleep    5 
    Take Screenshot    saint11.jpg

Process Until Finish Button Visible
    
    ${cell_text_2}    CustomSapGuiLibrary.Get Finish Cell Text    ${finish_str}    ${button_id}    ${status_line}    ${refresh_id}
    Log    ${cell_text_2}
    CustomSapGuiLibrary.Take Screenshot    saint12.jpg
    Sleep    2

    #Click DoNOTSEND
    Click Element    wnd[1]/tbar[0]/btn[27]
    Take Screenshot    saint13.jpg    

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg    
    
