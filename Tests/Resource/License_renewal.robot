*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
 
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    # Sleep    5
    Connect To Session
    Open Connection    ${symvar('license_connection')}
    # Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('license_client')}
    # Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('license_user')}
    # Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    # Sleep   5
   
System Logout
    Run Transaction   /nex

Get License Data
    Run Transaction    /nslicense
    Sleep    2
    ${hardware_key}    Get Value    wnd[0]/usr/txtCUSTKEY
    Sleep    2
    ${installation_no}    Get Value    wnd[0]/usr/txtINSTNR
    Log To Console    **gbStart**hardware_key**splitKeyValue**${hardware_key}**gbEnd**
    Log To Console    **gbStart**installation_no**splitKeyValue**${installation_no}**gbEnd**

License Renewal
    Run Transaction    /nslicense
    Click Element    wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/btnINSTALL
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('uploading_path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${symvar('License_file')}
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[0]
