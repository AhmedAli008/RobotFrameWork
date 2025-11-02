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
${SSCC Num}    2
${SGTIN Num}    3

*** Test Cases ***
POS SSCC
    Login Page    ${ENV}    ${UserName}    ${Password}
    Sleep    2s
    ${Name}    Add Shipment File    ${ENV}    ${UserName}    ${Password}    ${SSCC Num}    ${SGTIN Num}
    Auto Accept    ${Name}
    Dispance SSCC    ${ENV}   
    [Teardown]  Close Browser 
