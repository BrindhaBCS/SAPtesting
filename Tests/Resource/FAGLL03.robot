*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
 
 
 
*** Keywords ***
System Logon
    Start Process    ${symvar('GR_IR_SERVER')}
    Connect To Session
    Open Connection     ${symvar('GR_IR_Connection')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('GR_IR_Client')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('GR_IR_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('GR_IR_PASSWORD')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{GR_IR_PASSWORD}
    Send Vkey    0  
    ${logon_status}    Multiple logon Handling     wnd[1]
    IF    '${logon_status}' == "Multiple logon found. Please terminate all the logon & proceed"
        Log To Console    **gbStart**Sales_Document_status**splitKeyValue**${logon_status}**gbEnd**

    END
System Logout
    Run Transaction   /nex
    Sleep    5
FAGLL03
    Run Transaction    /nFAGLL03
    Sleep   2
    Input Text    wnd[0]/usr/ctxtSD_SAKNR-LOW    13110101
    Sleep   2
    Input Text    wnd[0]/usr/ctxtSD_BUKRS-LOW    Bc01
    Sleep   2
    Input Text    wnd[0]/usr/ctxtPA_VARI    /GRIR_TEST
    Sleep   2
    Set Focus    wnd[0]/usr/ctxtPA_VARI
    Sleep   2
    Click Element   wnd[0]/tbar[1]/btn[8]
    Sleep   2
    Click Element   wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep   2
    Click Element   wnd[1]/tbar[0]/btn[20]
    Sleep   2
    Delete Specific File    C:\\TEMP\\GR_IR.xlsx
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    GR_IR.xlsx
    Input Text      wnd[1]/usr/ctxtDY_PATH      ${EMPTY}
    Input Text      wnd[1]/usr/ctxtDY_PATH      ${download_path}
    # Input Text    wnd[1]/usr/ctxtDY_FILENAME  GR_IR1.xlxs
    # Sleep 2
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   2
 
    ${json}    Excel To Json New    excel_file=C:\\TEMP\\GR_IR.xlxs    json_file=C:\\TEMP\\GR_IR.json
    ${proper_json}    Output Proper Json    ${json}
    log to console    **gbStart**document_selection**splitKeyValue**${proper_json}**splitKeyValue**object**gbEnd**