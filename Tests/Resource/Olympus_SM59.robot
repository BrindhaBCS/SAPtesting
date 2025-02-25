*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]
${TREE_PATH_1}    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]    ${SPACE*10}4
${PATH}    ${SPACE*10}3
${element}    &Hierarchy

*** Keywords ***
SM59
    # Connect To Session
    # Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    # Sleep    1  
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Run Transaction    /nSM59
    Sleep    1
    SAP_Tcode_Library.Expand All Nodes  ${TREE_PATH}    5    10 
    Select Item	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*9}37	&Hierarchy
	Sleep	2
   
    # Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
	# Sleep	1
    # Take Screenshot    SM59.jpg01
    # Collapse Node	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
	# Sleep	2
    # Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}2
	# Sleep	1
    # Take Screenshot    SM59.jpg02
    # Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}2
	# Sleep	1
    # Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}3
	# Sleep	1
    # FOR    ${index}    IN RANGE    5    34
        
    #     ${status}    Run Keyword And Return Status    Double Click element    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}${index}	&Hierarchy
    #     Take Screenshot    SM59.JPG${index}
    #     Click Element	wnd[0]/tbar[0]/btn[3]
	#     Sleep	2
    #     IF    '${status}' == 'False'
    #         ${fld_1}    Set Variable    ${index}
    #         Exit For Loop
    #     END 
    # END   
    # Take Screenshot    SM59.jpg.03
    # Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}3
	# Sleep	1
    # Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}4
	# Sleep	1
    # Set Caret Position	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*9}46
    # # SAP_Tcode_Library.Expand All Nodes  ${TREE_PATH_1}
    # Take Screenshot    SM59.jpg04
    # # Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}4
	# # Sleep	1
    # Run Transaction    /nex 
