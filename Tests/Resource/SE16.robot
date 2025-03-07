*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
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
   

SE16
    Run Transaction    se16
	Sleep	2
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xls
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xlsx
    Run Keyword And Ignore Error    Delete Specific File    C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.json
	
	Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	EDPP1
	Sleep	2
	
	Click Element	wnd[0]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[31]
	Sleep	2
    Take Screenshot    001_SE16_01.jpg
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
	Click Element	wnd[0]/mbar/menu[6]/menu[5]/menu[2]/menu[2]
	Sleep	2
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
	
	Sleep	2
	Set Focus	wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\SAP_Hein\\Heineken\\
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_FILENAME	DH5_001_EDPP1.xls
	Sleep	2
	Set Focus	wnd[1]/usr/ctxtDY_FILENAME
	Sleep	2

	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2

    Convert Xls To Xlsx    C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xls    C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xlsx
    Open Excel Document    C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xlsx    DH5_001_EDPP1
    ${column_data}=    Read Excel Values  C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xlsx    sheet_name=DH5_001_EDPP1    
    
    ${Cleaned_List}=    Clean List Excel    ${column_data}     
    Log    ${Cleaned_List}

    ${sliced_data} =    Evaluate    [int(x) for row in ${Cleaned_List}[1:] for x in row if x.isdigit()]
    Log    ${sliced_data}
    Sleep    5
    Process Excel    file_path=C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xlsx    sheet_name=DH5_001_EDPP1    column_index=0
    Sleep    2
    
    ${json}    Excel To Json    excel_file=C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.xlsx   json_file=C:\\SAP_Hein\\Heineken\\DH5_001_EDPP1.json   
    Log    ${json}
    Close Current Excel Document
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1

	


