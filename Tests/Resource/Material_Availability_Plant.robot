*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
# Library    ../../Symphony/Lib/site-packages/SeleniumLibrary/__init__.py
Resource    ../Web/Support_Web.robot
 
*** Variables ***    

${Results_Directory_Path}   ${CURDIR}//Results//
${MM_Filename}      MM_Materials_MB52.xlsx

# ${filepath}    ${CURDIR}//Results//MM_Materials_MB52.xlsx
# ${result_filepath}    ${CURDIR}//Results//Cleaned_MM_Materials_MB52.xlsx

${input_filepath}    ${symvar('filepath')}//${MM_Filename}
${result_filepath}    ${symvar('filepath')}//${symvar('filename')}

${Plant}    1040
${Material}    2000000071

*** Keywords ***
System Logon
    Start Process     ${symvar('MM_SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('MM_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MM_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MM_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MM_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MM_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Sleep    10

Executing Material Availability
    Run Transaction    /nmb52
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/ctxtMATNR-LOW    ${symvar('Material')}
    Input Text    wnd[0]/usr/ctxtWERKS-LOW    ${symvar('Plant')}
    #Execute the requirement using F8
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    1
    Click Element    wnd[0]/mbar/menu[0]/menu[1]/menu[2]
    Sleep    1
    #Select the Local file format
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH   ${symvar('filepath')}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${MM_Filename}
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    1
    Log To Console    mm1completed 
Result
    Log To Console    Material Availability Unresticted Data
    Material Availability    ${input_filepath}    ${result_filepath}
    # Material Availability    ${filepath}    ${result_filepath}    
