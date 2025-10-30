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
${SSCC_Num}     2
${SGTIN_Num}    3

*** Test Cases ***
Decommissin
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    Auto Accept    ${Name}
    Open Decommission
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Scan To Decommission    ${ENV}    ${UserName}    ${value}
    END 
    Submit Decommission
    Sleep    3s
    #[Teardown]  Close Browser