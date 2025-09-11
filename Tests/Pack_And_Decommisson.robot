*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Auto_Accept.robot
Resource    ../Resources/Pack_By_Aggregation.robot
Resource    ../Resources/Decommission.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd

*** Test Cases ***
Pack And Decommission
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}
    Auto Accept    ${Name}
    ${SSCC}     Pack By Aggregation    ${ENV}
    Open Decommission
    Scan To Decommission    ${ENV}    ${UserName}    ${SSCC}
    Submit Decommission
    Sleep    3s
    #[Teardown]  Close Browser