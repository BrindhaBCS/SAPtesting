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
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}            
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{DL1_PASSWORD}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    5
    
Check If Can Scroll Further
    ${status}=    Run Keyword And Return Status    Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[1]/btn[22]
    RETURN    ${status}


STMS_import
    Run Transaction	    stms_import
	Sleep	2
	Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xls
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xlsx
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\DH5_001_import_history.json
	Click Element	wnd[0]/mbar/menu[2]/menu[1]
	Sleep	2

	Run Keyword And Ignore Error    Close Window	wnd[1]
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[18,3]
	Sleep	2
	
	Send Vkey	2
	Sleep	2
	${prev_year}=    Get Current Date    result_format=%d.%m.%Y    increment=-365 day
    Input Text	wnd[1]/usr/ctxtTMSGPERIOD-BEGDA	${prev_year}
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0] 
	Sleep	2
	
    ${scroll_count}=    Set Variable    1
    ${previous_position}=    Get Scroll Position    wnd[0]/usr  

    WHILE    True
        ${current_screenshot}=    Set Variable    006_STMSIMPORT_01_${scroll_count}.jpg
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
	
	Sleep	2
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
	Input Text	wnd[1]/usr/ctxtDY_FILENAME	DH5_001_import_history.xls
	Sleep	2
	
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2

    Convert Xls To Xlsx    C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xls    C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xlsx
    Open Excel Document    C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xlsx    DH5_001_import_history
    ${column_data}=    Read Excel Values  C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xlsx    sheet_name=DH5_001_import_history    
    
    ${Cleaned_List}=    Clean List Excel    ${column_data}     
    Log    ${Cleaned_List}

    ${sliced_data} =    Evaluate    [int(x) for row in ${Cleaned_List}[1:] for x in row if x.isdigit()]
    Log    ${sliced_data}
    Sleep    5
    Process Excel    file_path=C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xlsx    sheet_name=DH5_001_import_history    column_index=0
    Sleep    2
    
    ${json}    Excel To Json    excel_file=C:\\SAP_Hein\\Heineken\\DH5_001_import_history.xlsx   json_file=C:\\SAP_Hein\\Heineken\\DH5_001_import_history.json   
    Log    ${json}
    Close Current Excel Document
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1

