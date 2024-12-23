*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
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
    Sleep    5
   

SM61_ABLN
    Run Transaction	    SM61
    Sleep    2
    Take Screenshot    004_SM61.jpg

    Click Element	wnd[0]/usr/tabsCONTROL_TAB/tabpTENV
	Sleep	2
    Take Screenshot    004_SM61_1.jpg

	Click Element	wnd[0]/usr/tabsCONTROL_TAB/tabpTENV/ssubSUB_OBJ:SAPLCOBJ:0140/btnEXECUTE_BUTTON
	Sleep	2
    Take Screenshot    004_SM61_2.jpg
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}   
    Sleep    2