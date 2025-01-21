*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    SAP_Tcode_Library.py
Library    DateTime
*** Keywords *** 
Fiori_System Logon
    Start Process    ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection     ${symvar('Fiori_Connection')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Fiori_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Fiori_User_Name_1')}
    Sleep    1
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Fiori_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{'Fiori_User_Password'}
    Sleep    1
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Fiori_Test_code

System Logout
    Run Transaction   /nex

Fiori_Test_code  
	Run Transaction    se16
	Sleep	1
    Take Screenshot    fiori.jpf01
	Input Text	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	agr_define
	Sleep	1
	Set Caret Position	wnd[0]/usr/ctxtDATABROWSE-TABLENAME	10
	Sleep	1
	Send Vkey    0
	Sleep	1
	Input Text	wnd[0]/usr/ctxtI8-LOW	${symvar('Change_From_Date')}
	Sleep	1
	Input Text	wnd[0]/usr/ctxtI8-HIGH	${symvar('Change_End_Date')}
	Sleep	1
	Set Focus	wnd[0]/usr/ctxtI8-HIGH
	Sleep	1
	set Caret Position	wnd[0]/usr/ctxtI8-HIGH	10
	Sleep	1
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	1
	Click Element	wnd[0]/mbar/menu[1]/menu[5]
	Sleep	1
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    Fiori_Change_Role_extract
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    0.5 seconds
    clear field text    wnd[1]/usr/ctxtDY_PATH
    Sleep    0.5 seconds
    Input Text    wnd[1]/usr/ctxtDY_PATH    c:\\tmp\\FIORI\\
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[11]
    Sleep    0.5 seconds
    Roles extract    c:\\tmp\\FIORI\\Fiori_Change_Role_extract.xlsx    Sheet1    c:\\tmp\\FIORI\\Fiori_Change_Role_extract.txt
    Sleep    0.5 seconds
	Roles_Test_code


Roles_Test_code	 
    Run Transaction    /nSUIM
    Sleep    1
    suim role expand    wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
    Sleep    1
    Click Element    wnd[0]/usr/btn%_SELROLE_%_APP_%-VALU_PUSH
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[23]
    Sleep    0.5 seconds
    Input Text    wnd[2]/usr/ctxtDY_PATH    C:\\tmp\\FIORI\\
    Sleep    0.5 seconds
    Input Text    wnd[2]/usr/ctxtDY_FILENAME    Fiori_Change_Role_extract.txt
    Sleep    0.5 seconds
    Click Element    wnd[2]/tbar[0]/btn[0]
    Sleep    0.5 seconds
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep    0.5 seconds
    Select From List By Label    wnd[0]/usr/cmbP1_PTYPE    Launchpad Catalog
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    0.5 second
	Click Element    wnd[0]/tbar[1]/btn[45]
    Sleep    1
    Select Radio Button    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[2,0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Input Text    wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME    SUIM_FIORI_ROLE_change
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[20]
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    C:\\tmp\\FIORI\\
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    3
	Clean Excel Sheet    C:\\tmp\\FIORI\\SUIM_FIORI_ROLE_change.xlsx    Sheet1
    Sleep    1
	${fiori_extract}    Fiori Extract Roles    C:\\tmp\\FIORI\\SUIM_FIORI_ROLE_change.xlsx    Sheet1
    Sleep    1
    Log    ${fiori_extract}
    # Tcode_SU01
# Tcode_SU01
    Run Transaction    /nsu01
    Sleep    1
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('Fiori_LaunchPad_UserName')}           #userfiled
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[7]                                #displayicon
    Sleep    0.5 seconds
    Click Element    wnd[0]/tbar[1]/btn[19]                                #change&displayicon
    Sleep    0.5 seconds
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
    Sleep    1
    ${tech}    Get Sap Cell Value AGR NAME    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    3
    Sleep    1
    Delete_allrole_Fiori
    Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    0    ZT_TRACE_ANALYSIS
    Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    1    Z_FLP_USER
    Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    2    Z_SE16
    ${roles_tcodes_items}    Get Length    ${fiori_extract}
    FOR    ${item}    IN RANGE    3    ${roles_tcodes_items}
        ${role}    Set Variable    ${fiori_extract}[${item}]
        Log    Role: ${role}
        Modify Sap Cell    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${item}    ${role}
        Sleep    1      
    END
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    1
    Run Transaction    /nstauthtrace
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[7]
    Clear Field Text    wnd[0]/usr/ctxtSC_100_TRACE_USER
    Input Text    wnd[0]/usr/ctxtSC_100_TRACE_USER    ${symvar('Fiori_LaunchPad_UserName')}
    Click Element    wnd[0]/tbar[1]/btn[6]