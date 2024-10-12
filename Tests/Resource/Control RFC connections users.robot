*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id1}     02${SPACE*2}1${SPACE*6}2
${link_id2}     01${SPACE*2}1${SPACE*6}1
${link_id13}    03${SPACE*2}2${SPACE*5}16
${link_id14}    1
${link_id5}    1
${Execute}    wnd[0]/tbar[1]/btn[8]


*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    2

Control RFC connections users
    Run Transaction    SUIM
    Sleep    2
    Take Screenshot    Control_RFC1.jpg  
    Click Node Link 3    ${tree_id}    ${link_id1}      ${link_id2}    ${link_id13}    ${link_id14}
    Sleep    2
    Take Screenshot    Control_RFC2.jpg
    Unselect Checkbox    wnd[0]/usr/chkDIAGUSER
    Sleep    2
    Unselect Checkbox    wnd[0]/usr/chkREFUSER
    Sleep    2
    Take Screenshot    Control_RFC3.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_RFC4.jpg
    Select Table Column    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    BNAME
    Sleep    2
    ${Read}    Read Table Column    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    BNAME
    Sleep    2
    Log To Console    ${Read}  
    Sleep    2
    ${Count}    Get Length    ${Read}
    Log    ${Count}
    Log To Console    ${Count}
    Take Screenshot    Control_RFC5.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Click Element   wnd[0]/usr/btn%_BNAME_%_APP_%-VALU_PUSH
    Sleep    2
    Set Focus    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,0]
    Send Vkey    0    1
    Sleep    2
    ${row_index}    Set Variable    0
    ${visible_rows}    Set Variable    7
    FOR  ${value}  IN RANGE	${Count}
        ${cell_locator}    Set Variable    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,${row_index}]
        Log To Console    Trying to set value ${value} in cell ${cell_locator}
        Input Text    ${cell_locator}   ${Read}[${value}]
        ${row_index}=  Evaluate  ${row_index} + 1
        IF  ${row_index} >= ${visible_rows}
            ${row_index}    Set Variable    0
            Send Vkey    vkey_id=82    window=1
            Sleep    1
        END
    END
    setFocus    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/btnRSCSEL_255-SOP_I[0,3]
    Sleep    2
    Click Element   wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/btnRSCSEL_255-SOP_I[0,3]
    Sleep    2
    Click Current Cell  wnd[2]/usr/cntlOPTION_CONTAINER/shellcont/shell    "TEXT"
    Sleep    2
    Take Screenshot    Control_RFC6.jpg
    Click Element   wnd[2]/tbar[0]/btn[0]
    Sleep    2
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep    2
    Log To Console    Control RFC connections users completed