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
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}       
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
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

create_role
    Run Transaction    /nPFCG
    Sleep    3
    FOR    ${condition}    IN RANGE    1000  
        ${pass} =    Run Keyword And Return Status    Input Text    wnd[0]/usr/ctxtAGR_NAME_NEU    ${symvar('role_creation_input_value')}[${condition}]
        Run Keyword If    not ${pass}    Exit For Loop
        Sleep    1
        Click Element    wnd[0]/usr/btn%#AUTOTEXT003
        Sleep    3
        ${true_condition}    Get Value    wnd[0]/sbar/pane[0]
        IF    '${true_condition}' == 'Role ${symvar('role_creation_input_value')}[${condition}] already exists'
            Take Screenshot
            Sleep    1
            Log    ${true_condition}
            Sleep    1
            Log To Console    ${true_condition}
        ELSE IF   '${true_condition}' != 'Role ${symvar('role_creation_input_value')}[${condition}] already exists'
            Sleep    3
            Input Text    wnd[0]/usr/txtS_AGR_TEXTS-TEXT    ${symvar('Description_of_role')}    
            Sleep    2
            Click Element    wnd[0]/tbar[1]/btn[17]
            Sleep    2
            Click Element    wnd[1]/usr/btnBUTTON_1
            Sleep    2
            Click Element    wnd[1]/tbar[0]/btn[12]
            Sleep    2
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpTAB9
            Sleep    2
            Click Toolbar Button    wnd[0]/usr/tabsTABSTRIP1/tabpTAB9/ssubSUB1:SAPLPRGN_TREE:0321/cntlTOOL_CONTROL/shellcont/shell    TB03
            Sleep    2
            FOR    ${Tcode_index_input}    IN RANGE    1000
                Take Screenshot
                ${tcode_input_role} =    Run Keyword And Return Status    Input Text    wnd[1]/usr/tblSAPLPRGN_WIZARDCTRL_TCODE/ctxtS_TCODES-TCODE[0,${Tcode_index_input}]    ${symvar('tcode')}[${Tcode_index_input}]
                Run Keyword If    not ${tcode_input_role}    Exit For Loop  
                Take Screenshot
            END
            Click Element    wnd[1]/tbar[0]/btn[19]  
            Sleep    2
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpTAB5
            Sleep    3
            Take Screenshot
            Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpTAB5/ssubSUB1:SAPLPRGN_TREE:0350/btnPROFIL1      
            Sleep    3
            Take Screenshot
            Click Element    wnd[1]/usr/btnBUTTON_1
            Sleep    3
            Take Screenshot
 
            ${first_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/tbar[0]/btn[0]
            ${second_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/tbar[0]/btn[12]
 
            ${first_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/tbar[0]/btn[0]
            ${second_element_present} =    Run Keyword And Return Status    Click Element    wnd[1]/tbar[0]/btn[12]
            IF    ${first_element_present} and ${second_element_present}
                Sleep    2
            ELSE IF    ${first_element_present}
                Click Element    wnd[1]/tbar[0]/btn[0]
            ELSE IF    ${second_element_present}
                Click Element    wnd[1]/tbar[0]/btn[12]
            END
            Sleep    3
            Take Screenshot
            Set Focus    wnd[0]/usr/lbl[5,4]    
            Sleep    2
            Send Vkey    2
            Sleep    2
            Set Focus    wnd[0]/usr/lbl[9,6]
            Sleep    2
            Send Vkey    2
            Sleep    2
            Click Element    wnd[0]/mbar/menu[3]/menu[9]        
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[11]      
            Sleep    2
            Click Element    wnd[1]/tbar[0]/btn[0]    
            Sleep    2
        #--------full--Authorization
            Set Focus    wnd[0]/usr/lbl[5,12]
            Sleep    1
            Send Vkey    2
            Sleep    1
            Set Focus    wnd[0]/usr/lbl[9,14]
            Sleep    1
            Send Vkey    2
            Sleep    2
            Set Focus    wnd[0]/usr/lbl[23,19]
            Sleep    2
            Send Vkey    2
            Sleep    1
            Click Element    wnd[1]/usr/btnGES1          
            Sleep    1
            Click Element    wnd[1]/tbar[0]/btn[0]      
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[11]      
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[3]      
            Sleep    1
            Click Element    wnd[1]/tbar[0]/btn[0]      
            Sleep    1
            Click Element    wnd[0]/tbar[0]/btn[3]
            Sleep    1
        #---generate--mass geneartion
            Click Element    wnd[0]/mbar/menu[3]/menu[1]      
            Sleep    1
            Select Radio Button    wnd[0]/usr/radPRT_ALL      
            Sleep    1
            Click Element    wnd[0]/usr/btn%_SEL_SHT_%_APP_%-VALU_PUSH  
            Sleep    1
            Input Text    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,0]    ${symvar('role_creation_input_value')}[${condition}]
            Sleep    1
            Click Element    wnd[1]/tbar[0]/btn[8]            
            Sleep    1
            Select Checkbox    wnd[0]/usr/chkAUTO_GEN        
            Sleep    1
            Click Element    wnd[0]/tbar[1]/btn[8]  
            Sleep    1
            Click Element    wnd[1]/usr/btnBUTTON_2        
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]    
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]
            Sleep    2
            Take Screenshot
        END    
    END