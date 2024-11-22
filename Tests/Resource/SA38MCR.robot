*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem


*** Variables ***
${file_name}    SA38.xls
${Replace}    wnd[1]/tbar[0]/btn[11]
${FILE1}        C:\\tmp\\SA38.xlsx
${SHEET1}       SA38
${COL1_INDEX}   2
${SKIPROWS}     4
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\SA38.xlsx
${HEADER1}      SA38
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
    Sleep    5
    Sleep    10
Transaction SA38
    Run Transaction    /nSA38
    Sleep    2
    Input Text    wnd[0]/usr/ctxtRS38M-PROGRAMM    RSPARAM
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Select Checkbox    wnd[0]/usr/chkALSOUSUB
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SA381.jpg
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[45]
    Sleep    1
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    click element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Input text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${file_name}
    Click Element    ${Replace}
    Sleep    5
    Take Screenshot    SA382.jpg
    Delete Specific File    ${FILE1}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\SA38.xls   xlsx_file=C:\\tmp\\SA38.xlsx
    Sleep    1
    Create Directory    C:\\tmp\\Authorised Users List
    Sleep    1
    # Extract Columns    file1=${FILE1}   sheet1=${SHEET1}    col1_index=${COL1_INDEX}    file2=${FILE2}    sheet2=${SHEET2}    col2_index=${COL2_INDEX}   output_file=${OUTPUT_FILE}
    Extract Columns    ${FILE1}    ${SHEET1}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Compare Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
    Sleep    1
    ${i}    Matched Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Log To Console    ${i}
    Delete Specific File    file_path=C:\\tmp\\SA38.xls
    Log To Console    SA38 Requirement completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1



