*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('TS4_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('TS4_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('TS4_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{TS4_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
  
System Logout
    Run Transaction   /nex
    # Sleep    2
VF04
    Run Transaction    /nVF04
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.2 seconds
    Click Element    wnd[0]/mbar/menu[3]/menu[1]/menu[2]
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    0.2 seconds
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    0.2 seconds
    Clear Field Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    0.2 seconds
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    ${symvar('FileName')} 
    Sleep    0.2 seconds
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    0.2 seconds
    Clear Field Text    wnd[1]/usr/ctxtDY_PATH
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('FilePath')}
    Sleep    0.2 seconds
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    0.2 seconds
    Process Excel    file_path=${symvar('FilePath')}${symvar('FileName')}.xlsx    sheet_name=Sheet1    column_index=["0","1"]    row_indices=["0","1","2","3"]
    ${i}    Excel To Json    excel_file=${symvar('excel_path')}    json_file=${symvar('json_path')}
    Log To Console    **gbStart**copilot_key**splitKeyValue**${i}**gbEnd**
    # Excel Arrange   ${symvar('FilePath')}    Sheet1    ${symvar('FileName')}.xlsx
    Sleep    1
    


    


      

    

    
    
    
    
    
    
    
    
    
  
    



