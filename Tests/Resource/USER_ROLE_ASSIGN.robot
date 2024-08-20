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
    
Assigning Roles to the User
        
    ${row_count}    Count Excel Rows     ${symvar('Roles_excel_path')}       ${symvar('GetRoles_sheetname')}
    ${total_rows}=    Evaluate    ${row_count} + 1

    FOR     ${h}    IN RANGE    2       ${total_rows}
        ${m}    Evaluate    ${h} - 1
        Set Global Variable     ${m}
        Run Transaction    /nSU10
        Sleep    1
        Take Screenshot     ${m}_a_AssignRole.jpg
        ${functional_area}    Read Excel Cell Value    ${symvar('Roles_excel_path')}      ${symvar('GetRoles_sheetname')}     ${h}    3
        # Log To Console      ${functional_area}
        
        ${user_count}    Count Excel Rows     ${symvar('Roles_excel_path')}       ${functional_area}
        ${rows}=    Evaluate    ${user_count} + 1
        Set Global Variable     ${rows}
        # Log To Console      Total row for sheet1 is: ${rows}

        FOR    ${i}    IN RANGE    2    ${rows}
            ${j}    Evaluate    ${i} - 2
            # Log To Console      ${symvar('sheet_name')}
            ${user_names}    Read Excel Cell Value    ${symvar('Roles_excel_path')}      ${functional_area}     ${i}    2
            Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
            Sleep   1
        END
        Take Screenshot     ${m}_b_AssignRole.jpg
        Sleep    1

        Click Element    wnd[0]/tbar[1]/btn[18]
        Sleep    3
        Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
        Sleep   1
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
        Sleep    1
        Take Screenshot     ${m}_c_AssignRole.jpg

        ${col_count}      Count Excel Columns      ${symvar('Roles_excel_path')}    ${symvar('GetRoles_sheetname')}
        ${columns}=    Evaluate    ${col_count} + 1
        # Log To Console      Total no of columns are: ${columns}

        FOR     ${k}    IN RANGE    4       ${columns}
            ${l}=   Evaluate    ${k} - 4
            # Log To Console  ${l}
            ${y_role}   Read Excel Cell Value    ${symvar('Roles_excel_path')}      ${symvar('GetRoles_sheetname')}     ${h}        ${k}
            # Log To Console      Y_role is : ${y_role}
            Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
        END

        Take Screenshot     ${m}_d_AssignRole.jpg
        Select Checkbox   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/chkGS_NODE_REFUSER_X-REFUSER
        Sleep   1
        Click Element   wnd[0]/tbar[0]/btn[11]
        Sleep   1
        Take Screenshot     ${m}_e_AssignRole.jpg

    END


user_role_Remove
    ${row_count}    Count Excel Rows     ${symvar('Roles_excel_path')}       ${symvar('GetRoles_sheetname')}
    ${total_rows}=    Evaluate    ${row_count} + 1
    # Log To Console      Total row for sheet2 is :${total_rows}

    FOR     ${h}    IN RANGE    2       ${total_rows}
        ${m}    Evaluate    ${h} - 1
        Set Global Variable     ${m}

        Run Transaction    /nSU10
        Sleep    1
        Take Screenshot     ${m}_a_RemoveRole.jpg
        ${functional_area}    Read Excel Cell Value    ${symvar('Roles_excel_path')}      ${symvar('GetRoles_sheetname')}     ${h}    3
        # Log To Console      ${functional_area}
        
        ${user_count}    Count Excel Rows     ${symvar('Roles_excel_path')}       ${functional_area}
        ${rows}=    Evaluate    ${user_count} + 1
        Set Global Variable     ${rows}
        # Log To Console      Total row for sheet1 is: ${rows}

        FOR    ${i}    IN RANGE    2    ${rows}
            ${j}    Evaluate    ${i} - 2
            ${user_names}    Read Excel Cell Value    ${symvar('Roles_excel_path')}      ${functional_area}     ${i}    2
            Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
            Sleep   1
        END
        Take Screenshot     ${m}_b_RemoveRole.jpg
        Sleep    1

        Click Element    wnd[0]/tbar[1]/btn[18]
        Sleep    3
        Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
        Sleep   1
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
        Sleep    1
        Take Screenshot     ${m}_c_RemoveRole.jpg

        ${col_count}      Count Excel Columns      ${symvar('Roles_excel_path')}    ${symvar('GetRoles_sheetname')}
        ${columns}=    Evaluate    ${col_count} + 1
        # Log To Console      Total no of columns are: ${columns}

        FOR     ${k}    IN RANGE    4       ${columns}
            ${l}=   Evaluate    ${k} - 4
            # Log To Console  ${l}
            ${y_role}   Read Excel Cell Value    ${symvar('Roles_excel_path')}      ${symvar('GetRoles_sheetname')}     ${h}        ${k}
            # Log To Console      Y_role is : ${y_role}
            Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
        END

        Take Screenshot     ${m}_d_RemoveRole.jpg
        Click Toolbar Button   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell       DEL_LINE
        Sleep   1
        Click Element   wnd[0]/tbar[0]/btn[11]
        Sleep   1
        Take Screenshot     ${m}_e_RemoveRole.jpg
    END