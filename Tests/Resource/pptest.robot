*** Settings ***
Library    C:\Tally\SAPtesting\Tests\Resource\PywinautoSendKeyLibrary.py

*** Variables ***
${APP_PATH}    "C:\Program Files\TallyPrime\tally.exe"

*** Test Cases ***
Automate Tally with SendKeys
    [Documentation]    Opens Tally, navigates with keystrokes, and closes the application.
    Open Application    ${APP_PATH}
    Focus Window

    # Send keystrokes to navigate Tally menus and fields
    Send Keys    ^o  # Example: Sending Ctrl+O to open a menu
    Send Keys    My Company{TAB}12345678{ENTER}  # Example: Sending text with TAB and Enter

    # Close the application
    Close Application
