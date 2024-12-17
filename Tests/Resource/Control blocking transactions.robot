*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Replace}    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[11]
${Execute}    wnd[0]/tbar[1]/btn[8]
${BACK}    wnd[0]/tbar[0]/btn[3]
# ${Req_Result_Filename}    Control blocking transactions.xls


*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
System Logout
    Run Transaction   /nex
  




Control blocking transactions
    Run Transaction    /nSM01_CUS
    Sleep    2
    Take Screenshot    Control_blocking_transactions1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_blocking_transactions2.jpg
    Log To Console    Control blocking transactions completed
Generate report
    Image Resize    ${OUTPUT_DIR}
    Sleep    2
    Copy Images    ${OUTPUT_DIR}    ${symvar('MCR_Resized_Images_directory')}
    Sleep    1
    

    