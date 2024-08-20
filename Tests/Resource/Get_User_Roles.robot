*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library     ExcelLibrary
Library     openpyxl

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('Roles_connectionname')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Roles_clientid')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Roles_username')} 
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('password')}       
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   5

System Logout
    Run Transaction   /nex
    Sleep    2

Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document

Getting User Role
    Run Transaction     /nsu01
    Sleep   2
    Take Screenshot     01_get_Role.jpg
    ${user_count}    Count Excel Rows     ${symvar('Roles_excel_path')}       ${symvar('GetRoles_sheetname')}
    ${rows}=    Evaluate    ${user_count} + 1
    Set Global Variable     ${rows}
    # Log To Console      Total row for sheet3 is: ${rows}

    FOR    ${i}    IN RANGE    2    ${rows}
        Set Global Variable     ${i}
        ${j}    Evaluate    ${i} - 2
        ${user_names}    Read Excel Cell Value    ${symvar('Roles_excel_path')}      ${symvar('GetRoles_sheetname')}     ${i}    2
        Input Text  wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME      ${user_names}
        Sleep   1
        Click Element   wnd[0]/tbar[1]/btn[7]
        Sleep   3
        Click Element   wnd[0]/usr/tabsTABSTRIP1/tabpACTG
        Sleep   1
        ${length}   Get Row Count   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell
        # Log To Console      ${length}
        Take Screenshot     ${i}_Get_Role.jpg

        FOR     ${k}    IN RANGE    0   ${length}
            ${y_role}   Get Cell Value      wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell      ${k}    AGR_NAME
            # Log To Console  ${y_role}
            ${role}     Check Text Start With Y     ${y_role}
            # Log To Console      ${role}
            IF      '${role}' != 'None'
                ${h}    Evaluate    ${k} + 4
                Write Excel    ${symvar('Roles_excel_path')}      ${symvar('GetRoles_sheetname')}     ${i}    ${h}      ${role}
            END
        END
        Click Element   wnd[0]/tbar[0]/btn[3]
    END
