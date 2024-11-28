*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${File_location}    ${symvar('Excel_Filepath')}\\${symvar('Excel_FileName')}.xlsx

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Connect To Session
    Open Connection    ${symvar('Slicense_New_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Slicense_New_client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Slicense_New_user')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
   
System Logout
    Run Transaction   /nex

slicense_Lamda
    Create Empty Excel    file_path=${File_location}
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=A1    value=SID
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=B1    value=Hardware Key
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=C1    value=SW Product
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=D1    value=Limit
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=E1    value=Valid From
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=F1    value=Valid To
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=G1    value=Type
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=H1    value=Inst. No.
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=I1    value=System No.
    Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=J1    value=Note on Validity
    Run Transaction    transaction=/nslicense
    ${Row_Count}    Get Row Count    table_id=wnd[0]/usr/tabsTABSTRIP_1000/tabp${symvar('Excel_FileName')}_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL
    FOR    ${zy}    IN RANGE    0    ${Row_Count}
        ${a}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-SID[1,${zy}]
        ${b}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-HWKEY[2,${zy}]
        ${c}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-SW_PRODUCT[3,${zy}]
        ${d}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-SW_PROD_LIMIT[4,${zy}]
        ${e}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-BEGIN_DATE[5,${zy}]
        ${f}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-END_DATE[6,${zy}]
        ${g}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-TYPE_TEXT[7,${zy}]
        ${h}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-INSTALL_NO[8,${zy}]
        ${i}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-SYSTEM_NO[9,${zy}]
        ${j}    Get Value    element_id=wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-VALIDITY_TEXT[10,${zy}]
        IF  '${a}' == '___'
            Exit For Loop
        ELSE
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=A${zy+2}    value=${a}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=B${zy+2}    value=${b}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=C${zy+2}    value=${c}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=D${zy+2}    value=${d}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=E${zy+2}    value=${e}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=F${zy+2}    value=${f}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=G${zy+2}    value=${g}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=H${zy+2}    value=${h}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=I${zy+2}    value=${i}
            Write Value To Excel    file_path=${File_location}   sheet_name=${symvar('Excel_FileName')}    cell=J${zy+2}    value=${j}
        END
    END
    ${Excel_Json}    Excel To Json    excel_file=${File_location}    json_file=${symvar('Excel_Filepath')}\\${symvar('Excel_FileName')}.json
    Log To Console    **gbStart**Copilot_Status_json**splitKeyValue**${Excel_Json}**gbEnd**
    Delete Specific File    file_path=${File_location}
    Delete Specific File    file_path=${symvar('Excel_Filepath')}\\${symvar('Excel_FileName')}.json
