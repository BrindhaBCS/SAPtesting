*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py

*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABLN_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
 
   
System Logout
    Run Transaction   /nex
    # Sleep    2

ABB_STRUST
    Run Transaction    /nSTRUST
    Sleep    1
    Take Screenshot    006_STRUST.jpg
    
System PSE
    Expand Node    wnd[0]/shellcont/shell	PROG<SYST>
	Sleep	1
    Take Screenshot    006_STRUST_1.jpg
    Double Click On Tree Item    wnd[0]/shellcont/shell    PROG<SYST>1
    Sleep    1
    Take Screenshot    006_STRUST_2.jpg

SSL Server Standard
    Expand Node	wnd[0]/shellcont/shell	SSLSDFAULT
	Sleep	1
    Take Screenshot    006_STRUST_3.jpg
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT1
    Sleep    1
    Take Screenshot    006_STRUST_4.jpg
    Double Click On Tree Item	wnd[0]/shellcont/shell	SSLSDFAULT2
	Sleep	1
    Take Screenshot    006_STRUST_5.jpg

SSL Client Anonymous
    Expand Node    wnd[0]/shellcont/shell	SSLCANONYM
	Sleep	1
    Take Screenshot    006_STRUST_6.jpg
    Double Click On Tree Item	wnd[0]/shellcont/shell	SSLCANONYM1
	Sleep	1
    Double Click On Tree Item	wnd[0]/shellcont/shell	SSLCANONYM2
	Sleep	2
    Take Screenshot    006_STRUST_7.jpg

SSL Client Standard
    Expand Node    wnd[0]/shellcont/shell	SSLCDFAULT
	Sleep	2
	Double Click On Tree Item	wnd[0]/shellcont/shell	SSLCDFAULT1
	Sleep	2
    Take Screenshot    006_STRUST_8.jpg

SSF service Provider
    Expand Node	wnd[0]/shellcont/shell	SSFAS2SVPE
	Sleep	2
    Double Click On Tree Item	wnd[0]/shellcont/shell	SSFAS2SVPE1
	Sleep	2
    Take Screenshot    006_STRUST_9.jpg
SSF Service Provider1
    Expand Node	wnd[0]/shellcont/shell	SSFAS2SVPS
	Sleep	2
	Double Click On Tree Item	wnd[0]/shellcont/shell	SSFAS2SVPS1
	Sleep	2
    Take Screenshot    006_STRUST_10.jpg

    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1