*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    String
Library    Merger.py

*** Variables ***
${EXCEL_PATH}    C:\\TEMP\\ABB.xlsx
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
Select Table Data
    Click Element    wnd[0]/mbar/menu[4]/menu[5]/menu[2]/menu[2]
    Sleep    1
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
    
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Delete Specific File    ${EXCEL_PATH}
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\TEMP
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ABB.xlsx
    
    
    Click Element    wnd[1]/tbar[0]/btn[0]
   
    Clean Excel Sheet    ${EXCEL_PATH}    ${Sheet}
    ${Row count}    Get Total Row    ${EXCEL_PATH}    ${Sheet}
    ${i}    Set Variable    1
    
    FOR    ${Row_Index}    IN RANGE    2    ${Row count +1}    
        ${A}=    Read Value From Excel    ${EXCEL_PATH}    ${Sheet}    A${Row_Index}
        
        Sleep    1
        Focus On Particular Text    ${A}    wnd[0]/usr
        Sleep    1
        
        Click Element    wnd[0]/tbar[1]/btn[2]
        Sleep    1
        
        ${Activated}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-USE_QUOTAS
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    C${Row_Index}    ${Activated}
        ${Max Queue}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_QUEUE
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    D${Row_Index}    ${Max Queue}
        ${Max logons}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_LOGIN
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    E${Row_Index}    ${Max logons}
        ${Max seperate logons}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_OWN_LG
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    F${Row_Index}    ${Max seperate logons}
        ${Max WPs}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_OWN_WP
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    G${Row_Index}    ${Max WPs}
        ${Max comm Entries}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_COMM
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    H${Row_Index}    ${Max comm Entries}
        ${Max Wait Time}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_WAIT_T
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    I${Row_Index}    ${Max Wait Time}
        ${Max.No.ofOpen Tasks}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_OPEN_TASKS
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    J${Row_Index}    ${Max.No.ofOpen Tasks}
        ${Max.Quota.prior_Normal}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_NORMAL_QUOTA
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    K${Row_Index}    ${Max.Quota.prior_Normal}
        ${Max.Quota.Prior.Low}=    Get Value    wnd[1]/usr/txtARFCQUOTAS_EXT-MAX_LOW_QUOTA
        Write Value To Excel    ${EXCEL_PATH}    ${Sheet}    L${Row_Index}    ${Max.Quota.Prior.Low}
        # Take Screenshot    000_RZ12_${i}.jpg
        ${i}    Evaluate    ${i} + 1
        Click Element    wnd[1]/tbar[0]/btn[12]
        Sleep    2
        
        
    END
    ${Excel}    Excel To Json    ${EXCEL_PATH}    json_file=C:\\TEMP\\ABB.json
    Delete Specific File    C:\\TEMP\\ABB.json
    Log To Console    **gbStart**Target_Host**splitKeyValue**${Excel}**gbEnd**
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1
    


    
    
    



    
    
