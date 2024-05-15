*** Settings ***
Library    Process
Library    SAP_Tocde_Library_one.py
Library    OperatingSystem
# Library    ../../Symphony/Lib/site-packages/SeleniumLibrary/__init__.py
Resource    ../Web/Support_Web.robot
 
*** Variables ***    
${start_date}    01.02.2024
${end_date}    29.02.2024
${start_date_Req6}    01.04.2023
${end_date_Req6}    01.04.2024
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
${Results_Directory_Path}    C:\\Users\\BCS268\\Documents\\Results
${Req_Result1_Filename}      SAP_Profiles.xls
${Req_Result2_Filename}      User_Accounts.xls
${Req_Result3_Filename}      Users_By_Complex_Selection.xls
${Req_Result10_Filename}      SE16_Users.xls 
${Req_Result5_Filename}       Licensed_Users.xls
${Req_Result5_noid_Filename}  Users_with_no_license.xls
${Req_Result6_Filename}       SAP_Support_Users.xls
${Req_Result7_Filename}       Batch_Job_Users.xlsx
${Req_Result7_usernames_Filename}    Req7_users_filter.xlsx
${Req7_usernames_path}        C:\\SAP_Robot\\SAPtesting
${Req7_usernames_textfile}    output_req7.txt
${Req_Result8_Filename}       Transportstraat_Users.xls
${Req_Result9_Filename}       Table_Authorization_Group_Users.xls
${Req_Result9_2_Filename}     Table_Authorization_Group_Users2.xls

${Req9_input}    "#*"

${directory}    C://SAP_Robot//SAPtesting//Output//pabot_results//0
${file_loc}      C://Users//BCS268//Documents//Results//Batch_Job_Users.xlsx
${images_directory}    C://SAP_Robot//SAPtesting//Output//pabot_results//0//



*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    #Input Password   wnd[0]/usr/pwdRSYST-BCODE    %('User_Password')
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Sleep    10

