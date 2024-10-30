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
SMQ1_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B20
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E20
    IF  '${Tcode}' != 'SMQ1'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        Input Text  wnd[0]/usr/txtCLIENT    *
        Sleep   0.5
        Input Text  wnd[0]/usr/txtQERROR    X
        Sleep   0.5
        Click Element   wnd[0]/tbar[1]/btn[8]
        Sleep   0.5
        ${check}    Run Keyword And Ignore Error    Get Value    wnd[0]/usr/lbl[2,6]
        ${check_value}    Set Variable    ${check[1]}
        Log    ${check_value}  
        IF  '${check_value}' == 'No queues with errors found'
            Log To Console    No queues with errors found
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E20    value=No queues with errors found
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D20    value=1
        ELSE 
            Click Element    wnd[0]/mbar/menu[4]/menu[5]/menu[2]/menu[1]
            Sleep    0.5
            Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[0,0]
            Sleep    0.5
            Click Element    wnd[1]/tbar[0]/btn[0]
            Sleep    0.5
            Delete Specific File    C:\\tmp\\SMQ1.txt
            Clear Field Text    wnd[1]/usr/ctxtDY_PATH
            Input Text    element_id=wnd[1]/usr/ctxtDY_PATH    text=C:\\tmp\\
            Clear Field Text    wnd[1]/usr/ctxtDY_FILENAME
            Input Text    element_id=wnd[1]/usr/ctxtDY_FILENAME    text=SMQ1.txt
            Click Element    wnd[1]/tbar[0]/btn[0]
            Sleep    0.5
            ${log}    Extract SmQ1    file_path=C:\\tmp\\SMQ1.txt
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E20    value=${log}
            Sleep    0.4
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D20    value=3
        END
    END
    Delete Specific File    file_path=C:\\tmp\\SMQ1.txt