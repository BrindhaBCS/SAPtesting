*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
Library    ExcelLibrary
Library    String
Library    Collections
Library    DateTime
*** Variables ***
${Excel_file_path}    ${symvar('Excel_Name')}
${Excel_Sheet}    ${symvar('Sheet_Name')}

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('DTA_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('DTA_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('DTA_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('DTA_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{DTA_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
SM37_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B17
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E17
    IF  '${Tcode}' != 'SM37'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        Input Text    element_id=wnd[0]/usr/txtBTCH2170-JOBNAME    text=*
        Sleep    0.5
        Input Text    element_id=wnd[0]/usr/txtBTCH2170-USERNAME    text=*
        Sleep    0.5
        Unselect Checkbox    element_id=wnd[0]/usr/chkBTCH2170-PRELIM
        Unselect Checkbox    element_id=wnd[0]/usr/chkBTCH2170-SCHEDUL
        Unselect Checkbox    element_id=wnd[0]/usr/chkBTCH2170-READY
        Unselect Checkbox    element_id=wnd[0]/usr/chkBTCH2170-RUNNING
        Unselect Checkbox    element_id=wnd[0]/usr/chkBTCH2170-FINISHED
        ${FROM_DATE_SM37}=    Get Current Date    result_format=%d.%m.%Y    increment=-1 day
        Input Text    element_id=wnd[0]/usr/ctxtBTCH2170-FROM_DATE    text=${FROM_DATE_SM37}
        ${TO_DATE_SM37}    Get Current Date    result_format=%d.%m.%Y
        Input Text    element_id=wnd[0]/usr/ctxtBTCH2170-TO_DATE    text=${TO_DATE_SM37}
        Sleep    0.5
        Click Element    element_id=wnd[0]/tbar[1]/btn[8]
        ${No_maore_data}    Get Value    element_id=wnd[0]/sbar/pane[0]
        IF  '${No_maore_data}' == 'No job matches the selection criteria'
            Log To Console    No job matches the selection criteria 
        ELSE
            Click Element    element_id=wnd[0]/mbar/menu[5]/menu[5]/menu[2]/menu[2]
            Sleep    0.5
            Click Element    element_id=wnd[1]/tbar[0]/btn[0]
            Delete Specific File    C:\\tmp\\SM37.txt
            Clear Field Text    wnd[1]/usr/ctxtDY_PATH
            Input Text    element_id=wnd[1]/usr/ctxtDY_PATH    text=C:\\tmp\\
            Clear Field Text    wnd[1]/usr/ctxtDY_FILENAME
            Input Text    element_id=wnd[1]/usr/ctxtDY_FILENAME    text=SM37.txt
            Click Element    wnd[1]/tbar[0]/btn[0]
            Sleep    2
            ${one}    Extract Job Sm37    file_path=C:\\tmp\\SM37.txt
            ${one_two}    Remove Duplicates    ${one}
            ${one_two_t}    Convert To String    item=${one_two}
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E17    value=${one_two_t}
        END
    END