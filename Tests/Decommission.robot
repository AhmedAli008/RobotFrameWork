*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Auto_Accept.robot
Resource    ../Resources/Decommission.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd

*** Test Cases ***
Decommissin
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}
    Auto Accept    ${Name}
    Open Decommission
    Scan To Decommission    ${ENV}    ${UserName}    ${data['parent1_to_scan']}
    Scan To Decommission    ${ENV}    ${UserName}    ${data['parent2_to_scan']}
    Scan To Decommission    ${ENV}    ${UserName}    ${data['parent3_to_scan']}
    Submit Decommission
    Sleep    3s
    #[Teardown]  Close Browser