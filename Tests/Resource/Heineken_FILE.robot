*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py

*** Variables ***

${TREE_PATH}    wnd[0]/usr/tblSAPL0SFNTCTRL_V_FILENACI
*** Keywords ***
System Logon
    Start Process     ${symvar('Heineken_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('Heineken_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Heineken_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Heineken_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}            
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{DL1_PASSWORD}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
 
FILE
    Run Transaction    /NFILE
	Sleep	2
    Take Screenshot    012_FILE_01.jpg
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
    Take Screenshot   012_File_02.JPG  
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}

System logout
    Run Transaction    /nex    
    
