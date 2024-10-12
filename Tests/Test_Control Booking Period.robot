*** Settings ***
Resource    ../Tests/Resource/Control Booking Period.robot
Suite Setup    Control Booking Period.System Logon
Suite Teardown   Control Booking Period.System Logout
Test Tags    Control_Booking_Period

*** Test Cases ***
Control Booking Period
    Control Booking Period