*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
Library    DateTime
Library    Merger.py



*** Keywords ***
System Logon
    Start Process     ${symvar('Heineken_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('Heineken_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Heineken_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Heineken_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}            
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{DL1_PASSWORD}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    5
    
Check If Can Scroll Further
    # Implement logic to determine if scrolling is still possible.
    ${can_scroll}=    Evaluate    False  # Replace this with actual check logic
    RETURN    ${can_scroll}

SM37
    Run Transaction    SM37
	Sleep	2
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\SM37.xls
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\SM37.xlsx
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\SM37.json
    Sleep    2
	Input Text	wnd[0]/usr/txtBTCH2170-USERNAME	*
	Sleep	2
    ${prev_year}=    Get Current Date    result_format=%d.%m.%Y    increment=-365 day
	Input Text	wnd[0]/usr/ctxtBTCH2170-FROM_DATE	${prev_year}
	Sleep	2
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-READY 
    Sleep    1
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-RUNNING
    Sleep    1
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-FINISHED 
    Sleep    1
    Unselect Checkbox    wnd[0]/usr/chkBTCH2170-ABORTED
    Sleep    1

	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
	
    # ${scroll_count}=    Set Variable    1
    # WHILE    True
    #     ${current_screenshot}=    Set Variable    SM37${scroll_count}.jpg
    #     Run Keyword And Ignore Error    Scroll    wnd[0]/usr    ${scroll_count}
    #     ${Screen_shot}=    Take Screenshot    ${current_screenshot}
    #     ${scroll_count}=    Evaluate    ${scroll_count} + 1
    #     ${can_scroll}=    Check If Can Scroll Further
    #     Log    Can Scroll: ${can_scroll}
    #     IF    not ${can_scroll}    BREAK
    # END

    ${scroll_count}=    Set Variable    1
    ${previous_position}=    Get Scroll Position    wnd[0]/usr  

    WHILE    True
        ${current_screenshot}=    Set Variable    005_SM37_01_${scroll_count}.jpg
        Run Keyword And Ignore Error    Scroll    wnd[0]/usr    ${scroll_count}
        
        ${current_position}=    Get Scroll Position    wnd[0]/usr

        # If the position does not change, scrolling is not possible
        IF    '${previous_position}' == '${current_position}'
            BREAK
        END

        ${Screen_shot}=    Take Screenshot    ${current_screenshot}
        ${scroll_count}=    Evaluate    ${scroll_count} + 1
        ${previous_position}=    Set Variable    ${current_position}
    END

    Click Element	wnd[0]/mbar/menu[5]/menu[5]/menu[2]/menu[2]
	Sleep	2
	Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
	Sleep	2
	Set Focus	wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\SAP_Hein\\Heineken\\
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_FILENAME	SM37.xls
	Sleep	2
	
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2

    Convert Xls To Xlsx    C:\\SAP_Hein\\Heineken\\SM37.xls    C:\\SAP_Hein\\Heineken\\SM37.xlsx
    Open Excel Document    C:\\SAP_Hein\\Heineken\\SM37.xlsx    SM37
    ${column_data}=    Read Excel Values  C:\\SAP_Hein\\Heineken\\SM37.xlsx    sheet_name=SM37    
    
    ${Cleaned_List}=    Clean List Excel    ${column_data}     
    Log    ${Cleaned_List}

    ${sliced_data} =    Evaluate    [int(x) for row in ${Cleaned_List}[1:] for x in row if x.isdigit()]
    Log    ${sliced_data}
    Sleep    5
    Process Excel    file_path=C:\\SAP_Hein\\Heineken\\SM37.xlsx    sheet_name=SM37    column_index=0
    Sleep    2
    
    ${json}    Excel To Json    excel_file=C:\\SAP_Hein\\Heineken\\SM37.xlsx   json_file=C:\\SAP_Hein\\Heineken\\SM37.json   
    Log    ${json}
    Close Current Excel Document
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1
