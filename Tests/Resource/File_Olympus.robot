*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
*** Variables ***

${Olympus_SAP_SERVER}    ${symvar('Olympus_SAP_SERVER')}
${Olympus_SAP_connection}    ${symvar('Olympus_SAP_connection')}

${OS_TABLE_ID}    wnd[0]/usr/tblSAPL0SFNTCTRL_V_OPSYSTEM
@{OS_ROW_POSITIONS}    16    21
${OS_FILE_SS_NAME}    File_OS

${File_Name_TABLE_ID}    wnd[0]/usr/tblSAPL0SFNTCTRL_V_FILEPATH
@{File_Name_ROW_POSITIONS}    15    30    45    60    75    90    99    105    120    129
${FILENAME_SS_NAME}    Logical_Filename

${File_Path_TABLE_ID}    wnd[0]/usr/tblSAPL0SFNTCTRL_V_FILEPATH
@{File_Path_ROW_POSITIONS}    15    30    45    60    75    90    99
${FILEPATH_SS_NAME}    Logical_Filepath

*** Keywords ***
System Logon
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Sleep    0.1
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

Executing Olympus File OS 
    Run Transaction    /nfile
    Send Vkey    0
    Sleep   1
    Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	#Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
    Select Item From Table  wnd[0]/shellcont/shell	06	Column1
    Doubleclick Element	wnd[0]/shellcont/shell	06	Column1
    Scroll SAP Table    ${OS_TABLE_ID}    ${OS_ROW_POSITIONS}    ${OS_FILE_SS_NAME}
    Sleep    1

Executing Olympus File Defn Variables 
    Run Transaction    /nfile
    Send Vkey    0
    Sleep   1
    Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	#Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
    Select Item From Table  wnd[0]/shellcont/shell	04	Column1  
    Doubleclick Element	wnd[0]/shellcont/shell	04	Column1
    Sleep    1

    Take Screenshot    Variables_Defn.jpg
    Sleep    1

Executing Olympus File Name 
    Run Transaction    /nfile
    Send Vkey    0
    Sleep   1
    Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	#Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
    Select Item From Table  wnd[0]/shellcont/shell	03	Column1 
    Scroll SAP Table    ${File_Name_TABLE_ID}    ${File_Name_ROW_POSITIONS}    ${FILENAME_SS_NAME}
    Sleep    1

Executing Olympus File Path 
    Run Transaction    /nfile
    Send Vkey    0
    Sleep   1
    Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	#Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
    Select Item From Table  wnd[0]/shellcont/shell	02	Column1 
    Scroll SAP Table    ${File_Path_TABLE_ID}    ${File_Path_ROW_POSITIONS}    ${FILEPATH_SS_NAME}
    Sleep    1

Executing Olympus File Syntax 
    Run Transaction    /nfile
    Send Vkey    0
    Sleep   1
    Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
	#Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	0.2
    Select Item From Table  wnd[0]/shellcont/shell	05	Column1
    Doubleclick Element	wnd[0]/shellcont/shell	05	Column1
    Sleep    1
    Take Screenshot    Syntax.jpg
    Sleep    1

System Logout
    Run Transaction    /nex
    Sleep    1
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}

Scroll SAP Table
    [Arguments]    ${table_id}    ${row_positions}    ${file_name_ss}

    FOR    ${row}    IN    @{row_positions}
    Take Screenshot    ${file_name_ss}_1.jpg
        Scroll	${table_id}    ${row} 
        Take Screenshot    ${file_name_ss}_${row}.jpg
        Log To Console    Scrolled to row: ${row}
        Sleep    2s
    END