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
   

SM13_ABLN
    Run Transaction	    SM13
	Sleep	2
    Take Screenshot    008_sm13_0.jpg
    ${update_system}    Get Value    wnd[0]/usr/txtINFOLINE-INFOTEXT
    IF  "Update is active" in "${update_system}"
        Log    System is activate
    ELSE
        Log    System is Inactivate        
    END
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    008_sm13_1.jpg

    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('Screenshot_directory')}
    Sleep    1