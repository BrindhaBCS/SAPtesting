*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem

*** Variables ***
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id1}     02${SPACE*2}1${SPACE*6}2
${link_id2}     01${SPACE*2}1${SPACE*6}1
${link_id3}    03${SPACE*2}2${SPACE*6}7
${link_id4}    04${SPACE*2}2${SPACE*6}8
${link_id5}    1
${AUTHORIZATION TAB}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
${AUTHORIZATION OBJECT 1}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1
${AUTHORIZATION OBJECT 2}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2
${AUTHORIZATION OBJECT 3}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ3
${TCD VALUE}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101
${value_01}    01
${value_02}    02
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Replace}    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[11]
${Execute}    wnd[0]/tbar[1]/btn[8]
${BACK}    wnd[0]/tbar[0]/btn[3]
${Req_Result13_Filename}    Authorization Profiles.xls
${FILE1}        C:\\tmp\\Authorization Profiles.xlsx
${SHEET1}       Authorization Profiles
${COL1_INDEX}   2
${SKIPROWS}     15
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\Authorization Profiles.xlsx
${HEADER1}      Authorization Profiles
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users
${html_report_MCR}    C:\\tmp\\Html_report_mcr.txt

# ${se16_filepath}      c:\\tmp\\SE16_Users.xlsx
# ${se16_filepath_cleaned}      c:\\tmp\\SE16_Users_Cleaned.xlsx
# ${table_auth_filepath}      c:\\tmp\\Table_Authorization_Group_Users.xlsx
# ${table_auth_filepath_cleaned}      c:\\tmp\\Table_Authorization_Group_Users_Cleaned.xlsx
# ${control_SAP_filepath}      c:\\tmp\\Control SAP standard users.xlsx
# ${control_SAP_filepath_cleaned}      c:\\tmp\\Control SAP standard users_Cleaned.xlsx
# ${auth_profiles_filepath}      c:\\tmp\\Authorization Profiles.xlsx
# ${auth_profiles_filepath_cleaned}      c:\\tmp\\Authorization Profiles_Cleaned.xlsx
# ${exempted_users_file}      c:\\tmp\\MCR_Exempted_Users.xlsx
# ${output_file}      c:\\tmp\\Extra_Users_List.xlsx
# ${output_word_file_path}    c:\\tmp\\MCR_OUTPUT_DEMO.docx




*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
System Logout
    Run Transaction   /nex
   

Authorization profiles maintenance
    Maximize Window
    ${message}    Run Keyword And Return Status    Run Transaction     SUIM
    IF    '${message}' == 'True' 
        Sleep    2
        Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
        Sleep    2
        Take Screenshot    profiles_maintenance1.jpg
        Click Element    ${AUTHORIZATION TAB}
        Sleep    2
        Input Text    ${AUTHORIZATION OBJECT 1}    S_USER_AGR
        Sleep    2
        Send Vkey    0
        Sleep    2
        Clear Field Text    ${TCD VALUE} 
        Sleep    2
        Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL111    ${value_01}
        Sleep    2
        Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL112    ${value_02}
        Sleep    2
        Input Text    ${AUTHORIZATION OBJECT 2}    S_USER_PRO
        Sleep    2
        Send Vkey    0
        Sleep    2
        Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${value_01}
        Sleep    2
        Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL212    ${value_02}
        Sleep    2
        Clear Field Text    ${AUTHORIZATION OBJECT 3}
        Sleep    2
        Clear Field Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL301
        Sleep    2
        Clear Field Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL311
        Sleep    2
        Take Screenshot    profiles_maintenance2.jpg
        Click Element    ${Execute}
        Sleep    5
        Take Screenshot    profiles_maintenance3.jpg
        Click Element    ${local file}
        Sleep    2
        Select Radio Button    ${Text with tabs Button}
        Click Element    ${local file continue}
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH     ${symvar('MCR_Results_Directory_Path')}
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result13_Filename}
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    1
        Click Element    ${BACK}
        Sleep    1
        Delete Specific File    ${FILE1}
        Sleep    1
        Convert Xls To Xlsx    xls_file=C:\\tmp\\Authorization Profiles.xls    xlsx_file=C:\\tmp\\Authorization Profiles.xlsx
        Sleep    1
        Create Directory    C:\\tmp\\Authorised Users List
        Sleep    1
        # Extract Columns    file1=${FILE1}   sheet1=${SHEET1}    col1_index=${COL1_INDEX}    file2=${FILE2}    sheet2=${SHEET2}    col2_index=${COL2_INDEX}   output_file=${OUTPUT_FILE}
        #Extract Columns    ${FILE1}    ${SHEET1}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
        #Sleep    1
        #Compare Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
        #Sleep    1
        #${i}    Matched Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
        #Log To Console    ${i}
        Delete Specific File    file_path=C:\\tmp\\Authorization Profiles.xls
        Remove Rows Before Start Row    file_path=C:\\tmp\\Authorization Profiles.xlsx    sheet_name=Authorization Profiles    start_row=15
        Sleep    1
        # Compare And Include Query Data    security_file=C:\\tmp\\SAP Security Users.xlsx    query_file=C:\\tmp\\Authorization Profiles.xlsx    output_file=C:\\TEMP\\Validate_SAuthorization_Profiles_Data.xlsx
        # Sleep    1
        #Compare And Add Query Data    security_file=C:\\tmp\\SAP Security Users.xlsx    query_file=C:\\tmp\\Authorization Profiles.xlsx    existing_file=C:\\TEMP\\Validate_Data.xlsx    new_sheet_name=Authorization_Profiles
        Sleep    1
        ${AA}    Set Variable    PASS:Authorization profiles maintenance Passed.
        Log To Console    ${AA}
        Append To File    path=${html_report_MCR}    content=${AA}\n
    ELSE
        ${AA}    Set Variable    WARN:Authorization profiles maintenance Failed.
        Log To Console    ${AA}
        Append To File    path=${html_report_MCR}    content=${AA}\n
        
    END
    Log To Console    **gbStart**MCR_Result**splitKeyValue**${html_report_MCR}**gbEnd**
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1

    # Files Clean Username    ${se16_filepath}    ${se16_filepath_cleaned}
    # Files Clean Username    ${table_auth_filepath}    ${table_auth_filepath_cleaned}    
    # Files Clean User    ${control_SAP_filepath}    ${control_SAP_filepath_cleaned}    
    # Files Clean Username    ${auth_profiles_filepath}    ${auth_profiles_filepath_cleaned}
    # Generate Extra Users List    ${se16_filepath_cleaned}    ${table_auth_filepath_cleaned}    ${control_SAP_filepath_cleaned}    ${auth_profiles_filepath_cleaned}    ${exempted_users_file}    ${output_file} 
    # Sleep    2
    # Generate Word    ${symvar('MCR_excel_directory')}    ${symvar('MCR_Resized_Images_directory')}    ${output_word_file_path}
    # Sleep    2
    