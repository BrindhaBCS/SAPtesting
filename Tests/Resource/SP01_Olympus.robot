*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${Olympus_SAP_SERVER}    ${symvar('Olympus_SAP_SERVER')}
${Olympus_SAP_connection}    ${symvar('Olympus_SAP_connection')}
# ${Olympus_filename}    ${symvar('Olympus_filename')}
${TREE_PATH}    wnd[0]/usr/cntlEXT_COM/shellcont/shell   

*** Keywords ***
System Logon

    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
SP01  
    Run Transaction    /nSP01
    Sleep    1
    Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/txtS_RQOWNE-LOW	*
	Sleep	2
    Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/ctxtS_RQCLIE-LOW	*
	Sleep	2
    Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/ctxtS_RQCRED-LOW	${EMPTY}
	Sleep	2
	Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/ctxtS_RQCRED-HIGH	${EMPTY}
	Sleep	2
    Click Element	wnd[0]/mbar/menu[0]/menu[0]
	Sleep	2
    Take Screenshot    SP01.jpg
    Sleep    2
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2
	Sleep	2
    Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/txtS_PJOWNE-LOW	*
	Sleep	2
	Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/ctxtS_PJCRED-LOW	${EMPTY}
	Sleep	2
	Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/ctxtS_PJCRED-HIGH	${EMPTY}
	Sleep	2
	Input Text	wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/ctxtS_PJCLIE-LOW	*
	Sleep	2
	Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    2
    Take Screenshot    001_SP01.jpg
    # ${row_count}    Get Row Count    ${TREE_PATH}
    # Log    Total Row Count: ${row_count}
    # ${counter}=    Set Variable    1
    # FOR    ${i}    IN RANGE    0    ${row_count + 1}    24
    #     Log    Processing row ${i}
    #     ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
    #     Log To Console    Selected rows: ${selected_rows}
    #     Take Screenshot    SP01_${counter}.jpg
    #     ${counter}=    Evaluate    ${counter} + 1
    #     Sleep    1
    # END
	# Sleep	2
  
System Logout
    Run Transaction    /nex
    Sleep    1