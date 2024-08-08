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
    Open Connection    ${symvar('lock_connection')}
    # Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('lock_client')}
    # Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('lock_user')}
    # Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    # Sleep   5
   
System Logout
    Run Transaction   /nex

Display Lock Details
    Run Transaction    /nsm12
    Input Text    wnd[0]/usr/txtSEQG3-GUNAME    ${EMPTY}
    Input Text    wnd[0]/usr/txtSEQG3-GUNAME    *
    Click Element    wnd[0]/tbar[1]/btn[8]
    Click Element    wnd[0]/mbar/menu[0]/menu[2]/menu[1]
    Select Radio Button    wnd[1]/usr/radRB_OTHERS
    Set Key Value    wnd[1]/usr/cmbG_LISTBOX    10
    Click Element    wnd[1]/tbar[0]/btn[0]
    Input Text      wnd[1]/usr/ctxtDY_PATH  ${EMPTY}
    Input Text  wnd[1]/usr/ctxtDY_PATH      ${symvar('lock_entry_filepath')}
    Input Text  wnd[1]/usr/ctxtDY_FILENAME    ${symvar('lock_entry_filename')}
    Click Element   wnd[1]/tbar[0]/btn[0]
