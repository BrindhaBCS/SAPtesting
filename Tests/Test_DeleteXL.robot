*** Settings ***
Resource    ../Tests/Resource/DeleteXL.robot
Task Tags   DeleteXL

*** Test Cases ***
File deletion
    Delete Files In Directory
