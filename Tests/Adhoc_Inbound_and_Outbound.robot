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

*** Test Cases ***
Adhoc Inbound And Outbound
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    2s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}
    Inbound Adhoc   ${ENV}
    Outbound Adhoc  ${ENV}
    Sleep    3s
    #[Teardown]  Close Browser