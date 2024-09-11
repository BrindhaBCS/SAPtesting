*** Settings ***
Resource    ../Tests/Resource/SAP_Portal.robot
Suite Setup    SAP_Portal.login page
Suite Teardown    SAP_Portal.close
Test Tags    SAP_Portal

*** Test Cases ***
Installation
    Installation
    System_id
    Filtering
    Edit
    Generate
    Show Filter Bar
    Download License Key
