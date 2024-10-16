*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py


*** Variables ***
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id6}    02${SPACE*2}1${SPACE*5}10
${link_id7}    01${SPACE*2}1${SPACE*6}1
${link_id8}    03${SPACE*2}2${SPACE*6}1
${link_id9}    04${SPACE*2}2${SPACE*6}2
${link_id10}    1
${BACK}    wnd[0]/tbar[0]/btn[3]
${Execute}    wnd[0]/tbar[1]/btn[8]


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
Emergency User Edition
    Run Transaction     /nSUIM
    Sleep    2
    Take Screenshot    Emergency_User_Edition1.jpg
    Click Node Link 1   ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id10}
    Sleep    5
    Take Screenshot    Emergency_User_Edition2.jpg
    Input Text    wnd[0]/usr/ctxtUSER-LOW    *SAP*
    Sleep    1
    ${current_date}=    Evaluate    datetime.datetime.now().strftime('%d.%m.%Y')    datetime
    Sleep    2
    Input Text    wnd[0]/usr/ctxtFDATE    ${current_date}
    Log    ${current_date}
    Sleep    1
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkPASS
    Sleep    1
    Take Screenshot    Emergency_User_Edition3.jpg
    Click Element    ${Execute}
    Sleep    1
    Take Screenshot    Emergency_User_Edition4.jpg
    ${Change users}    Get Value    wnd[0]/sbar
    Log To Console    ${Change users}
    Log    ${Change users}
    Click Element    ${BACK}
    Sleep    1
    Log To Console    Emergency User Edition Completed
   