
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
*** Variables ***
${TREE_PATH}    wnd[0]/usr  


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
    Multiple Logon Handling   wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
SE16
    Run Transaction     /nSE16
    Sleep    2
    Take Screenshot    SE16.jpg
    Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME    RSADMIN 
	Sleep	2
    Take Screenshot    RSADMIN.jpg
    Sleep    2
	Click Element	wnd[0]/tbar[1]/btn[7]
    Take Screenshot    RSADMIN.jpg
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
    Take Screenshot    RSADMIN.jpg
    ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    1    16    5   
        ${scroll}    Scroll    wnd[0]/usr      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    RSADMIN_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
     END
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME    RSADMINA
	Sleep	2
    Take Screenshot    RSADMINA1.jpg
    Sleep    2    
	Click Element	wnd[0]/tbar[1]/btn[7]
	Sleep	2
	${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    2
        ${scroll}    Scroll    wnd[0]/usr      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    RSADMINA_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
     END
	Click Element	wnd[0]/tbar[1]/btn[8]
	Take Screenshot    RSADMINA3.jpg
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME    RSPRECADMIN
    Sleep    2
	Click Element	wnd[0]/tbar[1]/btn[7]
	Click Element	wnd[0]/tbar[1]/btn[8]
	Take Screenshot    RSPRECADMIN.jpg
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME    RSPRECALCADMIN    
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[7]
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
	Take Screenshot    RSPRECALCADMIN1.jpg
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME    IWFND
    Take Screenshot    IWFND.jpg
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME    C_DFSYAL
    Take Screenshot    C_DFSYAL.jpg
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Run Transaction    /nex
	Sleep    2
	Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}