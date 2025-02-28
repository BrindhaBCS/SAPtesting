*** Settings ***
Resource    ../Tests/Resource/File_Olympus.robot
Test Tags    Olympus_file
Suite Setup    File_Olympus.System Logon
Suite Teardown    File_Olympus.System Logout

*** Test Cases ***
Executing Olympus File OS 
    Executing Olympus File OS

Executing Olympus File Defn Variables
    Executing Olympus File Defn Variables

Executing Olympus File Name
    Executing Olympus File Name

Executing Olympus File Path
    Executing Olympus File Path

Executing Olympus File Syntax
    Executing Olympus File Syntax