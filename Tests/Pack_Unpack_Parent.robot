*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Auto_Accept.robot
Resource    ../Resources/Pack_By_Aggregation.robot
Resource    ../Resources/Unpack.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd

*** Test Cases ***
Pack And Unpack Child
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}
    Auto Accept    ${Name}
    ${SSCC}     Pack By Aggregation    ${ENV}
    Unpack By Parent    ${ENV}    ${UserName}    ${SSCC}
    Sleep    3s
    [Teardown]  Close Browser