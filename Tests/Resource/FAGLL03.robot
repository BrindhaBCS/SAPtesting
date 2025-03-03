*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    multiple_selection.py
 
*** Variables ***
${download_path}    C:\\TEMP\\
${excel_path}    C:\\TEMP\\rental.xlsx
${excel_sheet}    Sheet1
 
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
    ${logon_status}    Multiple logon Handling     wnd[1]   wnd[1]/usr/radMULTI_LOGON_OPT2
    IF    '${logon_status}' == "Multiple logon found. Please terminate all the logon & proceed"
        Log To Console    **gbStart**Sales_Document_status**splitKeyValue**${logon_status}**gbEnd**

    END
System Logout
    Run Transaction   /nex
    Sleep    5
FAGLL03
    Run Transaction    /nFAGLL03
    Sleep   2
    Input Text      wnd[0]/usr/ctxtSD_BUKRS-LOW     ${symvar('GR_IR_Company_Code')}
    ### Delete Specific files
    Delete Specific File    ${symvar('download_path')}\\GL_Account.txt

    ### GL account Number logic (copy to clipboard)
    Click Element       wnd[0]/usr/btn%_SD_SAKNR_%_APP_%-VALU_PUSH
    Get Column Excel To Text Create    C:\\tmp\\GRIR_Requirement.xlsx   C:\\tmp\\GL_Account.txt     G/L     GL Account
    Click Element   wnd[1]/tbar[0]/btn[23]
    Input Text    wnd[2]/usr/ctxtDY_PATH    C:\\tmp\\
    Input Text    wnd[2]/usr/ctxtDY_FILENAME    GL_Account.txt
    Click Element    wnd[2]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep   2
    ###

    # Click Element   wnd[1]/tbar[0]/btn[8]
    # Sleep   2
    Select Radio Button     wnd[0]/usr/radX_OPSEL
    Sleep   2
    Click Element   wnd[0]/tbar[1]/btn[8]

    ### Layout changes
    Click Element   wnd[0]/tbar[1]/btn[32]
    Click Element   wnd[1]/usr/btnAPP_FL_ALL
    FOR     ${layout}   IN      @{symvar('GR_layout')}
        Click Element   wnd[1]/usr/btnB_SEARCH
        Input Text      wnd[2]/usr/txtGD_SEARCHSTR      ${layout}
        Click Element   wnd[2]/tbar[0]/btn[0]
        Click Element   wnd[1]/usr/btnAPP_WL_SING    
    END
    Click Element   wnd[1]/tbar[0]/btn[0]

    ### File download
    Sleep   2
    Delete Specific File    ${symvar('download_path')}\\${symvar('fagll03_file')}
    Click Element   wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep   2
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   2
    Input Text      wnd[1]/usr/ctxtDY_FILENAME      ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${symvar('fagll03_file')}
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
    Input Text      wnd[1]/usr/ctxtDY_PATH      ${symvar('download_path')}
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   2

