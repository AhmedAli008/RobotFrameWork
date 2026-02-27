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
${SSCC_Num}     2
${SGTIN_Num}    3

*** Test Cases ***
Pack And Unpack Child
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    Auto Accept    ${Name}
    Pack By Aggregation
    Unpack By Child
    Sleep    3s
    [Teardown]  Close Browser