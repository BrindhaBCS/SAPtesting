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
    Sleep    20
    Scroll Element Into View    xpath://*[@id="password"]
    Sleep    2
    Input Password    xpath://*[@id="password"]    %{password}  
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

Close Notification 
    Click Element       //span[@id='__button19-img']
    Capture Page Screenshot

Notification Handling
    Sleep    5
    ${Status}=     Run Keyword And Return Status   Page Should Contain Element    id:__popover4-title-inner    
    Run Keyword If    '${Status}'=='True'    Close Notification            
    
Upload_Certificate
    Notification Handling
    Capture Page Screenshot
    Sleep    20
    # Press Keys    xpath://bdi[normalize-space()='Add']    ENTER
    # Capture Page Screenshot
    # Sleep    2
    # Input Text    id:txtAlias-inner    ${symvar('Alias')}
    # Capture Page Screenshot
    # Sleep    2

    # Input Text    xpath://input[@id='__component0---com.sap.it.op.web.ui.pages.keystore.KeystoreManagement--SEARCHFIELD_KEYSTORE-I']    ${symvar('Alias')}
    Input Text    id:__component0---com.sap.it.op.web.ui.pages.keystore.KeystoreManagement--SEARCHFIELD_KEYSTORE-I    ${symvar('Alias')}    
    Capture Page Screenshot  
    Sleep    3
    Notification Handling
    Sleep    2
    Scroll Element Into View    xpath://table[@id='__component0---com.sap.it.op.web.ui.pages.keystore.KeystoreManagement--KEYSTOREMANAGEMENT_TABLE_ID-listUl']
    Capture Page Screenshot  
    Sleep    5
    # Click Element    xpath://button[@aria-label='More' and @title='More' and contains(@class, 'sapMBtn')]
    Click Element    xpath://button[@title='More' and contains(@class, 'sapMBtn')]


    Capture Page Screenshot  
    Sleep    5
    Click Element    xpath://bdi[text()='Update']
    Capture Page Screenshot  
    Sleep    5
    Choose File    id:CertificateUploadDialog-FileSelectionEntry-fu    ${file_path}    
    Sleep    5
    Capture Page Screenshot  
    Sleep    3
    Input Text    id:CertificateUploadDialog-FileSelectionEntry-fu    ${file_path}    
    Capture Page Screenshot  
    Sleep    3
    Click Element    id:btnUpdate-BDI-content
    Sleep    2
    Capture Page Screenshot
    Sleep    5
    Confirm certificate
    Capture Page Screenshot

Confirm certificate
    ${Window}=     Run Keyword And Return Status   Page Should Contain Element    id:__mbox0-title-inner 
    Capture Page Screenshot   
    Run Keyword If    '${Window}'=='True'    Confirm Notification 
    Sleep    5
    Capture Page Screenshot
    
Confirm Notification
    Click Element       xpath://bdi[text()='Confirm']
    Capture Page Screenshot
    Sleep    5
    Capture Page Screenshot
    
Uploading Certificate into SAP
    IF    '${Title}' == '${symvar('CPI_URL1')}'
        Window_Handling
    ELSE
        Upload_Certificate
    END


Browser Logout
    Close All Browsers


