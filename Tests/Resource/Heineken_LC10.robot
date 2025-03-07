*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py
*** Variables ***

${TREE_PATH}    wnd[0]/usr
*** Keywords ***
System Logon
    Start Process     ${symvar('Heineken_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Heineken_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Heineken_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Heineken_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Heineken_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{'Heineken_User_Password'}
    Send Vkey    0
    Multiple Logon Handling   wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
 
LC10
    Run Transaction    LC10
	Sleep	2
    Take Screenshot    LC10.jpg01
    	Close Window	wnd[1]
	Sleep	2
	Expand Node	wnd[0]/shellcont[1]/shell/shellcont[1]/shell	${SPACE*8}100
	Sleep	2
	Select Top Node	wnd[0]/shellcont[1]/shell/shellcont[1]/shell	${SPACE*8}100
	Sleep	2
	Select Item	wnd[0]/shellcont[1]/shell/shellcont[1]/shell	${SPACE*8}101	Task
	Sleep	2
	Ensure Visible Horizontal Item	wnd[0]/shellcont[1]/shell/shellcont[1]/shell	${SPACE*8}101	Task
	Sleep	2
	Doubleclick Element	wnd[0]/shellcont[1]/shell/shellcont[1]/shell	${SPACE*8}101	Task
	Sleep	2
    # Send Vkey    82    
   
    ${counter}=    Set Variable    20
    FOR    ${index}    IN RANGE    ${counter}
        ${scroll}    Scroll    wnd[0]/usr      ${counter}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    LC10_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 10
        Sleep    1
    END
    
System logout
    Run Transaction    /nex 
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}  