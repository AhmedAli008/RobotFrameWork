*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/View_Data.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${NUM}    10000

*** Test Cases ***
Auto Accept And Auto Ship Out sGTIN
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File sGTIN   ${ENV}  ${UserName}   ${Password}    ${NUM}
    View Data    ${Name}
    Sleep    3s
    #[Teardown]  Close Browser