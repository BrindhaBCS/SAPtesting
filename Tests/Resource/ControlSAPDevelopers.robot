*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem


*** Variables ***
${Execute}    wnd[0]/tbar[1]/btn[8]
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Replace}    wnd[1]/tbar[0]/btn[11]
${Req_ResultSE16_Filename}    Control SAP developers.xls
${FILE1}        C:\\tmp\\Control SAP developers.xlsx
${SHEET1}       Control SAP developers
${COL1_INDEX}   1
${SKIPROWS}     4
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\Control SAP Developers.xlsx
${HEADER1}      SE16
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users
${BACK}    wnd[0]/tbar[0]/btn[3]
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
   

Control SAP developers
    Maximize Window
    ${message}    Run Keyword And Return Status    Run Transaction     /nSE16
    IF    '${message}' == 'True' 
    
        Sleep    2
        Take Screenshot    CSD1.jpg
        Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    DEVACCESS
        Sleep    1
        Take Screenshot    CSD2.jpg
        Send Vkey    0 
        Sleep    1
        Take Screenshot    CSD3.jpg
        Click Element    ${Execute}
        Sleep    1
        Take Screenshot    CSD4.jpg
        Click Element    wnd[0]/mbar/menu[1]/menu[5]
        Sleep    1
        Take Screenshot    CSD5.jpg
        Click Element    ${local file}
        Sleep    2
        Select Radio Button    ${Text with tabs Button}
        Click Element    ${local file continue}
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
        Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_ResultSE16_Filename}
        Sleep    1
        Click Element    ${Replace}
        Sleep    1
        Click Element    ${BACK}
        Sleep    1
        Delete Specific File    ${FILE1}
        Sleep    1
        Convert Xls To Xlsx    xls_file=C:\\tmp\\Control SAP developers.xls    xlsx_file=C:\\tmp\\Control SAP developers.xlsx
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
        Delete Specific File    C:\\tmp\\Control SAP developers.xls
        Sleep    1
        Remove Rows Before Start Row    file_path=C:\\tmp\\Control SAP developers.xlsx    sheet_name=Control SAP developers    start_row=3
        Sleep    1
        compare    first_excel_path=C:\\tmp\\Control SAP developers.xlsx    second_excel_path=C:\\tmp\\SAP Security Users.xlsx    output_excel_path=C:\\TEMP\\Validate_Control SAP developers.xlsx   first_sheet_name=Control SAP developers    second_sheet_name=SAP SECURITY
        Sleep    1
        ${AA}    Set Variable    PASS:Control SAP developers Passed.
        Log To Console    ${AA}
        Append To File    path=${html_report_MCR}    content=${AA}\n
    ELSE
        ${AA}    Set Variable    WARN:Control SAP developers Failed.
        Log To Console    ${AA}
        Append To File    path=${html_report_MCR}    content=${AA}\n
    END
    Sleep    1
    Generate Report Html    input_file=${html_report_MCR}    output_file=C:\\tmp\\Html_report_mcr.html    report_name=MIC REPORT
    Sleep    2
        
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1
    Generate Word    ${symvar('MCR_excel_directory')}    ${symvar('MCR_Resized_Images_directory')}    C:\\tmp\\MCR_OUTPT
    Sleep    2


