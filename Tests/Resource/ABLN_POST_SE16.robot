*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem

*** Keywords ***
System Logon
    Start Process     ${symvar('abinbev_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('abhinbev_SID')}  
    Sleep    5  
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('abinbev_clientno')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('abinbev_diaUsername')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('diaUserpassword')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABLN_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1


Post_SE16
    run transaction    SE16
    Send Vkey    0 
    Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	HTTP_WHITELIST
	Send Vkey    0     
    Click Element	wnd[0]/tbar[1]/btn[8]
    Sleep    5
    ${status}=    Get Status Pane    wnd[0]/sbar/pane[0] 
    IF    '${Status}' == 'No table entries found for specified key'
        Click Element	wnd[0]/tbar[0]/btn[3]   
        create_Table        
    ELSE
        Delete the tables 
        Sleep    10
        Click Element	wnd[0]/tbar[0]/btn[3]
        Click Element	wnd[0]/tbar[0]/btn[3]                #click back twice and create a new table from pre se16
        create_Table        
    END
    Clear Field Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME
    Sleep    1
    Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	HTTP_WHITELIST
	Send Vkey    0 
    Sleep    3
    Click Element	wnd[0]/tbar[1]/btn[8]
    Sleep    2    
    Take Screenshot    003_postSE16_00.jpg
    Sleep    2
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    2

Delete the tables 
    Click Element	wnd[0]/tbar[1]/btn[9]
    Sleep    2
	Click Element	wnd[0]/mbar/menu[0]/menu[5]
    Sleep    2
	Click Element	wnd[1]/usr/btnBUTTON_1
    Sleep    2

create_Table
    Log    Step 1: Read JSON file from path
    ${json_data} =    Get File    ${symvar('json_FilePath')} 
    Log    JSON Data: ${json_data}
    Log    Step 2: Parse JSON string to dictionary
    ${pre_SE16_json} =    Evaluate    json.loads('''${json_data}''')    json
    Log    Parsed JSON Data: ${pre_SE16_json}
    Log    Step 3: Loop through each row in the JSON
    FOR  ${key}  IN  @{pre_SE16_json.keys()}
        ${row_data}=    Set Variable    ${pre_SE16_json}[${key}]
        Log To Console    ${row_data}
        Click Element	wnd[0]/tbar[1]/btn[5]        #create Entries (F5)
        Input Text	wnd[0]/usr/ctxtHTTP_WHITELIST-ENTRY_TYPE	${row_data['ENTRY_TYPE']}
        Input Text	wnd[0]/usr/txtHTTP_WHITELIST-SORT_KEY	${row_data['SORT_KEY']}
        Input Text	wnd[0]/usr/txtHTTP_WHITELIST-PROTOCOL	${row_data['PROTOCOL']}
        Input Text	wnd[0]/usr/txtHTTP_WHITELIST-HOST    ${row_data['HOST']}
        Input Text	wnd[0]/usr/txtHTTP_WHITELIST-PORT	${row_data['PORT']}
        Click Element	wnd[0]/tbar[0]/btn[11]            #save   
        Sleep    2
        ${insert_Status}=    Get Status Pane    wnd[0]/sbar/pane[0]  
        Log To Console   ${insert_Status}
        IF    '${insert_Status}' == 'Database record successfully created'
            Click Element	wnd[0]/tbar[0]/btn[3]    #back
        END
    END


close
    Click Element    ${back}
    Click Element    ${back}
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[1]/usr/btnSPOP-OPTION1
    Sleep    2
  