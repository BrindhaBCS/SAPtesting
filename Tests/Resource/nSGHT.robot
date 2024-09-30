*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process

*** Variables ***

${Submit}    wnd[0]/tbar[0]/btn[0]
@{t-codes}    /nSGHT    /nSM14   
@{t-codees}    /nAGHT    /nSTMS 

*** Keywords ***
START
    Start Process    ${symvar('sap_server')}
    Sleep    2
    Connect To Session
    Sleep    2
    Open Connection    ${symvar('server')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('user_name')}
    Sleep    2
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('password')}
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[0]
    Sleep    2
    Multiple logon Handling     wnd[1]    wnd[1]/usr/radMULTI_LOGON_OPT2    wnd[1]/tbar[0]/btn[0]
    Sleep   1


nSGHT_transaction

    FOR    ${tcode}    IN    @{t-codes}    @{t-codees}

        Run Transaction    ${tcode}
        Sleep    1
        ${prefix_length}=    Get Length    /n      #2  /nsghst
        # Log To Console    ${prefix_length}
        # python slicing syntax:    string[start:end]
        ${cleaned_string}=    Evaluate    "${tcode}[${prefix_length}:]"
        ${status}    Get Value    wnd[0]/sbar/pane[0]


        IF  '${status}' == 'Transaction ${cleaned_string} does not exist'
            Log To Console    ${status}
            # Log To Console    **gbStart**status_of_tcode**splitKeyValue**${status}**gbEnd**
            Take Screenshot    
            Sleep    2
        ELSE
            ${title}    Get Value    wnd[0]/titl
            # Log To Console    **gbStart**title_of_window**splitKeyValue**${title}**gbEnd**
            Log To Console    Currently you are in the Window of : ${title}
            Take Screenshot
            Sleep       2
        END
    
    END
    
stop
    Run Transaction    /nex
    Sleep    2
    