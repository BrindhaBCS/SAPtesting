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
    Open Connection    ${symvar('sap_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('user_name')} 
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('password')}       
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   5
    Take Screenshot     image_1.jpg

System Logout
    Run Transaction   /nex
    Sleep    2
    Take Screenshot     image_7.jpg

Assigning Roles to the User
        
    ${row_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_name2')}
    ${total_rows}=    Evaluate    ${row_count} + 1
    # Log To Console      Total row for sheet2 is :${total_rows}

    FOR     ${h}    IN RANGE    2       ${total_rows}
        Run Transaction    /nSU10
        Sleep    1
        Take Screenshot     image_2.jpg
        ${functional_area}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}    3
        # Log To Console      ${functional_area}
        
        IF      '${functional_area}' == 'Basis'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_basis')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_basis')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Select Checkbox   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/chkGS_NODE_REFUSER_X-REFUSER
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg
        
        ELSE IF      '${functional_area}' == 'Developer'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_developer')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_developer')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   5
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Select Checkbox   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/chkGS_NODE_REFUSER_X-REFUSER
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg

        ELSE IF      '${functional_area}' == 'Security'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_security')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_security')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Select Checkbox   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/chkGS_NODE_REFUSER_X-REFUSER
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg

        ELSE IF      '${functional_area}' == 'ABAP'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_ABAP')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_ABAP')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Select Checkbox   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/chkGS_NODE_REFUSER_X-REFUSER
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg

        ELSE IF      '${functional_area}' == 'Finance'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_finance')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_finance')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Select Checkbox   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/chkGS_NODE_REFUSER_X-REFUSER
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg
        END

    END


user_role_Remove
    ${row_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_name2')}
    ${total_rows}=    Evaluate    ${row_count} + 1
    # Log To Console      Total row for sheet2 is :${total_rows}

    FOR     ${h}    IN RANGE    2       ${total_rows}
        Run Transaction    /nSU10
        Sleep    1
        Take Screenshot     image_2.jpg
        ${functional_area}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}    3
        # Log To Console      ${functional_area}
        
        IF      '${functional_area}' == 'Basis'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_basis')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_basis')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Click Toolbar Button   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell       DEL_LINE
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg
        
        ELSE IF      '${functional_area}' == 'Developer'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_developer')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_developer')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Click Toolbar Button   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell       DEL_LINE
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg

        ELSE IF      '${functional_area}' == 'Security'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_security')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_security')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Click Toolbar Button   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell       DEL_LINE
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg

        ELSE IF      '${functional_area}' == 'ABAP'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_ABAP')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_ABAP')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Click Toolbar Button   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell       DEL_LINE
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg

        ELSE IF      '${functional_area}' == 'Finance'
            ${user_count}    Count Excel Rows     ${symvar('User_excel_path')}       ${symvar('sheet_finance')}
            ${rows}=    Evaluate    ${user_count} + 1
            Set Global Variable     ${rows}
            # Log To Console      Total row for sheet1 is: ${rows}

            FOR    ${i}    IN RANGE    2    ${rows}
                ${j}    Evaluate    ${i} - 2
                # Log To Console      ${symvar('sheet_name')}
                ${user_names}    Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_finance')}     ${i}    2
                Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
                Sleep   1
            END
            Take Screenshot     image_3.jpg
            Sleep    1

            Click Element    wnd[0]/tbar[1]/btn[18]
            Sleep    3
            Window Handling     wnd[1]     Log Display       wnd[1]/tbar[0]/btn[0]
            Sleep   1
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
            Sleep    1
            Take Screenshot     image_4.jpg

            ${col_count}      Count Excel Columns      ${symvar('User_excel_path')}    ${symvar('sheet_name2')}
            ${columns}=    Evaluate    ${col_count} + 1
            # Log To Console      Total no of columns are: ${columns}

            FOR     ${k}    IN RANGE    4       ${columns}
                ${l}=   Evaluate    ${k} - 4
                # Log To Console  ${l}
                ${y_role}   Read Excel Cell Value    ${symvar('User_excel_path')}      ${symvar('sheet_name2')}     ${h}        ${k}
                # Log To Console      Y_role is : ${y_role}
                Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${l}    AGR_NAME    ${y_role}
            END

            Take Screenshot     image_5.jpg
            Click Toolbar Button   wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell       DEL_LINE
            Sleep   1
            Click Element   wnd[0]/tbar[0]/btn[11]
            Sleep   1
            Take Screenshot     image_6.jpg
        END

    END

Excel sheet
    Open Excel Document    ${symvar('User_excel_path')}    1
    ${sheets}   Get List Sheet Names
    Log To Console      ${sheets}
    ${sheet}    Get Sheet    ${symvar('sheet_name')} 
    Log To Console      sheet contains:${sheet}
    ${value}    Read Excel Cell     4       2
    Log To Console      data is:${value}
    Sleep   2 
    ${data}    Read Excel Cell Value    ${symvar('User_excel_path')}     ${symvar('sheet_name')}     4       2
    Log To Console      data in the ${symvar('sheet_name')} is:${data} 

    # FOR    ${i}    IN RANGE    2    ${rows}
    #     ${j}    Evaluate    ${i} - 2
    #     # Log To Console      ${symvar('sheet_name')}
    #     ${user_names}    Read Excel    ${symvar('User_excel_path')}      Role_Assign     ${i}    2
    #     Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${j}]    ${user_names}
    #     Sleep   5
    # END  
    # ${data}    Read Excel Cell    ${rownum}    ${colnum}        
    # [Return]    ${data}
    Close Current Excel Document