*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py

*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABLN_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
 
   
System Logout
    Run Transaction   /nex
    # Sleep    2

ABB_SM59
    Run Transaction    /nSM59
    Sleep    1
    Take Screenshot    002_SM59.jpg
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]

    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
	Sleep	1
    Take Screenshot    002_SM59_1.jpg
    
	${in_1}    Set Variable    1
    ${in_1}    Evaluate    ${in_1} + 1
    FOR    ${index}    IN RANGE    8    100
        
        ${status}    Run Keyword And Return Status    Double Click Sap Shell Item    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${index}    &Hierarchy
        IF    '${status}' == 'False'
            ${fld_1}    Set Variable    ${index}
            Exit For Loop
        END    
        Send Vkey    27
        Sleep    1
        Take Screenshot    002_SM59_1.1.${in_1}.jpg
        Sleep    1
        
        Take Screenshot    002_SM59_1.1.${in_1}.jpg
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1
        
    END

    Take Screenshot    002_SM59_10.jpg
    Doubleclick Element	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*9}15	&Hierarchy
	Sleep	2
 
    
    ${Host_name}    Get Value    wnd[0]/usr/tabsTAB_SM59/tabpTECH/ssubSUB_SM59:SAPLCRFC:0500/txtHOSTNAME
    Log To Console    ${Host_name}
    Click Element    wnd[0]/tbar[1]/btn[25]
    Sleep    1
    Clear Field Text    wnd[0]/usr/tabsTAB_SM59/tabpTECH/ssubSUB_SM59:SAPLCRFC:0500/txtHOSTNAME
    Sleep    1
    Input Text    wnd[0]/usr/tabsTAB_SM59/tabpTECH/ssubSUB_SM59:SAPLCRFC:0500/txtHOSTNAME    ${symvar('Target_Host')} 
    Sleep    3
    Take Screenshot    002_SM59_11.jpg

    Click Element    wnd[0]/tbar[0]/btn[11]
    
    # Select Radio Button    wnd[0]/usr/tabsTAB_SM59/tabpTECH/ssubSUB_SM59:SAPLCRFC:0500/radRFCDISPLAZ-SAVEIP 
    # Sleep    1
    # Click Element    wnd[0]/tbar[0]/btn[11]
    # Sleep    1
    Click Element   wnd[1]/tbar[0]/btn[0]
    ${status}    Get Status Pane    wnd[0]/sbar/pane[0]
    Take Screenshot   002_SM59_12.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]


	Collapse Node	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
	Sleep	2

    Expand Node	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}2
	Sleep	2


    FOR    ${index_2}    IN RANGE    ${fld_1}    100
        
        ${status_2}    Run Keyword And Return Status    Double Click Sap Shell Item    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${index_2}    &Hierarchy
        IF    '${status_2}' == 'False'
            ${fld_2}    Set Variable    ${index_2}
            Exit For Loop
        END    
        
        Take Screenshot    002_SM59_2.1.${in_1}.jpg
        
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1

    END

    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}2
	Sleep	2

    Expand Node	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}3
	Sleep	2


    FOR    ${index_3}    IN RANGE    ${fld_2}    100
        
        ${status_3}    Run Keyword And Return Status    Double Click Sap Shell Item    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${index_3}    &Hierarchy
        IF    '${status_3}' == 'False'
            ${fld_3}    Set Variable    ${index_3}
            Exit For Loop
        END    
        
        Take Screenshot    002_SM59_3.1.${in_1}.jpg
        
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1

    END

    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}3
	Sleep	2

    Expand Node	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}4
	Sleep	2


    FOR    ${index_4}    IN RANGE    ${fld_3}    100
        
        ${status_4}    Run Keyword And Return Status    Double Click Sap Shell Item    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${index_4}    &Hierarchy
        IF    '${status_4}' == 'False'
            ${fld_4}    Set Variable    ${index_4}
            Exit For Loop
        END    
        
        Take Screenshot    002_SM59_4.1.${index}.jpg
        # Click Element    wnd[0]/tbar[1]/btn[27]
        Send Vkey    27
        Sleep    1
        Take Screenshot    002_SM59_4.2.${index}.jpg
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1

    END

    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}4
	Sleep	2

    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}5
    Sleep    2

    FOR    ${index_5}    IN RANGE    ${fld_4}    100
        
        ${status_5}    Run Keyword And Return Status    Double Click Sap Shell Item    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${index_5}    &Hierarchy
        IF    '${status_5}' == 'False'
            ${fld_5}    Set Variable    ${index_5}
            Exit For Loop
        END    
        
        Take Screenshot    002_SM59_5.1.${index}.jpg
        # Click Element    wnd[0]/tbar[1]/btn[27]
        Send Vkey    27
        Sleep    1
        Take Screenshot    002_SM59_5.2.${index}.jpg
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1

    END

    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}5
	Sleep	2

    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}6
    Sleep    2

    FOR    ${index_6}    IN RANGE    ${fld_5}    100
        
        ${status_6}    Run Keyword And Return Status    Double Click Sap Shell Item    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${index_6}    &Hierarchy
        IF    '${status_6}' == 'False'
            ${fld_6}    Set Variable    ${index_6}
            Exit For Loop
        END    
        
        Take Screenshot    002_SM59_6.1.${index}.jpg
        Click Element    wnd[0]/tbar[1]/btn[13]
        # Send Vkey    27
        
        Sleep    1
        Take Screenshot    002_SM59_6.2.${index}.jpg
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1

    END

    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}6
	Sleep	2

    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}7
    Sleep    2

    FOR    ${index_7}    IN RANGE    ${fld_6}    100
        
        ${status_7}    Run Keyword And Return Status    Double Click Sap Shell Item    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${index_7}    &Hierarchy
        IF    '${status_7}' == 'False'
            ${fld_7}    Set Variable    ${index_7}
            Exit For Loop
        END    
        
        Take Screenshot    002_SM59_7.1.${index}.jpg
        # Click Element    wnd[0]/tbar[1]/btn[27]
        Send Vkey    27
        Sleep    1
        Take Screenshot    002_SM59_7.2.${index}.jpg
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1

    END
    
    # Click Element    wnd[0]/tbar[0]/btn[11]
    # Sleep    1
    
    # Click Element   wnd[1]/tbar[0]/btn[0]
    # ${status}    Get Status Pane    wnd[0]/sbar/pane[0]
    # Take Screenshot   002_SM59_12.jpg
    # Click Element   wnd[0]/tbar[0]/btn[3]

    
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')} 
    Sleep    2
    
    

    















