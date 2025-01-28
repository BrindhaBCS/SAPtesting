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
${Authorization Object 1 VALUE}    S_TCODE
${TCD VALUE}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101
${Object 3}    \#*
${AUTHORIZATION OBJECT 3}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ3
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Replace}    wnd[1]/tbar[0]/btn[11]
${Execute}    wnd[0]/tbar[1]/btn[8]
${BACK}    wnd[0]/tbar[0]/btn[3]
${Req_Result12_Filename}    START_PROGRAMS.xls
${FILE1}        C:\\tmp\\START_PROGRAMS.xlsx
${SHEET1}       START_PROGRAMS
${COL1_INDEX}   2
${SKIPROWS}     18
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\START_PROGRAMS.xlsx
${HEADER1}      START_PROGRAMS
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users
${html_report_MCR}    C:\\tmp\\Html_report_mcr.txt



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
   

Check to start Programs immediately
    Maximize Window
    ${message}    Run Keyword And Return Status    Run Transaction     SUIM
    IF    '${message}' == 'True' 
        Sleep    2
        Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
        Sleep    2
        Take Screenshot    start_Programs1.jpg
        Click Element    ${AUTHORIZATION TAB}
        Sleep    2
        Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
        Sleep    2
        Send Vkey    0
        Sleep    2
        Input Text    ${TCD VALUE}    S*38
        Sleep    2  
        Input Text    ${AUTHORIZATION OBJECT 3}    S_PROGRAM
        Sleep    2
        Send Vkey    0
        Sleep    2
        Scroll    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004    position=150
        Sleep    2
        Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL301    ${Object 3}
        Sleep    2
        Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL311    SUBMIT
        Sleep    2
        Take Screenshot    start_Programs2.jpg
        Click Element    ${Execute}
        Sleep    5
        Take Screenshot    start_Programs3.jpg
        Click Element    ${local file}
        Sleep    2
        Select Radio Button    ${Text with tabs Button}
        Click Element    ${local file continue}
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
        Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result12_Filename}
        Sleep    1
        Click Element    ${Replace}
        Sleep    1
        Click Element    ${BACK}
        Sleep    1
        Delete Specific File    ${FILE1}
        Sleep    1
        Convert Xls To Xlsx    xls_file=C:\\tmp\\START_PROGRAMS.xls    xlsx_file=C:\\tmp\\START_PROGRAMS.xlsx
        Sleep    1
        Create Directory    C:\\tmp\\Authorised Users List
        Sleep    1
        #Extract Columns    ${FILE1}    ${SHEET1}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
        #Sleep    1
        #Compare Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
        #Sleep    1
        #${i}    Matched Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
        #Log To Console    ${i}
        Delete Specific File    file_path=C:\\tmp\\START_PROGRAMS.xls
        Remove Rows Before Start Row    file_path=C:\\tmp\\START_PROGRAMS.xlsx    sheet_name=START_PROGRAMS    start_row=17
        Sleep    1
        # Compare And Include Query Data    security_file=C:\\tmp\\SAP Security Users.xlsx    query_file=C:\\tmp\\START_PROGRAMS.xlsx    output_file=C:\\TEMP\\Validate_START_PROGRAMS_Data.xlsx
        # Sleep    1
        Compare And Add Query Data    security_file=C:\\tmp\\SAP Security Users.xlsx    query_file=C:\\tmp\\START_PROGRAMS.xlsx    existing_file=C:\\TEMP\\Validate_Data.xlsx    new_sheet_name=Start_Programs
        Sleep    1
        ${AA}    Set Variable    PASS:Check to start Programs immediately Passed.
        Log To Console    ${AA}
        Append To File    path=${html_report_MCR}    content=${AA}\n
    ELSE
        ${AA}    Set Variable    WARN:Check to start Programs immediately Failed.
        Log To Console    ${AA}
        Append To File    path=${html_report_MCR}    content=${AA}\n
        
    END
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1
    