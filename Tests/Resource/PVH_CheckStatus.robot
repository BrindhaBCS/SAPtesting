*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
Library    OperatingSystem
Library    String
Library    DateTime
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('PVH_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('PVH_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('PVH_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('PVH_User_Password')}  
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{PVH_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction     /nex

CheckStatus
    Click Element    wnd[0]/mbar/menu[4]/menu[11]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[17]
    Sleep    1
    Take Screenshot    Chkst.jpg
    Sleep    1
    Click Element    wnd[2]/tbar[0]/btn[12]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[12]
    Sleep    1
    Copy Images    ${OUTPUT_DIR}    ${symvar('PVH_Target_Dir')}