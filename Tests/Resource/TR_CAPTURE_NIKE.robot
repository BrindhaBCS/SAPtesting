*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')} 
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}       
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

TR_capture
    Run Transaction    /npfcg
    Sleep    1
    FOR    ${Tr_index}    IN RANGE    1000  
        ${good} =    Run Keyword And Return Status    Input Text    wnd[0]/usr/ctxtAGR_NAME_NEU    ${symvar('Tr_input_value')}[${Tr_index}]
        Run Keyword If    not ${good}    Exit For Loop
        Sleep    1
        Click Element    wnd[0]/usr/btn%#AUTOTEXT002    
        Sleep    1
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpTAB9    
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[6]    
        Sleep    1
        Click Toolbar Button    wnd[0]/usr/tabsTABSTRIP1/tabpTAB9/ssubSUB1:SAPLPRGN_TREE:0321/cntlTOOL_CONTROL/shellcont/shell    TB03
        Sleep    2
        FOR    ${Tcode_index}    IN RANGE    1000
            Take Screenshot    TR_capture_01.jpg    
            ${tcode_input_value} =    Run Keyword And Return Status    Input Text    wnd[1]/usr/tblSAPLPRGN_WIZARDCTRL_TCODE/ctxtS_TCODES-TCODE[0,${Tcode_index}]    ${symvar('Tr_Tcode_input')}[${Tcode_index}]
            Run Keyword If    not ${tcode_input_value}    Exit For Loop  
            Take Screenshot    TR_capture_02.jpg
        END
        Click Element    wnd[1]/tbar[0]/btn[19]  
        Sleep    1
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpTAB5    
        Sleep    2
        Take Screenshot    TR_capture_03.jpg
        Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpTAB5/ssubSUB1:SAPLPRGN_TREE:0350/btnPROFIL1    
        Sleep    1
        Take Screenshot    TR_capture_04.jpg
        ${first_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/usr/btnBUTTON_1
        ${second_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/tbar[0]/btn[0]
        ${first_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/usr/btnBUTTON_1
        ${second_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/tbar[0]/btn[0]
        IF    ${first_element_present} and ${second_element_present}
            Sleep    2
        ELSE IF    ${first_element_present}
            Click Element    wnd[1]/usr/btnBUTTON_1
        ELSE IF    ${second_element_present}
            Click Element    wnd[1]/tbar[0]/btn[0]
        END
        Click Element    wnd[0]/tbar[0]/btn[11]     
        Sleep    2
        Click Element    wnd[0]/tbar[1]/btn[17]           
        Sleep    2
        Click Element    wnd[1]/usr/btnBUTTON_1               
        Sleep    2
        Take Screenshot    profile_create.jpg
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]        
        Sleep    2
        Take Screenshot    Status_profile_name.jpg
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]        
        Sleep    2
    END
    Click Element    wnd[0]/mbar/menu[3]/menu[3]
    Sleep    1
    Click Element    wnd[0]/usr/btn%_AGR_NAME_%_APP_%-VALU_PUSH
    Sleep    1
    FOR    ${Tr_Mass}    IN RANGE    1000 
        ${Tr_input} =    Run Keyword And Return Status    Input Text    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,${Tr_Mass}]    ${symvar('Tr_input_value')}[${Tr_Mass}]
        Run Keyword If    not ${Tr_input}    Exit For Loop        
    END
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Input Text    wnd[1]/usr/ctxtKO008-TRKORR    ${EMPTY}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtKO008-TRKORR    ${symvar('Tr_input_request')}
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    ${route_title}    Get Window Title    wnd[0]/titl
    IF    '${route_title}' == 'Role Transport'
        Take Screenshot    TR_capture_05.jpg
    ELSE IF    '${route_title}' != 'Role Transport'
        ${text}    Get Value    wnd[2]/usr/txtMESSTXT1
        Log    No action taken. Unexpected TR number of input you given:${text}
        Log To Console    ${text}
        Take Screenshot    TR_capture_06.jpg
        Click Element    wnd[2]/tbar[0]/btn[0]
        Take Screenshot    TR_capture_07.jpg
        Click Element    wnd[1]/tbar[0]/btn[12]
        Take Screenshot    TR_capture_08.jpg
        Sleep    2
    ELSE
        Log    No action taken. Unexpected TR number of input you given.
    END