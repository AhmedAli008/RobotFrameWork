*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Auto_Accept.robot
Resource    ../Resources/Auto_Ship_Out.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd

*** Test Cases ***
Auto Accept And Auto Ship Out
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    4s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}
    Auto Accept    ${Name}
    Auto Ship Out    ${Name}
    Sleep    3s
    #[Teardown]  Close Browser