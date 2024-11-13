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
${TCD VALUE}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101
${AUTHORIZATION TAB}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
${AUTHORIZATION OBJECT 1}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1
${AUTHORIZATION OBJECT 2}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2
${AUTHORIZATION OBJECT 3}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ3
${Object 3}    \#*
${Authorization Object 1 VALUE}    S_TCODE
${value_02}    02
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Replace}    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[11]
${Execute}    wnd[0]/tbar[1]/btn[8]
${BACK}    wnd[0]/tbar[0]/btn[3]
${Req_Result17_Filename}     Control Access.xls
${Req_Result17.1_Filename}    Control Access1.xls
${FILE1}        C:\\tmp\\Control Access.xlsx
${SHEET1}       Control Access 
${COL1_INDEX}   2
${SKIPROWS}     17
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\Control Access.xlsx
${HEADER1}      Control Access
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users
${FILE3}        C:\\tmp\\Control Access1.xlsx
${SHEET3}       Control Access1
${OUTPUT_FILE1}  C:\\tmp\\Authorised Users List\\Control Access1.xlsx







*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    2


Control access to customizing
    Maximize Window
    Run Transaction     SUIM
    Sleep    2
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    2
    Take Screenshot    Control_access1.jpg
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}   SPRO
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_TABU_DIS
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    ${Object 3}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${value_02}
    Sleep    2
    Take Screenshot    Control_access2.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_access3.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result17_Filename}
    Sleep    1
    Click Element    ${Replace}
    Sleep    1
    Delete Specific File    ${FILE1}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\Control Access.xls    xlsx_file=C:\\tmp\\Control Access.xlsx
    Sleep    1
    Create Directory    C:\\tmp\\Authorised Users List
    Sleep    1
    # Extract Columns    file1=${FILE1}   sheet1=${SHEET1}    col1_index=${COL1_INDEX}    file2=${FILE2}    sheet2=${SHEET2}    col2_index=${COL2_INDEX}   output_file=${OUTPUT_FILE}
    Extract Columns    ${FILE1}    ${SHEET1}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Compare Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
    Sleep    1
    Matched Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\Control Access.xls
    Log To Console    Control Access Completed

    Click Element    ${BACK}
    Sleep    1
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Clear Field Text    ${AUTHORIZATION OBJECT 1}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Clear Field Text    ${AUTHORIZATION OBJECT 2}    
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}   SPRO
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_TABU_NAM
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    ${value_02}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${Object 3}
    Sleep    2
    Take Screenshot    Control_access4.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_access5.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result17.1_Filename}
    Sleep    1
    Click Element    ${Replace}
    Sleep    1
    Click Element    ${BACK}
    Sleep    1
    Delete Specific File    ${FILE3}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\Control Access1.xls    xlsx_file=C:\\tmp\\Control Access1.xlsx
    Sleep    1
    Create Directory    C:\\tmp\\Authorised Users List
    Sleep    1
    # Extract Columns    file1=${FILE1}   sheet1=${SHEET1}    col1_index=${COL1_INDEX}    file2=${FILE2}    sheet2=${SHEET2}    col2_index=${COL2_INDEX}   output_file=${OUTPUT_FILE}
    Extract Columns    ${FILE3}    ${SHEET3}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE1}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Compare Columns    ${OUTPUT_FILE1}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
    Sleep    1
    Matched Columns    ${OUTPUT_FILE1}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\Control Access1.xls
    Log To Console    Control Access1 Completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1
    
   