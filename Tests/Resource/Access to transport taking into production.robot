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
${Req_Result3_Filename}      Users_By_Complex_Selection.xls
${FILE1}        C:\\tmp\\Users_By_Complex_Selection.xlsx
${SHEET1}       Users_By_Complex_Selection
${COL1_INDEX}   2
${SKIPROWS}     15
${FILE2}        C:\\tmp\\All users.XLSX
${SHEET2}       Sheet1
${COL2_INDEX}   0
${OUTPUT_FILE}  C:\\tmp\\Authorised Users List\\Users_By_Complex_Selection.xlsx
${HEADER1}      User Complex
${HEADER2}      All Users
${COMPARISON_COL_NAME}    Compared_Users
${Replace}    wnd[1]/tbar[0]/btn[11]





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
    # Sleep    10

Access to transport taking into production
    
    Maximize Window
    Run Transaction     SUIM
    Sleep    1
    #Enter into the Change document for Users
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    # Enter into the Users by complex Selection Criteria
    Click Node Link     ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id5}
    Sleep    1
    Take Screenshot    Access_transport1.jpg
    #Go to the Authorizations Tab
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Sleep    1
    #Enter Authorization object 1 as S_TCODE
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_TCODE
    Send Vkey    0
    #Enter the TCD value as STMS
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    STMS
    Send Vkey    0
    #Enter Authorization object 2 as S_CTS_ADMI
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    S_CTS_ADMI
    Send Vkey    0
    #Enter the TCD value as IMPA
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    IMPA
    Send Vkey    0
    Sleep    1
    Take Screenshot    Access_transport2.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    Access_transport3.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[2]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Take Screenshot    Access_transport4.jpg
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result3_Filename}
    Sleep    1
    # Genertate the Results file.
    Click Element    ${Replace}
    Sleep    1
    Delete Specific File    ${FILE1}
    Sleep    1
    Convert Xls To Xlsx    xls_file=C:\\tmp\\Users_By_Complex_Selection.xls    xlsx_file=C:\\tmp\\Users_By_Complex_Selection.xlsx
    Sleep    1
    Create Directory    C:\\tmp\\Authorised Users List
    Sleep    1
    Extract Columns    ${FILE1}    ${SHEET1}    ${COL1_INDEX}    ${SKIPROWS}    ${FILE2}    ${SHEET2}    ${COL2_INDEX}    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Compare Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}    ${COMPARISON_COL_NAME}
    Sleep    1
    Matched Columns    ${OUTPUT_FILE}    ${HEADER1}    ${HEADER2}
    Sleep    1
    Delete Specific File    file_path=C:\\tmp\\Users_By_Complex_Selection.xls
    Log To Console    Requirement Access to transport taking into production completed
Generate report
   Image Resize    ${symvar('MCR_directory')}
    Sleep    2
    Copy Images    ${symvar('MCR_directory')}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1
        
    
    
    