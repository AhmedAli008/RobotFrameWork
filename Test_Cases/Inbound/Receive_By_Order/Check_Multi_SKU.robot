*** Settings ***
Library     SeleniumLibrary
Resource    ../../../Resources/Login_Page.robot
Resource    ../../../Resources/Add_Shipment_File.robot
Resource    ../../../Resources/Inbound_Order.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${SSCC_Num}     3
${SGTIN_Num}    3

*** Test Cases ***
Check Multi SKU
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    2s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    ${Doc.No}    Random String
    ${Qty Num}    Evaluate     ${SSCC_Num}*${SGTIN_Num}
    Create Inbound Order Multi SKU      ${data['supplier_to_add_shipment_file']}    ${Doc.No}    ${Qty Num}
    Scan Inbound Order Multi SKU     ${Doc.No}    ${ENV}    ${UserName}
    [Teardown]  Close Browser