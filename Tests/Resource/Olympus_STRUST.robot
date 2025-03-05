*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py

*** Keywords ***
System Logon
    Start Process     ${symvar('ABB_Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABB_Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABB_Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABB_Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABB_Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1


Transaction STRUST
    Run Transaction     /nstrust
    Send Vkey    0
    Take Screenshot    042_PSE_01.jpg
    Sleep    2
    
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    042_PSE_02.jpg
    Sleep    2

System pse
    Expand Node	wnd[0]/shellcont/shell	PROG<SYST>
	Sleep	2
	Select Top Node	wnd[0]/shellcont/shell	PROG<SYST>
	Sleep	2
    Take Screenshot    042_PSE_03.jpg
    Sleep    2
	Double Click On Tree Item	wnd[0]/shellcont/shell	PROG<SYST>1
	Sleep	2
    Take Screenshot    042_PSE_04.jpg
    Sleep    2

SSL server standard 
    Expand Node	wnd[0]/shellcont/shell	SSLSDFAULT
	Sleep	2       
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT    
    Sleep    2
    Take Screenshot    042_SSLSDFAULT_05.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    042_SSLSDFAULT_06.jpg
    Sleep    2

SSL client SSL Client (Anonymous)
    Expand Node    wnd[0]/shellcont/shell    SSLCANONYM
    Sleep    2
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Take Screenshot    042_SSLCANONYM_07.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    042_SSLCANONYM_08.jpg
    Sleep    2

SSL client SSL Client (Standard)
    Expand Node    wnd[0]/shellcont/shell    SSLCDFAULT
    Sleep    2
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    Take Screenshot    042_SSLCDFAULT_09.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    042_SSLCDFAULT_10.jpg
    Sleep    2


SSF Logon Ticket
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSFASSO2    
    Sleep    2
    Take Screenshot    042_SSFASSO2_11.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    042_SSFASSO2_11.jpg
    Run Transaction    /nex
    Sleep    5
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}