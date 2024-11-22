*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem

*** Variables ***
${Req_Result5_Filename}       Licensed_Users.xls
${Req_Result5_noid_Filename}  Users_with_no_license.xls
${Replace}    wnd[1]/tbar[0]/btn[11]
${FILE1}        C:\\tmp\\Licensed_User.xlsx
${SHEET1}       Licensed_Users
${COL1_INDEX}   2
${SKIPROWS}     6
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\Licensed.xlsx
${HEADER1}      Licensed Users
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

license checking
    Maximize Window
    Run Transaction     Usmm
    Send Vkey    0
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[18]
    Sleep    3
    Take Screenshot    Usmm1.jpg
    
    Sap Tcode Usmm Reg5
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    #Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result5_Filename}
    # Generate the Results file.
    Sleep    1
    Click Element    ${Replace}
    Sleep    1
    # Take Screenshot    Usmm2.jpg
    Select Table Column    wnd[0]/usr/cntlSLIM_USER_CONTAINER/shellcont/shell    LICENSE_TYPE
    Sleep    1
    Click Toolbar Button    wnd[0]/usr/cntlSLIM_USER_CONTAINER/shellcont/shell    &MB_FILTER
    Sleep    1
    Take Screenshot    Usmm2.jpg
    Click Element    wnd[1]/tbar[0]/btn[2]
    Sleep    1
    Click Element    wnd[2]/tbar[0]/btn[0]
    Set Focus     wnd[1]/usr/ssub%_SUBSCREEN_FREESEL:SAPLSSEL:1105/ctxt%%DYN001-HIGH
    Send Vkey    4
    Sleep    1
    Take Screenshot    Usmm3.jpg
    Set Focus    wnd[2]/usr/lbl[1,7]
 
    Sleep    1
    Click Element    wnd[2]/tbar[0]/btn[0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Take Screenshot    Usmm4.jpg
    Sap Tcode Usmm Reg5
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    #Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result5_noid_Filename}
    # Generate the Results file.
    Sleep    1
    Take Screenshot    Usmm5.jpg
    Click Element    ${Replace}
    Sleep    1
    Delete Specific File    ${FILE1}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\Licensed_Users.xls    xlsx_file=C:\\tmp\\Licensed_User.xlsx
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
    Delete Specific File    file_path=C:\\tmp\\Licensed_Users.xls
    Log To Console    license_checking Completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1