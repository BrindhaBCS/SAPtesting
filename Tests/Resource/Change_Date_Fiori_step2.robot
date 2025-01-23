
*** Settings ***
Library    SAP_Tcode_Library.py
*** Variables ***
${URL}    https://ts4hana2022.sap.symphony4sap.com:44301/sap/bc/ui2/flp?sap-client=001&sap-language=EN

*** Keywords ***
Fiori_Login
    # ${login}    Login To Sap Fiori_web_Page   ${URL}    ${symvar('Fiori_LaunchPad_UserName')}    ${symvar('Fiori_LaunchPad_UserPassword')}    
    ${login}    Login To Sap Fiori_web_Page   ${URL}    ${symvar('Fiori_LaunchPad_UserName')}    %{Fiori_LaunchPad_UserPassword}      
    Sleep    1
    Log To Console    ${login}
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

    