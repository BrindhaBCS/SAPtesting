*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Variables ***
${all_row_data}    None
   

*** Keywords ***
System Logon
    Start Process     ${symvar('MASTER_SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('MASTER_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MASTER_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MASTER_User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MASTER_User_Password')}
    Send Vkey    0
    Sleep    5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

Material_master
    Run Transaction    mm01
	Sleep	2
	Select From List By Key	wnd[0]/usr/cmbRMMG1-MBRSH	M
	Sleep	2
	Select From List By Key	wnd[0]/usr/cmbRMMG1-MTART	FERT
	Sleep	2
	Set Focus	wnd[0]/usr/cmbRMMG1-MTART
	Sleep	2
	Send Vkey	0
	Sleep	2
	
		
# 		${is_row_visible}    Run Keyword And Return Status    Get Table Cell Text    wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${i}    0
# 		Log To Console    ${is_row_visible}
# 		Sleep    1
		
# 		IF    '${is_row_visible}' == 'False'  # Check if no data is retrieved
#             Log To Console    Row ${i} is empty, scrolling down...
#             ${incree}=    Evaluate    ${i}+1
#             Scroll    wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${incree}
            
#         END

# 		${rowvalue}=    Get Table Cell Text    wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${i}    0
# 		Log To Console    Value of row ${rowvalue}
		
		
# 		Append To List    ${all_row_data}    ${rowvalue}

# 		FOR    ${comp_value}    IN    @{symvar('search_comp')}   # Ensure ${symvar('search_comp')} is passed as a list
# 			Log To Console    Comparing row value ${rowvalue} with search value ${comp_value}
			
# 			IF    '${rowvalue}' == '${comp_value}'  # If a match is found
# 				Log To Console    Found matching row at index ${i} with value ${comp_value}
# 				${found_row} =    Set Variable    ${i}
				
# 				Select Table Row    wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${found_row}
# 				Exit For Loop     # Exit both loops if match is found
# 			END
# 		END
# 		Log To Console    All Data: ${all_row_data}
		
# 	END
	

# System Logout
#     Run Transaction     /nex
#     Sleep   5