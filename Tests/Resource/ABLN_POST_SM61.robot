*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
Library    Merger.py

*** Variables ***
${File_path}    C:\\tmp\\pre_SM61_report.json

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
Delete Group
    Expand Node    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    Root

    ${tree_count}=    Get Tree child count    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    Root
    FOR  ${tree}  IN RANGE  1    ${tree_count}+1
        Select Item	wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	00${tree}	GrpName
        Ensure Visible Horizontal Item	wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	00${tree}	GrpName
        Select Node Link	wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	00${tree}	GrpName
        Click Element	wnd[0]/tbar[1]/btn[22]
        Run Keyword And Ignore Error    Click Element 	wnd[1]/tbar[0]/btn[0]        
    END

create group
    Expand Node    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    Root
    ${json_data} =   Load JSON From File    ${symvar('json_FilePath_SM61')}
    # ${pre_SM61_json} =    Evaluate     json.loads(${json_data})    json
    FOR    ${item}    IN    @{json_data}
        Log To Console    Processing: ${item}
        Click Element    wnd[0]/tbar[1]/btn[13]
        Input Text    wnd[1]/usr/txtG_NEW_SRV_GROUP    ${item[0]}
        Click Element    wnd[1]/tbar[0]/btn[0]
    END

Insert Assignments
    ${json_data} =   Load JSON From File    ${symvar('json_FilePath_SM61')}
    
    # Loop through the JSON data
    FOR    ${item}    IN    @{json_data}

        Log To Console    Processing: ${item}        
        # Perform operations from loop2
        ${tree_count_insert} =    Get Tree child count    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    Root
        FOR    ${i}    IN RANGE    1    ${tree_count_insert}+1
            Expand Node    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    Root
            Expand Node    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    00${i}
            Sleep    2
            ${post_created_file_name}=    Column Tree File Names    wnd[0]/usr/cntlGROUP_TREE/shellcont/shell    00${i}    GrpName
            ${folderName}=    Set Variable    ${item[0]}
            IF    '${post_created_file_name}' == '${folderName}'
                ${fileName}=    Set Variable    ${item[1]}
                Log To Console    Row Data: ${fileName}
                # Expand Node	wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	00${i}
                Select Top Node	wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	Root
                Select Node Link	wnd[0]/usr/cntlGROUP_TREE/shellcont/shell	00${i}	GrpName
                Sleep    2
                Click Element	wnd[0]/tbar[1]/btn[16]
                Sleep    2
                Input Text	wnd[1]/usr/ctxtBPGRP0101-APPSRVNAME    ${fileName}
                Sleep    2
                Click Element	wnd[1]/tbar[0]/btn[0]
            END
        END
    END


Health checkup
    Click Element	wnd[0]/tbar[0]/btn[3]
    Click Element	wnd[0]/usr/tabsCONTROL_TAB/tabpTENV
	Sleep	2
    Take Screenshot    004_SM61_2.jpg
	Click Element	wnd[0]/usr/tabsCONTROL_TAB/tabpTENV/ssubSUB_OBJ:SAPLCOBJ:0140/btnEXECUTE_BUTTON
	Sleep	2
    Take Screenshot    004_SM61_3.jpg
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}   
    Sleep    2