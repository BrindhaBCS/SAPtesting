*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
# Resource    newdemo.robot
# Test Tags    newonee

*** Variables ***
@{t-codes}    /nSM14   /nsm87

*** Keywords ***
SAP Logon
    Start Process    ${symvar('sap_server')}
    Sleep    2
    Connect To Session
    Sleep    2
    Open Connection    ${symvar('server')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('user_name')}
    Sleep    2
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{password}
    Sleep    2
    Send Vkey    0
    
Transaction Validation
    FOR    ${tcode}    IN    @{t-codes}    
        Run Transaction    ${tcode}
        Sleep    2
        
        ${text}    Log To Console    wnd[0]/sbar/pane[0]
        # Log To Console    ${text}

        IF  '${text}' == 'Transaction does not exist'
            ${status}=    Get Value    wnd[0]/sbar/pane[0]
            Log To Console    ${status}
            Take Screenshot    
            Sleep    2
        ELSE
            ${title}    Get Value    wnd[0]/titl
            Log To Console    Currently you are in the Window of : ${title}
            Take Screenshot
            Sleep    2
        END
    END

SAP Logout
    TRY
        Run Transaction    /nex
        Sleep    2
    EXCEPT
        Log To Console    Error occurred while trying to exit
        Take Screenshot
        Sleep    2
    END
    


