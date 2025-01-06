*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
Library    Merger.py



*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}  
    Sleep    5  
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('diaUserpassword')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    5
   

SM61_ABLN
    Run Transaction	    SM61
    Sleep    2
    Take Screenshot    004_SM61.jpg
                    # table capture
    Press Toolbar Context Button	wnd[0]/shellcont/shell	&MB_VIEW
	Select Context Menu Item Customised	wnd[0]/shellcont/shell	&PRINT_BACK_PREVIEW
    Take Screenshot    004_SM61_1.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
                #  jobservergroups  
    Click Element	wnd[0]/tbar[1]/btn[14]
    Collapse Node	wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	Root
    Sleep    2
    Expand Node    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	Root
    Sleep    2
    ${tree_count}=    Get Tree child count    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    Root
    # ${nod_keys}=    Debug Get Node Paths    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell
    @{job_Server_groups}=    Create List 
    FOR    ${i}     IN RANGE    1    ${tree_count}+1
        Expand Node   wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	00${i}
        ${get_subgroup_name}=    Column Tree File Names    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    00${i}    GrpName
        ${get_file_name}=    Column Tree File Names     wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	00${i}.001	GrpName
        Sleep    2
        ${group}=    Create List    ${get_subgroup_name}    ${get_file_name}
        Append To List    ${job_Server_groups}    ${group}
        
    END
    Log To Console    ${job_Server_groups}
    Run Keyword And Ignore Error    Delete Specific File    ${symvar('json_FilePath_SM61')}
    ${pre_SM61_json}    Save Data To Json    ${job_Server_groups}    ${symvar('json_FilePath_SM61')}  
    Log    ${pre_SM61_json}
    Set Global Variable    ${pre_SM61_json}
    Log To Console    **gbStart**pre_SM61_json**splitKeyValue**${pre_SM61_json}**gbEnd**

            #health checkup
    Click Element	wnd[0]/tbar[0]/btn[3]
    Click Element	wnd[0]/usr/tabsCONTROL_TAB/tabpTENV
	Sleep	2
    Take Screenshot    004_SM61_2.jpg
	Click Element	wnd[0]/usr/tabsCONTROL_TAB/tabpTENV/ssubSUB_OBJ:SAPLCOBJ:0140/btnEXECUTE_BUTTON
	Sleep	2
    Take Screenshot    004_SM61_3.jpg
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}   
    Sleep    2