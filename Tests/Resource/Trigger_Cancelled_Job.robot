*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    SAP_Tcode_Library
 
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    # Sleep    5
    Connect To Session
    Open Connection    ${symvar('connection')}
    # Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('sap_client')}
    # Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('sap_user')}
    # Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    # Sleep   5
   
System Logout
    Run Transaction   /nex

Trigger cancelled job
    Run Transaction    /nsm37
    Input Text    wnd[0]/usr/txtBTCH2170-JOBNAME    ${EMPTY}
    Input Text    wnd[0]/usr/txtBTCH2170-JOBNAME    ${symvar('job_name')}
    Input Text    wnd[0]/usr/txtBTCH2170-USERNAME    ${EMPTY}
    Input Text    wnd[0]/usr/txtBTCH2170-USERNAME    ${symvar('job_user_name')}
    
    ${value}    Get Value    wnd[0]/usr/chkBTCH2170-PRELIM
    # Log To Console    ${value}
    IF    '${value}' == 'checked'
        Unselect Checkbox    wnd[0]/usr/chkBTCH2170-PRELIM        
    END

    ${value1}    Get Value    wnd[0]/usr/chkBTCH2170-SCHEDUL
    # Log To Console    ${value1}
    IF    '${value1}' == 'checked'
        Unselect Checkbox    wnd[0]/usr/chkBTCH2170-SCHEDUL        
    END

    ${value2}    Get Value    wnd[0]/usr/chkBTCH2170-READY
    # Log To Console    ${value2}
    IF    '${value2}' == 'checked'
        Unselect Checkbox    wnd[0]/usr/chkBTCH2170-READY        
    END

    ${value3}    Get Value    wnd[0]/usr/chkBTCH2170-RUNNING
    # Log To Console    ${value3}
    IF    '${value3}' == 'checked'
        Unselect Checkbox    wnd[0]/usr/chkBTCH2170-RUNNING       
    END

    ${value}    Get Value    wnd[0]/usr/chkBTCH2170-FINISHED
    # Log To Console    ${value}
    IF    '${value}' == 'checked'
        Unselect Checkbox    wnd[0]/usr/chkBTCH2170-FINISHED        
    END

    ${value}    Get Value    wnd[0]/usr/chkBTCH2170-ABORTED
    # Log To Console    ${value}
    IF    '${value}' == 'checked'
        Select Checkbox    wnd[0]/usr/chkBTCH2170-ABORTED        
    END

    Input Text    wnd[0]/usr/ctxtBTCH2170-FROM_DATE    ${EMPTY}
    # Sleep    5
    Click Element    wnd[0]/tbar[1]/btn[8]
    # Sleep    5
    Spam Search And Select Label    wnd[0]/usr    ${symvar('cancelled_job')}
    # Sleep    5
    Click Element    wnd[0]/mbar/menu[0]/menu[13]
    # Sleep    5
    Click Element    wnd[1]/tbar[0]/btn[0]
    # Sleep    5
    Window Handling    wnd[2]    Warning    wnd[2]/tbar[0]/btn[0]
    # Sleep    5
    ${log}    Get Value    wnd[0]/sbar/pane[0]
    Log To Console    ${log}
    Click Element    wnd[0]/tbar[0]/btn[3]
    # Sleep    5
    Select Checkbox    wnd[0]/usr/chkBTCH2170-PRELIM
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-SCHEDUL
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-READY
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-RUNNING
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-FINISHED
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-ABORTED
    # Sleep    5
    Click Element    wnd[0]/tbar[1]/btn[8]
    # Sleep    5
    Spam Search And Select Label    wnd[0]/usr    ${symvar('cancelled_job')}
    Click Element    wnd[0]/mbar/menu[0]/menu[2]
    Click Element    wnd[0]/tbar[1]/btn[5]
    Click Element    wnd[1]/usr/btnSOFORT_PUSH
    Click Element    wnd[1]/tbar[0]/btn[11]
    
