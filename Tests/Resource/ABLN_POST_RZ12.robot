*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    String
Library    Merger.py

*** Variables ***
${EXCEL_PATH_PRE}    C:\\TEMP\\ABB.xlsx
${EXCEL_PATH_POST}    C:\\TEMP\\ABB_Post.xlsx
${Sheet}    Sheet1

*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABB_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
 
   
System Logout
    Run Transaction   /nex
    # Sleep    2

RZ12
    Run Transaction    /nRZ12
    Sleep    1
    Take Screenshot    000_RZ12.jpg
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
Delete Logon Group
    ${Row count}    Get Total Row    ${EXCEL_PATH_PRE}    ${Sheet}
    FOR    ${Row_Index}    IN RANGE    2    ${Row count + 1}
    ${A}=    Read Value From Excel    ${EXCEL_PATH_PRE}    ${Sheet}    A${Row_Index}
    Sleep    1
    Focus On Particular Text    ${A}    wnd[0]/usr
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[2]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[6]
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    1
    END
    
Select Table Data
    Click Element    wnd[0]/mbar/menu[4]/menu[5]/menu[2]/menu[2]
    Sleep    1
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Delete Specific File    ${EXCEL_PATH_POST}
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    ABB_Post.xlsx
    Click Element    wnd[1]/tbar[0]/btn[20]
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\TEMP
    Click Element    wnd[1]/tbar[0]/btn[0]
    ${EXCEL_PATH_POST}    Set Variable    C:\\TEMP\\ABB_Post.xlsx
    Clean Excel Sheet    ${EXCEL_PATH_POST}    ${Sheet}
    # Sleep    1
    ${A}    Compare Excel And Return Column    file1_path=${EXCEL_PATH_PRE}    sheet1_name=${Sheet}    file2_path=${EXCEL_PATH_POST}    sheet2_name=${Sheet}
    ${B}    Get Length    ${A}
    IF  '${B}' != '0'
    ${i}    Set Variable    1
        FOR    ${index}    IN RANGE    0    ${B}
            ${Value}    Set Variable    ${A}[${index}]
            Log To Console    ${Value}
            ${Detail value}    Search Text In Excel    file_path=${EXCEL_PATH_PRE}    search_text=${Value}
            Log To Console    ${Detail value}
            Run Transaction    /nRZ12
            Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
            Click Element    wnd[0]/tbar[1]/btn[8]
            Input Text    wnd[1]/usr/ctxtRZLLITAB-CLASSNAME    ${Detail value}[0]
            Input Text    wnd[1]/usr/ctxtRZLLITAB-APPLSERVER    ${Detail value}[1]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-USE_QUOTAS    ${Detail value}[2]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_QUEUE    ${Detail value}[3]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_LOGIN    ${Detail value}[4]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_OWN_LG    ${Detail value}[5]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_OWN_WP    ${Detail value}[6]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_COMM    ${Detail value}[7]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_WAIT_T    ${Detail value}[8]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_OPEN_TASKS    ${Detail value}[9]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_NORMAL_QUOTA    ${Detail value}[10]
            Input Text    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_LOW_QUOTA    ${Detail value}[11]
            # Take Screenshot    000_RZ12_${i}.jpg
            ${i}    Evaluate    ${i} + 1
            Click Element    wnd[1]/tbar[0]/btn[0]
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[11]
            Sleep    1
            
            
            ${Text}    Get Value    wnd[0]/sbar/pane[0] 
            IF  '${Text}' == 'Changes saved'
                Log To Console    Everything Updted Successfully
            ELSE
                Log To Console    Data is not saved Properly
            END
              
        END
    ELSE
        Log To Console    Nothing Differ in Pre and Post Comparison
    END
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1
      
