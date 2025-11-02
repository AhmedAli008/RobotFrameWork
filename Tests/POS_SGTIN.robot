*** Settings ***
Library    SeleniumLibrary
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Auto_Accept.robot
Resource    ../Resources/POS.robot

*** Variables ***
${ENV}
${UserName}    6251151000003_admin
${Password}    adminP@ssw0rd
${Num}    10

*** Test Cases ***
POS SGTIN
    Login Page    ${ENV}    ${UserName}    ${Password}
    Sleep    2s
    ${Name}    Add Shipment File sGTIN   ${ENV}    ${UserName}    ${Password}    ${Num}
    Auto Accept    ${Name}
    Dispance SGTIN    ${ENV}  
    [Teardown]  Close Browser  
    