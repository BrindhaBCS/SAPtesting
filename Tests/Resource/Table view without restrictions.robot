*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem

 
*** Variables ***    
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id1}     02${SPACE*2}1${SPACE*5}10
${link_id2}     01${SPACE*2}1${SPACE*6}1
${link_id3}    03${SPACE*2}2${SPACE*6}1
${link_id4}    04${SPACE*2}2${SPACE*6}2
${link_id5}    1
${link_id6}    02${SPACE*2}1${SPACE*6}2
${link_id7}    01${SPACE*2}1${SPACE*6}1
${link_id8}    03${SPACE*2}3${SPACE*6}7
${link_id8_Req8}    03${SPACE*2}2${SPACE*6}7
${link_id9}    04${SPACE*2}3${SPACE*6}8
${link_id9_Req8}    04${SPACE*2}2${SPACE*6}8
#${link_id10}    1

${Req_Result9_Filename}       Table_Authorization_Group_Users.xls
${Req_Result9_2_Filename}     Table_Authorization_Group_Users2.xls
${Req9_input}    "#*"
${Replace}    wnd[1]/tbar[0]/btn[11]
${FILE1}        C:\\tmp\\Table_Authorization_Group_Users.xlsx
${SHEET1}       Table_Authorization_Group_Users 
${COL1_INDEX}   2
${SKIPROWS}     15
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}    C:\\tmp\\Authorised Users List\\Table_Authorization_Group_Users.xlsx
${HEADER1}      Table_Authorization_Group_Users
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users
${FILE3}        C:\\tmp\\Table_Authorization_Group_Users2.xlsx
# ${SHEET3}       Table_Authorization_Group_Users2
${OUTPUT_FILE1}    C:\\tmp\\Authorised Users List\\Table_Authorization_Group_Users2.xlsx





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

Table view without restrictions
    #Run the Tcode SUIM
    Maximize Window
    Run Transaction     SUIM
    Sleep    1
    #Enter into the Change document for Users
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Node Link     ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id5}
    Sleep    1
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_TCODE
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    SE16*
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL102    SE17*
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    S_TABU_DIS
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    ${Req9_input}
    Send Vkey    0
    Take Screenshot    req9_output.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    req9_output2.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[2]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result9_Filename}
    # Genertate the Results file.
    Click Element    ${Replace}
    Sleep    1
    Delete Specific File    ${FILE1}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\Table_Authorization_Group_Users.xls    xlsx_file=C:\\tmp\\Table_Authorization_Group_Users.xlsx
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
    Delete Specific File    file_path=C:\\tmp\\Table_Authorization_Group_Users.xls
    Log To Console    Table view without restrictions part1 completed
    #To start with the Requirement 9 part 2, go back to the previous window
    Click Element    wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    #To start with the Requirement 9, go back to the previous window
    Click Node Link     ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id5}
    Sleep    1
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_TCODE
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    SE16*
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL102    SE17*
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    S_TABU_NAM
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    ${Req9_input}
    Send Vkey    0
    Take Screenshot    req9_output3.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    req9_output4.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[2]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result9_2_Filename}
    # Genertate the Results file.
    Click Element    ${Replace}
    Sleep    1
    Delete Specific File    ${FILE3}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\Table_Authorization_Group_Users2.xls    xlsx_file=C:\\tmp\\Table_Authorization_Group_Users2.xlsx
    Sleep    1
    Create Directory    C:\\tmp\\Authorised Users List
    Sleep    1
    # Extract Columns    file1=${FILE1}   sheet1=${SHEET1}    col1_index=${COL1_INDEX}    file2=${FILE2}    sheet2=${SHEET2}    col2_index=${COL2_INDEX}   output_file=${OUTPUT_FILE}
    Extract Columns    ${FILE3}    ${SHEET1}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE1}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Compare Columns    ${OUTPUT_FILE1}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
    Sleep    1
    Matched Columns    ${OUTPUT_FILE1}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\Table_Authorization_Group_Users2.xls
    Log To Console    Table view without restrictions part2 completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    1
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1