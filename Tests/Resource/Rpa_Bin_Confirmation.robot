*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py
Library    OperatingSystem
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Rpa_Connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Rpa_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Rpa_UserName')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Rpa_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Rpa_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
BIN_Conformation
    Run Transaction    /n/scwm/mon
    Run Keyword And Ignore Error    Input Text    element_id=wnd[1]/usr/ctxtP_LGNUM    text=BC01
    Run Keyword And Ignore Error    Input Text    element_id=wnd[1]/usr/ctxtP_MONIT    text=SAP
    Run Keyword And Ignore Error    Click Element    element_id=wnd[1]/tbar[0]/btn[8]
    Click Element    element_id=wnd[0]/tbar[1]/btn[18]
    Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=C000000002
    Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=C000000005
    Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=N000000085
    ${in}    Get Length    item=${symvar('Inbound_delivery')}
    FOR    ${i}     IN RANGE    0    ${in}
        Double Click On Tree Item    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    id=N000000085
        Sleep    1
        Input Text    element_id=wnd[1]/usr/txtS_DOCNO-LOW    text=${symvar('Inbound_delivery')[${i}]}
        Sleep    1
        Click Element    element_id=wnd[1]/tbar[0]/btn[8]
        Sleep    1
        Click Toolbar Button    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    button_id=N000000109
        Sleep    5
        ${con}    Get Row Count    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell
        ${count}    Evaluate    ${con}-1
        FOR    ${ind}    IN RANGE    0    ${count}
            Rpa Selected Rows    tree_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    first_visible_row=${ind}
            Rpa Dropdown Bin Conformation    tableshell=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    Button=METHODS    MenuItem=@M00006
            Click Toolbar Button    table_id=wnd[0]/usr/subSUB_OIP:/SCWM/SAPLUI_TO_CONF:0120/cntlCC_OIP_TB/shellcont/shell    button_id=OIP_CONF_SAVE
            Sleep    2
            ${status}    Get Value    element_id=wnd[0]/sbar/pane[0]
            Sleep    5
            Log To Console    message=**gbStart**GRpostingstatus**splitKeyValue**${status}**splitKeyValue**object**gbEnd**
            Click Element    element_id=wnd[0]/tbar[0]/btn[3]
        END
    END