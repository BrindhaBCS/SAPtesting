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
SP01_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B19
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E19
    IF  '${Tcode}' != 'SP01'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        Click Element    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2
        Sleep    0.5
        Clear Field Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/txtS_PJOWNE-LOW
        Input Text    element_id=wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/txtS_PJOWNE-LOW    text=*
        Clear Field Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/ctxtS_PJCLIE-LOW
        Input Text    element_id=wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/ctxtS_PJCLIE-LOW    text=*
        ${FROM_DATE_SP01}=    Get Current Date    result_format=%d.%m.%Y    increment=-2 day
        Input Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/ctxtS_PJCRED-LOW    ${FROM_DATE_SP01}
        ${TO_DATE_SP01}=    Get Current Date    result_format=%d.%m.%Y
        Input Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR2/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0120/ctxtS_PJCRED-HIGH    ${TO_DATE_SP01}
        Sleep    0.3
        Send Vkey    vkey_id=8
        Sleep    0.3
        Click Element    element_id=wnd[0]/mbar/menu[5]/menu[5]/menu[2]/menu[2]
        Sleep    0.2
        Click Element    element_id=wnd[1]/tbar[0]/btn[0]
        Delete Specific File    C:\\tmp\\SP01.txt
        Clear Field Text    wnd[1]/usr/ctxtDY_PATH
        Input Text    element_id=wnd[1]/usr/ctxtDY_PATH    text=C:\\tmp\\
        Clear Field Text    wnd[1]/usr/ctxtDY_FILENAME
        Input Text    element_id=wnd[1]/usr/ctxtDY_FILENAME    text=SP01.txt
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    0.8
        ${res}    Result Output Request Sp01   file_path=C:\\tmp\\SP01.txt
        IF    '${res}' == 'List does not contain any data'
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D19   value=1
        ELSE
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D19   value=3
        END
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E19    value=${res}
        Click Element    element_id=wnd[0]/tbar[0]/btn[3]
        Click Element    element_id=wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1
        Clear Field Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/txtS_RQOWNE-LOW
        Input Text    element_id=wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/txtS_RQOWNE-LOW    text=*
        Clear Field Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/ctxtS_RQCLIE-LOW
        Input Text    element_id=wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/ctxtS_RQCLIE-LOW    text=*
        Input Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/ctxtS_RQCRED-LOW    ${FROM_DATE_SP01}
        Input Text    wnd[0]/usr/tabsTABSTRIP_BL1/tabpSCR1/ssub%_SUBSCREEN_BL1:RSPOSP01NR:0100/ctxtS_RQCRED-HIGH    ${TO_DATE_SP01}
        Sleep    0.3
        Click Element    element_id=wnd[0]/tbar[1]/btn[8]
        Run Keyword And Ignore Error    Click Element    element_id=wnd[1]/usr/btnSEL2
        Sleep    0.2
        Run Keyword And Ignore Error    Send Vkey    vkey_id=8
        Sleep    0.3
        Click Element    element_id=wnd[0]/mbar/menu[5]/menu[5]/menu[2]/menu[2]
        Sleep    0.2
        Click Element    element_id=wnd[1]/tbar[0]/btn[0]
        Delete Specific File    C:\\tmp\\SP01_Two.txt
        Clear Field Text    wnd[1]/usr/ctxtDY_PATH
        Input Text    element_id=wnd[1]/usr/ctxtDY_PATH    text=C:\\tmp\\
        Clear Field Text    wnd[1]/usr/ctxtDY_FILENAME
        Input Text    element_id=wnd[1]/usr/ctxtDY_FILENAME    text=SP01_Two.txt
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    0.8
        ${resq}    Result Spool Request Sp01    file_path=C:\\tmp\\SP01_Two.txt
        ${current_data}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E19
        ${new}    Set Variable    ${current_data}\n${resq}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E19    value=${new}
        ${resq_cleaned}    Arrange Single Line Sentence    multi_line_text=${resq}
        IF    '${resq_cleaned}' == 'List does not contain any data'
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D19   value=1
        ELSE
            Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D19   value=3
        END
    END
    Delete Specific File    file_path=C:\\tmp\\SP01_Two.txt
    Delete Specific File    file_path=C:\\tmp\\SP01.txt