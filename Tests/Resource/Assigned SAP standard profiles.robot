*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***    
${start_date}    01.10.2024
${end_date}    10.10.2024
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id1}     02${SPACE*2}1${SPACE*5}10
${link_id2}     01${SPACE*2}1${SPACE*6}1
${link_id3}    03${SPACE*2}2${SPACE*6}1
${link_id4}    04${SPACE*2}2${SPACE*6}2
${link_id5}    1
${Req_Result1_Filename}    SAP_Profiles.xls
${Replace}    wnd[1]/tbar[0]/btn[11]





*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    2

Assigned SAP standard profiles
    Maximize Window
    Run Transaction     SUIM
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    1
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB2
    Sleep    1
   Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB2/ssub%_SUBSCREEN_TAB:RSUSR100N:1200/ctxtF_PROF-LOW    s*
    Send Vkey    0
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB2/ssub%_SUBSCREEN_TAB:RSUSR100N:1200/chkPROF
    Input Text    wnd[0]/usr/ctxtFDATE    ${start_date}
    Input Text    wnd[0]/usr/ctxtTDATE    ${end_date}
    Take Screenshot    req1_output.jpg
    Sleep    3
   
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
   
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep    1
 
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result1_Filename}
    Sleep    1
    # Generate the Results file.
    Click Element    ${Replace}
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Log To Console    Assigned SAP standard profiles Completed
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    1
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1