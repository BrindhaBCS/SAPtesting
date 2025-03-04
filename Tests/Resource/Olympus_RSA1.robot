*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py

*** Keywords ***
RSA1
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
    Take Screenshot    026_RSA01_01.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1 
    Run Transaction    /nRSA1
    Sleep    1
    Take Screenshot    026_RSA01_02.jpg
    Click Element	wnd[1]/usr/btnG_BUTTON_1
	Sleep	2
    # Select Node Link     wnd[0]/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell    ${SPACE*10}4    1
    Sleep    3
    Take Screenshot    026_RSA01_03.jpg

    FOR    ${index}    IN RANGE    3    10 
        Select Node Link     wnd[0]/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell    ${SPACE*10}${index}    1
        Sleep    3 
        Take Screenshot    026_RSA01_04_${index}.jpg
        Sleep    1
    END
    Run Transaction    /nex
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}