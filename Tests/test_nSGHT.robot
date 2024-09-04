*** Settings ***
Resource    ../Tests/Resource/nSGHT.robot
Test Tags    nSGHT

*** Test Cases ***
start
    start

nSGHT
    nSGHT_transaction

stop 
    stop