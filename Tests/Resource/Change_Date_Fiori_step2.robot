*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
*** Variables ***
${FIORI_URL}    https://ts4hana2022.sap.symphony4sap.com:44301/sap/bc/ui2/flp?sap-client=001&sap-language=EN
${BROWSER}    CHROME

*** Keywords ***
Fiori_Login
    Open Browser    ${FIORI_URL}    ${BROWSER}
    Sleep    1
    Maximize Browser Window
    Input Text    name:sap-user    ${symvar('Fiori_LaunchPad_UserName')}
    Sleep    1
    # Input Password    name:sap-password    ${symvar('Fiori_LaunchPad_UserPassword')}    
    Input Password    name:sap-password    %{Fiori_LaunchPad_UserPassword}
    Sleep    1
    Click Element    xpath://button[normalize-space(text())='Log On']
    Sleep    10
    ${index_c}    Set Variable    1
    WHILE    True
        ${xpath}    Set Variable    (//div[@class='sapMGTHdrContent OneByOne'])[${index_c}]
        ${status}    Run Keyword And Return Status    Click Element    xpath=${xpath}
        Sleep    3
        Run Keyword If    '${status}' == 'False'    Exit For Loop
        Take Screenshot    Catalog_${index_c}.png
        Sleep    2
        Run Keyword And Ignore Error    Go Back
        Sleep    2
        Run Keyword And Ignore Error    Click Element    id:backBtn
        Sleep    3
        ${index_c}    Evaluate    ${index_c}+1
    END

    