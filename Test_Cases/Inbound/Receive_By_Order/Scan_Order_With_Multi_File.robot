*** Settings ***
Library     SeleniumLibrary
Library    Collections
Resource    ../../../Resources/Login_Page.robot
Resource    ../../../Resources/Add_Shipment_File.robot
Resource    ../../../Resources/Inbound_Order.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${SSCC_Num}     2
${SGTIN_Num}    4
&{Update Data SSCC}    

*** Test Cases ***
Scan Order With Multi Files
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    2s
    Add Shipment File   ${ENV}  ${UserName}   ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    &{Update Data SSCC}    Copy Dictionary    ${data_SSCC}
    ${SSCC_Num}    Convert To Integer    ${SSCC_Num}
    ${SGTIN_Num}    Convert To Integer    ${SGTIN_Num}
    Add Shipment File Fetch File Name    ${ENV}    ${UserName}    ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    ${index}   Set Variable    1
    FOR    ${Value}    IN        @{Update Data SSCC.values()}    
        Set To Dictionary    ${data_SSCC}    SSCC_${index}=${Value}
        ${index}    Evaluate    ${index} + 1
    END
    Log    ${data_SSCC}
    Reload Page
    ${Doc.No}    Random String
    ${Qty Num}    Evaluate     ${SSCC_Num}*${SGTIN_Num}*2
    Create Inbound Order      ${data['supplier_to_add_shipment_file']}    ${Doc.No}    ${Qty Num}
    Scan Inbound Order     ${Doc.No}    ${ENV}    ${UserName}
    [Teardown]  Close Browser


