*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[1]/shell
*** Keywords ***
SWU3
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
    Run Transaction    /nswu3
    Send Vkey    0
    Sleep    0.1
    Take Screenshot    olympus_swu3.jpg
    #Get the left panel value
    ${panel}    Get Value    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[1]/shell
    Take Screenshot    olympus_swu3_1.jpg
 
    Log To Console    ${panel}
    #To Press down, use 82.
    Send Vkey    82
    Take Screenshot    olympus_swu3_2.jpg
    Sleep    0.2
    # Run Transaction    /nSWU3
    # Sleep    1
    # Take Screenshot    SWU3.jpg
    # Select Top Node    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*10}1
	# Sleep	2
    # Expand Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*10}1
	# Sleep	2
    # Take Screenshot    SWU3.jpg01
    # Collapse Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*10}1
	# Sleep	2
    # Select Top Node    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*10}5
	# Sleep	2
    # Expand Node    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*10}5
	# Sleep	2
    # Take Screenshot    SWU3.jpg01
    # ${panel}    Get Value    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[1]/shell
    # Take Screenshot    olympus_swu3_1.jpg
    # Log To Console    ${panel}
    # #To Press down, use 82.
    # Send Vkey    92
    # Take Screenshot    olympus_swu3_2.jpg
    # Sleep    0.2
    

    # Collapse Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*10}5
	# Sleep	2
    # Select Top Node    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}17
	# Sleep	2
    # Expand Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}17
	# Sleep	2
    # Take Screenshot    SWU3.jpg01
    # #  ${counter}=    Set Variable    1
    # # FOR    ${index}    IN RANGE    10
    # #     ${scroll}    Scroll   wnd[0]/usr    ${index}
    # #     Log To Console    Selected rows: $${scroll}
    # #     Take Screenshot    ST06_${counter}.jpg
    # #     ${counter}=    Evaluate    ${counter} + 1
    # #     Sleep    1
    # # END
    # Collapse Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}17
	# Sleep	2
    # Select Top Node    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}22
	# Sleep	2
    # Expand Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}22
	# Sleep	2
    # Take Screenshot    SWU3.jpg01
    # #  ${counter}=    Set Variable    1
    # # FOR    ${index}    IN RANGE    10
    # #     ${scroll}    Scroll   wnd[0]/usr    ${index}
    # #     Log To Console    Selected rows: $${scroll}
    # #     Take Screenshot    ST06_${counter}.jpg
    # #     ${counter}=    Evaluate    ${counter} + 1
    # #     Sleep    1
    # # END
    # Collapse Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}22
	# Sleep	2
    # Select Top Node    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}29
	# Sleep	2
    # Expand Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}29
	# Sleep	2
    # Take Screenshot    SWU3.jpg01
    # Collapse Node	wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell	${SPACE*9}29
	# Sleep	2
    # Click Element	wnd[0]/tbar[0]/btn[3]




    