Executing Monthly compliance report
    #Run the Tcode SUIM
    Maximize Window
    Run Transaction     SUIM
    #Enter into the Change document for Users
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    1
    #Select the Roles/Profiles Tab
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB2
    Sleep    1
    # Key in s* under Profile name
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB2/ssub%_SUBSCREEN_TAB:RSUSR100N:1200/ctxtF_PROF-LOW    s*
    Send Vkey    0
    # Select the Check box Profiles
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB2/ssub%_SUBSCREEN_TAB:RSUSR100N:1200/chkPROF
    #Key in the dates
    Input Text    wnd[0]/usr/ctxtFDATE    ${start_date}
    Input Text    wnd[0]/usr/ctxtTDATE    ${end_date}
    Take Screenshot    req1_output.jpg
    Sleep    3
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result1_Filename}
    Sleep    1
    # Generate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 1 completed
    
    ########### MCR Requirement 1 Completed #######################

    #Requirement 2 to find the  (non)personal user accounts
    #Go back to the previous window
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    #Select the checkbox User created
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkUSER_CRT
    Take Screenshot    req2_output.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    req2_output2.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result2_Filename}
    # Generate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 2 completed
    
    ########### MCR Requirement 2 Completed #######################
    # Go back to the previous window and start the Requirement 6
    Click Element    wnd[0]/tbar[0]/btn[3]

    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkUSER_CRT
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkPASS
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkSECU
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkUSER_DEL
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkTYPE
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkALOCK_S
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkALOCK_D
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkFLOCK_S
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkFLOCK_D
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkTVAL
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkACCNT
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkLICENSE
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkREFUS
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkGROUP
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkADDRS
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkALIAS
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkSNC
    Sleep    2
    Input Text    wnd[0]/usr/ctxtFDATE    ${start_date_Req6}
    Input Text    wnd[0]/usr/ctxtTDATE    ${end_date_Req6}
    Take Screenshot    Req6_input.jpg
    Sleep    3
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    3
    Take Screenshot    Req6_output.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result6_Filename}
    Sleep    1
    # Generate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 6 completed

    ########### MCR Requirement 6 Completed #######################

 
    #To start with the Requirement 3, go back to the previous window
    Click Element    wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    #Requirement 3 - Access to "transport taking into production"
    # Enter into the Users by complex Selection Criteria
    Click Node Link     ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id5}
    Sleep    1
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
    Take Screenshot    req3_output.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    req3_output2.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[2]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result3_Filename}
    # Genertate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 3 completed
        
    ########### MCR Requirement 3 Completed #######################

    #Starting with Requirement 7
    Click Element    wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    #To start with the Requirement 7, go back to the previous window
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
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result7_Filename}
    # Generate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 7 completed
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
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result7_usernames_Filename}
    Sleep     1
    # Generate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Log to console    Req 7 completed

    ########### MCR Requirement 7 Completed #######################

    #To start with the Requirement 8, go back to the previous window
    Click Element    wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Node Link     ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id5}
    Sleep    1
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_TCODE
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    STMS
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    S_CTS_ADMI
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    TABL
    Send Vkey    0
    Take Screenshot    req8_output.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    req8_output2.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[2]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result8_Filename}
    # Genertate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 8 completed

    ########### MCR Requirement 8 Completed #######################

    #To start with the Requirement 9, go back to the previous window
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
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result9_Filename}
    # Genertate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 9 part1 completed
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
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result9_2_Filename}
    # Genertate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 9 part1 completed
    #To start with the Requirement 10, go back to the previous window
    Click Element    wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1

    ########### MCR Requirement 9 Completed #######################

    #Requirement 10 - SE16 Table Maintenance Management
    # Enter into the Users by complex Selection Criteria
    #Click Node Link     ${symvar('tree_id')}    ${symvar('link_id6')}    ${symvar('link_id7')}    ${symvar('link_id8')}     ${symvar('link_id9')}    ${symvar('link_id10')}
    Click Node Link     ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id5}
    Sleep    1
    #Go to the Authorizations Tab
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Sleep    1
    #Enter Authorization object 1 as S_TCODE
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_TCODE
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    SE16
    Send Vkey    0
    Sleep    1
    Take Screenshot    req10_output.jpg
    Sleep    2
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Take Screenshot    req10_output2.jpg
    #Send the output to the Local file
    Click Element    wnd[0]/mbar/menu[0]/menu[3]/menu[2]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result10_Filename}
    # Genertate the Results file.
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Log To Console    Requirement 10 completed

    ########### MCR Requirement 10 Completed #######################
    
    #Start the Requirement 5, Go back previous 3 windows.
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1

    #Run the Tcode Usmm
    #Maximize Window
    Run Transaction     Usmm
    Send Vkey    0
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[18]
    Sleep    3
    Take Screenshot    Req5_output.jpg
    
    Sap Tcode Usmm Reg5
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    #Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result5_Filename}
    # Generate the Results file.
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Select Table Column    wnd[0]/usr/cntlSLIM_USER_CONTAINER/shellcont/shell    LICENSE_TYPE
    Sleep    1
    Click Toolbar Button    wnd[0]/usr/cntlSLIM_USER_CONTAINER/shellcont/shell    &MB_FILTER
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[2]
    Sleep    1
    Click Element    wnd[2]/tbar[0]/btn[0]
    Set Focus     wnd[1]/usr/ssub%_SUBSCREEN_FREESEL:SAPLSSEL:1105/ctxt%%DYN001-HIGH
    Send Vkey    4
    Sleep    1
    Set Focus    wnd[2]/usr/lbl[1,7]
 
    Sleep    1
    Click Element    wnd[2]/tbar[0]/btn[0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Take Screenshot    Req5_NoID.jpg
    Sap Tcode Usmm Reg5
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    #Select to generate it
    Click Element    wnd[1]/tbar[0]/btn[0]
    #Sleep    1
    #Enter the Directory path and Results file name to store the Results.
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result5_noid_Filename}
    # Generate the Results file.
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]

    ########### MCR Requirement 5 Completed #######################

    ########### Generation of the Report ##########################
    Image Resize    ${directory}
Report
    Mcr Report Pdf    ${images_directory}





    




    









    




    
