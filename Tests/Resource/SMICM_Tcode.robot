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
SMICM_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B16
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E16
    IF  '${Tcode}' != 'SMICM'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        Click Element    element_id=wnd[0]/mbar/menu[2]/menu[6]
        Sleep    0.2
        ${COLUMN}    Evaluate   5
        WHILE    ${COLUMN} <=7
            ${Ring}    Get Value    element_id=wnd[0]/usr/lbl[106,${COLUMN}]
            Set Focus    wnd[0]/usr/lbl[106,${COLUMN}]
            Sleep    0.2
            Click Element    element_id=wnd[0]/tbar[1]/btn[29]
            ${value}    Get Value    element_id=wnd[1]/usr/ssub%_SUBSCREEN_FREESEL:SAPLSSEL:1105/ctxt%%DYN001-LOW
            IF  '${value}' == '@01@'
                Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D16   value=1
                Click Element   element_id=wnd[1]/tbar[0]/btn[0]
                ${result}    Set Variable    ${Ring}: Active
                Log To Console    message=${result}
                ${Iron}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E16 
                ${single} =    Replace String    ${Iron}    \n    <space>  
                IF  '${single}' == ''
                    Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E16    value=${result}
                ELSE
                    ${res}    Set Variable    ${Iron}\n${result}
                    Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E16    value=${res}
                END
            ELSE
                Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E16    value=No Active Request is there.
                Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D16   value=3
            END
            ${COLUMN}    Evaluate    ${COLUMN} + 1
        END
    END