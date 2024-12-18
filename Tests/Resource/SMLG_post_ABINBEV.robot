*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary


*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}    
    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_PASSWORD}   
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
System Logout
    Run Transaction   /nex
    Sleep    5

Read Excel Sheet
    [Arguments]    ${Excel_file}    ${sheetname}    ${rownum}    ${colnum}    
    Open Excel Document    ${Excel_file}    1
    Get Sheet    ${sheetname}    
    ${data}    Read Excel Cell    ${rownum}    ${colnum}        
    [Return]    ${data}
    # Log To Console    ${data}
    Close Current Excel Document

Get Row Count
    [Arguments]    ${file_path}    ${sheet_name}
    Close Current Excel Document
    Open Excel Document    ${file_path}    1
    Get Sheet    ${sheetname}
    ${row_count}=    Get Row Count    ${file_path}    ${sheet_name}
    Close Current Excel Document    
    [Return]    ${row_count}
        
SMLG_ABLN
    Run Transaction	    SMLG
	Sleep	2
	Send Vkey	0
	Sleep	2
    Take Screenshot    1_smlg.jpg

Delete logon group
    
    Open Excel Document    ${symvar('Excel_path')}    ${symvar('Excel_sheet')}
    ${total_row}    Get Material Count    ${symvar('Excel_path')}

    FOR    ${i}    IN RANGE    2    ${total_row + 1}
        Set Focus    wnd[0]/usr/lbl[1,3]
        Sleep    2
        
        Click Element    wnd[0]/tbar[1]/btn[17]
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[6]
        Sleep    2
        Close Current Excel Document
    END
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2

Create logon group
    Open Excel Document    ${symvar('Excel_path')}    ${symvar('Excel_sheet')}
    ${row}    Get Material Count    ${symvar('Excel_path')}

    FOR    ${row}    IN RANGE    2    ${row + 1}
        Click Element    wnd[0]/tbar[1]/btn[8]
        Sleep    2

        ${Logon Group}    Read Excel Sheet    C:\\tmp\\smlg_report.xlsx    Sheet1    ${row}    1
        Input Text    wnd[1]/usr/tabsSEL_TAB/tabpZUOR/ssubSUB1:SAPMSMLG:3003/ctxtRZLLITAB-CLASSNAME    ${Logon Group}
        Sleep    2

        ${Instance}    Read Excel Sheet    C:\\tmp\\smlg_report.xlsx    Sheet1    ${row}    2
        Input Text    wnd[1]/usr/tabsSEL_TAB/tabpZUOR/ssubSUB1:SAPMSMLG:3003/ctxtRZLLITAB-APPLSERVER    ${Instance}
        Sleep    2

        Set Focus    wnd[1]/usr/tabsSEL_TAB/tabpZUOR/ssubSUB1:SAPMSMLG:3003/ctxtRZLLITAB-APPLSERVER
        Sleep    2
        Click Element    wnd[1]/tbar[0]/btn[0]
        Sleep    2
        Close Current Excel Document
    END
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2



    



    
    





    



   
