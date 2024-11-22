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
${Req_ResultSE16_Filename}    SE16.xls
${FILE1}        C:\\tmp\\SE16.xlsx
${SHEET1}       SE16
${COL1_INDEX}   2
${SKIPROWS}     4
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\SE16.xlsx
${HEADER1}      SE16
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users
${BACK}    wnd[0]/tbar[0]/btn[3]

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

SE16
    Maximize Window
    Run Transaction     /nSE16
    Sleep    2
    Take Screenshot    CIU1.jpg
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    USR02
    Sleep    1
    Take Screenshot    CIU2.jpg
    Send Vkey    0 
    Sleep    1
    Take Screenshot    CIU3.jpg
    Click Element    ${Execute}
    Sleep    1
    Take Screenshot    CIU4.jpg
    Click Element    wnd[0]/mbar/menu[1]/menu[5]
    Sleep    1
    Take Screenshot    CIU5.jpg
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
    Convert Xls To Xlsx    xls_file=C:\\tmp\\SE16.xls    xlsx_file=C:\\tmp\\SE16.xlsx
    Sleep    1
    Create Directory    C:\\tmp\\Authorised Users List
    Sleep    1
    Extract Columns    ${FILE1}    ${SHEET1}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Compare Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
    Sleep    1
    ${i}    Matched Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Log To Console    ${i}
    Log To Console    Control Inactive Users Completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1




