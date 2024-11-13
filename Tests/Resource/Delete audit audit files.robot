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
${AUTHORIZATION OBJECT 1}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1
${AUTHORIZATION OBJECT 2}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2
${AUTHORIZATION TAB}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Replace}    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[11]
${Execute}    wnd[0]/tbar[1]/btn[8]
${BACK}    wnd[0]/tbar[0]/btn[3]
${Req_Result_Filename}    Deleteaudit.xls
${FILE1}        C:\\tmp\\Deleteaudit.xlsx
${SHEET1}       Deleteaudit
${COL1_INDEX}   2
${SKIPROWS}     17
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\Deleteaudit.xlsx
${HEADER1}      Deleteaudit
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users







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

Delete audit files
    Run Transaction    /nSE38
    Sleep    2
    Take Screenshot    Delete_audit1.jpg
    Input Text    wnd[0]/usr/ctxtRS38M-PROGRAMM    RSPARAM
    Sleep    2
    Take Screenshot    Delete_audit2.jpg
    Click Element    ${Execute}
    Sleep    2
    Take Screenshot    Delete_audit3.jpg
    Select Checkbox    wnd[0]/usr/chkALSOUSUB
    Sleep    2
    Take Screenshot    Delete_audit4.jpg
    Click Element    ${Execute}
    Sleep    2
    Take Screenshot    Delete_audit5.jpg
    ${path}    Get Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell    3    PAR_USER_WERT
    Log To Console    ${path}
    Sleep    2
    Run Transaction    /nSUIM
    Sleep    2
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    2
    Take Screenshot    Delete_audit6.jpg
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    S_ADMI_FCD
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    AUDA
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_DATASET
    Sleep    2
    Send Vkey    0
    Sleep    2
    Scroll    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004    position=150
    Sleep    2
    Input Text	wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211	06
    Sleep    2
    Input Text	wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL221	${path}
    Sleep    5
    Take Screenshot    Delete_audit7.jpg
    Click Element    ${Execute}
    Sleep    2
    Take Screenshot    Delete_audit8.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result_Filename}
    Sleep    1
    Click Element    ${Replace}
    Sleep    1
    Click Element    ${BACK}
    Sleep    1
    Delete Specific File    ${FILE1}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\Deleteaudit.xls   xlsx_file=C:\\tmp\\Deleteaudit.xlsx
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
    Delete Specific File    file_path=C:\\tmp\\Deleteaudit.xls
    Log To Console    Delete audit files completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1
    