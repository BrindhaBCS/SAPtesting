*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    ExcelLibrary
 
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
${Req_Result7_Filename}       Batch_Job_Users.xls
${Req_Result7_usernames_Filename}    Req7_users_filter.xlsx
${Req7_usernames_path}        C:\\tmp
${Req7_usernames_textfile}    output_req7.txt
${file_loc}      C:\\tmp\\Batch_Job_Users.xls
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
    Sleep    10

Access Batch Job Management
    #Run the Tcode SUIM
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
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_BTCH_ADM
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    Y
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    S_BTCH_JOB
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    DELE
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL202    RELE
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ3    S_TCODE
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL301    SM36*
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL302    SM37*
    Take Screenshot    req7_output.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    req7_output2.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep    1
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1

    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result7_Filename}
    # Generate the Results file.
    Click Element    ${Replace}
    Sleep    1
    Log To Console    Access Batch Job Management completed
    Req7 usernames extract    ${file_loc}
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Element    wnd[0]/usr/btn%_USER_%_APP_%-VALU_PUSH
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[23]
    Input Text    wnd[2]/usr/ctxtDY_PATH    ${Req7_usernames_path}
    Input Text    wnd[2]/usr/ctxtDY_FILENAME    ${Req7_usernames_textfile}
    Click Element    wnd[2]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep    1
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    3
    # Close All Excel Documents
    # Close Open Excel    ${file_loc}
    # Sleep    2
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result7_usernames_Filename}
    Sleep     1
    # Generate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Log to console    Req 7 completed

    # ########### MCR Requirement 7 Completed #######################
