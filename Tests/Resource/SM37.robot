*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    multiple_selection.py
 
*** Variables ***
${download_path}    C:\\TEMP\\
${excel_path}    C:\\TEMP\\rental.xlsx
${excel_sheet}    Sheet1
 
*** Keywords ***
System Logon
    Start Process    ${symvar('GR_IR_SERVER')}
    Connect To Session
    Open Connection     ${symvar('GR_IR_Connection')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('GR_IR_Client')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('GR_IR_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('GR_IR_PASSWORD')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{GR_IR_PASSWORD}
    Send Vkey    0  
    ${logon_status}    Multiple logon Handling     wnd[1]   wnd[1]/usr/radMULTI_LOGON_OPT2
    IF    '${logon_status}' == "Multiple logon found. Please terminate all the logon & proceed"
        Log To Console    **gbStart**Sales_Document_status**splitKeyValue**${logon_status}**gbEnd**

    END
System Logout
    Run Transaction   /nex
    Sleep    5

Verfy the background jobs
    Run Transaction     /nsm37
    Select Checkbox     wnd[0]/usr/chkBTCH2170-PRELIM
    Click Element       wnd[0]/tbar[1]/btn[8]
    ${status}   Get Job Status      wnd[0]/usr      wnd[0]/usr/lbl[64
    Log To Console      ${status}
    IF  '${status}' == '[]'
        Log To Console      All The Jobs are in Finished Status
    ELSE
        Log To Console      Their is a job with the status ${status}

    END