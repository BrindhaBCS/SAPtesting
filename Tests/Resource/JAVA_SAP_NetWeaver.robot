*** Settings ***
Library    SeleniumLibrary
*** Variables ***
${file_path}    ${symvar('JAVA_SAP_NetWeaver_Filepath')}
*** Keywords ***
JAVA_SAP_NetWeaver
    Open Browser    ${symvar('JAVA_SAP_NetWeaver_URL')}    ${symvar('JAVA_SAP_NetWeaver_Browser')}    options=add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    xpath:/html/body/table/tbody/tr[5]/td[1]/a/img
    Wait Until Keyword Succeeds    1 minute    2s    Switch Window    NEW
    Wait Until Keyword Succeeds    1 minute    2s    Input Text    id:logonuidfield    ${symvar('JAVA_SAP_NetWeaver_Username')}    
    Wait Until Keyword Succeeds    1 minute    2s    Input Password    id:logonpassfield    %{JAVA_SAP_NetWeaver_Password}  
    Wait Until Keyword Succeeds    1 minute    2s    Click Button    name:uidPasswordLogon
    Sleep    1
    ${con}=    Run Keyword And Return Status    Get Title
    Run Keyword If    '${con}' == 'FAIL'    Log    Failed to get title    ELSE    Log    Title: ${con}
    Wait Until Keyword Succeeds    1 minute    2s    Input Text    id:CEPJ.IDPView.InputField1    keys
    Sleep    time_=0.1 seconds
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    id:CEPJ.IDPView.Button1
    Sleep    time_=0.1 seconds
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    xpath://span[text()='Key Storage']
    Sleep    time_=0.2 seconds
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    xpath://*[@id="CEPJICNKCBKI.KSViews.ViewTable:2147483641-r"]
    Sleep    time_=0.2 seconds
    Wait Until Keyword Succeeds    1 minute    2s    Input Text    xpath:(//label[contains(.,'Search')]/following::input)[2]    Expired
    Sleep    time_=0.2 seconds
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    xpath://*[@id="CEPJICNKCBKI.KSViews.ViewTable:2147483639"]
    Sleep    time_=0.2 seconds
    Wait Until Keyword Succeeds    1 minute    2s    Input Text    xpath:(//label[contains(.,'Search')]/following::input)[3]    SYSTEM
    Press Keys    None    ENTER
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    xpath:(//span[@class='lsTextView--root lsControl--valign'])[3]
    Sleep    time_=3 seconds
    Click Element    xpath://div[@title='Import entry from file']
    Sleep    time_=0.2 seconds
    Wait Until Keyword Succeeds    1 minute    2s    Select Frame    id:URLSPW-0
    Wait Until Keyword Succeeds    1 minute    2s    Click Button    xpath://*[@id="CEPJICNKCBKI.ImportEntry.DropDownByIndex1"]
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    xpath://div[text()='X.509 Certificate']  
    Wait Until Keyword Succeeds    1 minute    2s    Wait Until Element Is Visible    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    timeout=60s
    Wait Until Keyword Succeeds    1 minute    2s    Choose File    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    ${file_path}
    Wait Until Keyword Succeeds    1 minute    2s    Input Text    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    ${file_path}
    Capture Page Screenshot
    Wait Until Keyword Succeeds    1 minute    2s    Click Element    id:CEPJICNKCBKI.ImportEntry.ButtonImport
    Sleep    time_=0.2 seconds
    Capture Page Screenshot
    Sleep    5
    Capture Page Screenshot
    Sleep    3
