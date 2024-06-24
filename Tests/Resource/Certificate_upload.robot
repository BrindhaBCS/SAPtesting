*** Settings ***
Library    SeleniumLibrary
Library  OperatingSystem
Library    collections


*** Variables ***
${file_path}    ${CURDIR}\\${symvar('filename')}


*** Keywords ***
Browser Login
    Open Browser    ${symvar('CPI_URL')}    ${symvar('browsertype')}    options=add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    Sleep    5
    Input Text    id:j_username    ${symvar('username')}    
    Sleep    2
    Click Element    xpath://*[@id="logOnFormSubmit"]
    Sleep    10
    Scroll Element Into View    xpath://*[@id="password"]
    Sleep    2
    Input Password    xpath://*[@id="password"]    ${symvar('password')}  
    Sleep    2
    Scroll Element Into View    xpath://button[@class='uid-login-as__submit-button test-button ds-button ds-button--primary' and text()='Sign in']
    Sleep     2    
    Click Element    xpath://button[@class='uid-login-as__submit-button test-button ds-button ds-button--primary' and text()='Sign in']
    Sleep    20
    ${Title}    Get Location
    Set Global Variable    ${Title}
    Log To Console    ${Title}    
Window_Handling 
    Wait Until Element Is Visible    xpath://span[text()='Integration Suite']    60s
    Sleep    2
    Click Element    xpath://span[@class='sapMText sapTntNavLIText sapMTextNoWrap' and text()='Monitor']
    Sleep    2
    Click Element    xpath://a[@id='monitoring-a']//span[@class='sapMText sapTntNavLIText sapMTextNoWrap'][normalize-space()='Integrations and APIs']
    Sleep    10
    Go To    ${symvar('CPI_URL')}
    Sleep    20
    Upload_Certificate

Upload_Certificate
    Sleep    10
    Press Keys    xpath://bdi[normalize-space()='Add']    ENTER
    Sleep    2
    Input Text    id:txtAlias-inner    $Alias
    Sleep    2
    Choose File    id:CertificateUploadDialog-FileSelectionEntry-fu    ${file_path}    
    Sleep    5
    Capture Page Screenshot  
    Sleep    2
    Input Text    id:CertificateUploadDialog-FileSelectionEntry-fu    ${file_path}    
    Sleep    2
    Capture Page Screenshot  
    Sleep    2
    Click Element    xpath://bdi[@id='btnDeploy-BDI-content']
    Sleep    2

Uploading Certificate into SAP
    IF    '${Title}' == '${symvar('CPI_URL1')}'
        Window_Handling
    ELSE
        Upload_Certificate
    END

Browser Logout
    Close All Browsers
