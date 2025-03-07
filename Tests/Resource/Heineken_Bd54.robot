*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py
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

Bd54_Tcode
    Run Transaction    /nBd54
    Sleep    2
    Take Screenshot    009_Bd54_01.jpg
    Send Vkey    0
    Click Element    wnd[1]/usr/btnBUTTON_1
	Sleep	2
    ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    5
        ${scroll}    Scroll    wnd[0]/usr/tblSAPLBD41TCTRL_V_TBDLS      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    009_Bd54_02_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
     END
    
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}

System logout
    Run Transaction    /nex