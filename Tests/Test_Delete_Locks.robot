*** Settings ***
Resource    ../Tests/Resource/Delete_Locks.robot
Force Tags   delete_locks
Suite Setup    Delete_Locks.System Logon
Suite Teardown    Delete_Locks.System Logout
 
*** Test Cases ***
Delete the lock by user details
    Delete Lock