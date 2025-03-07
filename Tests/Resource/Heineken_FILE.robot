*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py

*** Variables ***

${TREE_PATH}    wnd[0]/usr/tblSAPL0SFNTCTRL_V_FILENACI
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
 
FILE
    Run Transaction    /NFILE
	Sleep	2
    Take Screenshot    FILE.jpg01
    Click Element	wnd[1]/tbar[0]/btn[0]
    Sleep    2
    TRY
    Click Element    wnd[1]/usr/btnBUTTON_1
    EXCEPT
    Log    No Locked Data Popup Found
    END
    Doubleclick Element	wnd[0]/shellcont/shell	03	Column1
	Sleep	2
    ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    140
        ${scroll}    Scroll    ${TREE_PATH}    ${index}  
    END
    Set Focus	wnd[0]/usr/tblSAPL0SFNTCTRL_V_FILENACI/txtV_FILENACI-FILEINTERN[0,3]
	Sleep	2
	Set Caret Position	wnd[0]/usr/tblSAPL0SFNTCTRL_V_FILENACI/txtV_FILENACI-FILEINTERN[0,3]	4
	Sleep	2
	Send Vkey	2
	Sleep	2
    Take Screenshot   File.JPG02  


System logout
    Run Transaction    /nex    
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}
