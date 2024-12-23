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

ABB_RZ11
    Run Transaction    /nRZ11
    Sleep    1
    Take Screenshot    009_RZ11_0.jpg
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
    Input Text    wnd[0]/usr/ctxtTPFYSTRUCT-NAME    *wp*
    Take Screenshot    009_RZ11_1.jpg
    Click Element    wnd[0]/usr/btnPANZEIGEN_1000
    Sleep    1
    Take Screenshot    009_RZ11_2.jpg
    ${get_title}    Get Window Title    locator=wnd[1]
    ${row_count}    Extract Numeric    ${get_title}
    ${row_count}    Convert To Integer    ${row_count}
    ${All_Values}    Create List
    FOR    ${i}    IN RANGE    3    ${row_count + 3}
        ${value}    Get Value    wnd[1]/usr/lbl[1,${i}]
        ${A}    Append To List   ${All_Values}    ${value}
    END
    
    Log To Console    ${A}
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1

    Convert pdf    ${symvar('Screenshot_directory')}    ${symvar('Screenshot_directory')}\\${symvar('PDFFILE_NAME')}
    Sleep    2