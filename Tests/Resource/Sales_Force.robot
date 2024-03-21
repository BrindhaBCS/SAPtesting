
*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    PDF.py   
Library    Merge.py

*** Variables ***    
${order_no}        13029138
${screenshot_directory}     ${OUTPUT_DIR}
${PDF_Dir}    ${OUTPUT_DIR}\\03_Sales.pdf
# ${PDF_Dir}    C:\\RobotFramework\\SAPtesting\\Output\\Results\\03_Sales.pdf
# ${PDF_file}    C:\\RobotFramework\\SAPtesting\\Output\\Results
# ${mergedpdf}    ${OUTPUT_DIR}\\Merged.pdf

*** Keywords ***
Launch Sales Force
    Open Browser    ${symvar('Sales_URL')}    chrome
    Sleep    10s
    Maximize Browser Window
    Input Text    id:username    ${symvar('login_name')}    
    Input Password    id:password    %{login_password}
    Click Element     id:Login
    Capture Page Screenshot    21_Sales_login.jpg
    Sleep    10s

Document Search
    Click Button    //button[@class='slds-button slds-button_neutral search-button slds-truncate']
    Sleep    5s
    Input Text    //input[@placeholder='Search...']    ${symvar('order_no')}
    # Input Text    //input[@placeholder='Search...']    ${order_no}
    Capture Page Screenshot    22_Orderno_input.jpg
    Sleep    5s
    Press Keys   //input[@placeholder='Search...']    ENTER
    Sleep    2s    
    Click Element    //a[@data-special-link='true']
    Capture Page Screenshot    23_locate_hyperlink.jpg
    Sleep    2s
    Capture Page Screenshot    24_Document.jpg
    Sleep    2s

Close Sales Force
    Close All Browsers
    Create Pdf    ${screenshot_directory}   ${PDF_Dir}
    # Merge Pdfs In Folder    ${PDF_file}    ${mergedpdf}        
    Sleep   2

