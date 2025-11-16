*** Settings ***
Library     SeleniumLibrary
Resource    ../../../Resources/Login_Page.robot
Resource    ../../../Resources/Add_Shipment_File.robot
Resource    ../../../Resources/Inbound_Order.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${SSCC_Num}     2
${SGTIN_Num}    4

*** Test Cases ***
Mixed Items
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    2s
    ${Name}   Add Mixed Shipment File   ${ENV}  ${UserName}   ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    ${Doc.No}    Random String
    ${Qty Num}    Evaluate     ${SSCC_Num}*${SGTIN_Num}
    Create Mixed Inbound Order      ${data['supplier_to_add_shipment_file']}    ${Doc.No}    ${Qty Num}
    Scan Inbound Order     ${Doc.No}    ${ENV}    ${UserName}
    [Teardown]  Close Browser