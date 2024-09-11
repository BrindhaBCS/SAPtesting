*** Settings ***
# Library    Selenium2Library
Library    SeleniumLibrary
Library  Process

*** Variables ***
${autoit_script}  C:\\autoit\\opencertv3.exe
${file_path}    c:\\symphony.cer

*** Keywords ***
System Logon
    Open Browser    ${symvar('java_neturl')}    ${symvar('browsertype')}    options=add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    Sleep    1
    Click Element    ${symvar('click_SAPNet_Weaver_Administrator')}
    Sleep    5
    Switch Window    NEW
    Sleep    3
    login
login
    Input Text    ${symvar('username_field')}    ${symvar('username')}    
    Sleep    1
    Input Password    ${symvar('password_field')}    ${symvar('password')}  
    Sleep    1
    Click Button    ${symvar('Login_button')}
    Sleep    1
    ${con}=    Run Keyword And Return Status    Get Title
    Run Keyword If    '${con}' == 'FAIL'    Log    Failed to get title    ELSE    Log    Title: ${con}
Import SSL certificate
    Input Text    ${symvar('search_field')}    keys
    Sleep    2
    Click Element    ${symvar('Go_button')}
    Sleep    3
    Click Element    xpath://span[text()='Key Storage']
    Sleep    2
    Click Element    xpath://span[text()='ICM_SSL_70915']
    Sleep    5
    Click Element    xpath://div[@title='Import entry from file']
    Sleep    5
    Select Frame    id:URLSPW-0
    Sleep    2
    Click Button    xpath://*[@id="CEPJICNKCBKI.ImportEntry.DropDownByIndex1"]
    Sleep    3
    Click Element    xpath://div[text()='X.509 Certificate']
    Sleep    3
    #Click Element    xpath://html/body/table/tbody/tr/td/div/div[1]/div/div[3]/table/tbody/tr/td/div/div/table/tbody/tr[3]/td/div/div/table/tbody/tr/td[2]/form/input
    Sleep    2
    # Wait for the file input element to be visible and enabled
    Wait Until Element Is Visible    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    10s
    Wait Until Element Is Enabled    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    10s
    Capture Page Screenshot    filename=before_click.png
    # Attempt to click the file input element using JavaScript
     
    #Execute JavaScript    var element = document.getElementById('CEPJICNKCBKI.ImportEntry.CertPart_FileUpload'); var rect = element.getBoundingClientRect(); var x = rect.left + (rect.width / 2); var y = rect.top + (rect.height / 2); window.scrollTo(0, y); element.click();
    Sleep    2
    # Run the AutoIT script to handle the Open File dialog
    # Run the AutoIT script to handle the Open File dialog
    #${result}    Run Process    ${autoit_script}    timeout=15s
    # Check if the process completed successfully or handle timeout
    #Run Keyword If    '${result.rc}' != '0'    Log    AutoIT script did not complete in time. Continuing test...
    #Capture Page Screenshot    filename=after_autoit.png
    #Sleep    2
    #Execute JavaScript    document.getElementById('CEPJICNKCBKI.ImportEntry.CertPart_FileUpload').click();
        # Attempt to click the file input element
    #Click Element    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload
    Choose File    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    ${CURDIR}/symphony.cer
    #Execute JavaScript    document.getElementById('CEPJICNKCBKI.ImportEntry.CertPart_FileUpload').dispatchEvent(new Event('change'));
    #     Run the AutoIT script to handle the file upload dialog
    ##${file_path}    Set Variable    C:\\Users\\BCS_TEST\\Downloads\\symphony4sap.com
    
    #Sleep    3
    #Run Process    ${autoit_script}    timeout=15s
    #${result}    Run Process    ${autoit_script}    timeout=15s
    # Check if the process completed successfully or handle timeout
    #Run Keyword If    '${result.returncode}' != '0'    Log    AutoIT script did not complete in time. Continuing test...
    #Capture Page Screenshot    filename=after_autoit.png
    #Capture Page Screenshot
    #Sleep    2
    #Execute JavaScript    document.getElementById('CEPJICNKCBKI.ImportEntry.CertPart_FileUpload').click();
       
    #${symvar('file_path')}
    # Input Text    id=CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    ${file_path}
    #Capture Page Screenshot
    #Sleep    2
    #Choose File    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload)    ${file_path}
    Capture Page Screenshot
    Sleep    3
    ##Click Button    xpath://*[@id="CEPJICNKCBKI.ImportEntry.DropDownByIndex1"]
     Capture Page Screenshot    filename=before_file_upload.png
    # Use JavaScript to set the file input value and trigger change event
    Input Text    id:CEPJICNKCBKI.ImportEntry.CertPart_FileUpload    ${file_path}
    Capture Page Screenshot    filename=after_file_upload.png
    # Wait until the Import button is visible and enabled
    Wait Until Element Is Visible    id:CEPJICNKCBKI.ImportEntry.ButtonImport    10s
    Wait Until Element Is Enabled    id:CEPJICNKCBKI.ImportEntry.ButtonImport    10s
    # Click the Import button
    Click Element    id:CEPJICNKCBKI.ImportEntry.ButtonImport
    Sleep    2
    Capture Page Screenshot
    Sleep    4
    Capture Page Screenshot
    Sleep    4


