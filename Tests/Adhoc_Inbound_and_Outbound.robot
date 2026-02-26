*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Inbound_Adhoc.robot
Resource    ../Resources/Outbound_Adhoc.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${SSCC_Num}     2
${SGTIN_Num}    3

*** Test Cases ***
Adhoc Inbound And Outbound
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    Inbound Adhoc   ${data['supplier_to_add_shipment_file']}
    Outbound Adhoc
    Sleep    3s
    [Teardown]  Close Browser