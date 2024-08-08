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
    Open Connection    ${symvar('job_connection')}
    # Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('job_client')}
    # Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('job_user')}
    # Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    # Sleep   5
   
System Logout
    Run Transaction   /nex

Display cancelled job Details
    Run Transaction    /nsm37
    Input Text    wnd[0]/usr/txtBTCH2170-JOBNAME    ${EMPTY}
    Input Text    wnd[0]/usr/txtBTCH2170-JOBNAME    ${symvar('job_name')}
    Input Text    wnd[0]/usr/txtBTCH2170-USERNAME    ${EMPTY}
    Input Text    wnd[0]/usr/txtBTCH2170-USERNAME    ${symvar('job_user_name')}
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-PRELIM        
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-SCHEDUL        
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-READY        
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-RUNNING       
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-FINISHED        
    Select Checkbox    wnd[0]/usr/chkBTCH2170-ABORTED 
           
    Input Text    wnd[0]/usr/ctxtBTCH2170-FROM_DATE    ${EMPTY}
    Click Element    wnd[0]/tbar[1]/btn[8]
    Click Element    wnd[0]/mbar/menu[3]/menu[0]/menu[1]
    Select Radio Button    wnd[1]/usr/radRB_OTHERS
    Set Key Value    wnd[1]/usr/cmbG_LISTBOX    10
    Click Element    wnd[1]/tbar[0]/btn[0]

    Input Text      wnd[1]/usr/ctxtDY_PATH  ${EMPTY}
    Input Text  wnd[1]/usr/ctxtDY_PATH      ${symvar('job_filepath')}
    Input Text  wnd[1]/usr/ctxtDY_FILENAME    ${symvar('job_filename')}
    Click Element   wnd[1]/tbar[0]/btn[0]
