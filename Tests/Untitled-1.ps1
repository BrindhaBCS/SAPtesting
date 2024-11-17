*** Settings ***
Library    SikuliLibrary    
Library    SeleniumLibrary

Resource    ../Web/Support_Web.robot

*** Variables ***
${TALLY_EXE}        C:\\Program Files\\TallyPrime\\tally.exe    
${Continue in educational mode}         C:\\Tally\\Screenshots\\continue_in_educational_mode.png
${Create Company}    C:\\Tally\\Screenshots\\Create Company.png
${Close Select Company}        C:\\Tally\\Screenshots\\Close Select Company.png
${Exchange}   C:\\Tally\\Screenshots\\Exchange.png
${Quit}          C:\\Tally\\Screenshots\\Quit.png
 
*** Keywords ***

Open Chrome      ##Disabled for now##
    Sleep    2s
    Right Click    C:\\Tally\\Screenshots\\Chrome.png
    Click  C:\\Tally\\Screenshots\\Open.png

Open Tally and Navigate to Menu
    Open Application    ${TALLY_EXE} 
    Sleep    20s
    Capture Screen

    Wait For Image    ${Continue in educational mode}    0.8    5
    Double Click    ${Continue in educational mode}  ## Not sure where it is clicking, but Continue in educational mode was clicked##
    SikuliLibrary.Get Text    ${Continue in educational mode}
    Press Special Key    ENTER 

    Set Ocr Text Read    Create Company    
    Double Click    ${Create Company}    ## Instead of clicking Create company, it clicked the text "UP" ##

    Double Click    ${Close Select Company}     # It didn't clicked close icon in select company banner #
    Click    ${Close Select Company}

    Wait For Image    ${Exchange}    0.7    5    # It didn't clicked Exchange icon as well #
    Click    ${Exchange}

        