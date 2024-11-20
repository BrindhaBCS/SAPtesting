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

${input_filepath}    ${symvar('MM_Cleaned_filepath')}//${MM_Filename}
${result_filepath}    ${symvar('MM_Cleaned_filepath')}//${symvar('MM_Cleaned_filename')}

${Plant}    1040
${Material}    laptop

*** Keywords ***
System Logon
    Start Process     ${symvar('MM_SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('MM_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MM_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MM_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MM_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MM_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex

Executing Material Availability
    Run Transaction    /nmb52
    Send Vkey    0
    Sleep    1
    #Input Text    wnd[0]/usr/ctxtMATNR-LOW    ${symvar('Material')}
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
    Input Text    wnd[1]/usr/ctxtDY_PATH   ${symvar('MM_Cleaned_filepath')}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${MM_Filename}
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    1
    Log To Console    mm1completed 
Result
    Log To Console    Material Availability Unresticted Data
    #Material Availability Description    ${input_filepath}    ${symvar('Material')}    ${result_filepath}
    # Material Availability    ${filepath}    ${result_filepath} 
    #${json}    Excel To Json    excel_file=C:\\tmp\\MM_Availability.xlsx    json_file=C:\\tmp\\Json\\MM_Availability.json
    #Sleep    0.5
    #Log To Console    **gbStart**copilot_Json**splitKeyValue**${json}**gbEnd**
    #Log to console    ${json}
    ${chart_json}    Generate Chart Data    file_path=C:\\tmp\\MM_MB52_Full_Desc_Details.xlsx 
    Sleep    0.5
    Log To Console    **gbStart**copilot_cpiechart_data_grouped**splitKeyValue**${chart_json}**gbEnd**
    ${chart_json_top10}    Generate Chart Data Top Ten Materials    file_path=C:\\tmp\\MM_MB52_Full_Desc_Details.xlsx 
    Sleep    0.5
    Log To Console    **gbStart**copilot_cpiechart_data_top10**splitKeyValue**${chart_json_top10}**gbEnd**
    #Log To Console    gbStart##copilot_cpiechart_data##splitKeyValue##{json.dumps(chart_data)}##gbEnd
    Log to console    ${chart_json_top10}
    Sleep    2
    #Delete Specific File    file_path=C:\\tmp\\Json\\MM_Availability.json
    #Delete Specific File    file_path=C:\\tmp\\MM_Availability.xlsx