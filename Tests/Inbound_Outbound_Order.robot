*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Inbound_Order.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd

*** Test Cases ***
Adhoc Inbound And Outbound
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}
    Inbound Order    ${ENV}    ${data['supplier_to_add_shipment_file']}    ${UserName}