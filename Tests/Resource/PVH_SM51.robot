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

PVH_SM51
    Run Transaction    /nSM51
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[47]
    Sleep    1
    Take Screenshot    SM51.jpg
    Sleep    1
    ${kernel_number}    Get Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell    2    LINE
    ${SAP_Kernel}    Extract Numeric    ${kernel_number}
    Log To Console    **gbStart**SAP_Kernel_No**splitKeyValue**${SAP_Kernel}**gbEnd**
    ${patch_number}    Get Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell    8    LINE
    ${Kernel_Patch_No}    Extract Numeric    ${patch_number}
    Log To Console    **gbStart**Kernel_Patch_No**splitKeyValue**${Kernel_Patch_No}**gbEnd**
    Copy Images    ${OUTPUT_DIR}    ${symvar('PVH_Target_Dir')}