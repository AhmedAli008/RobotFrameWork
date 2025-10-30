*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/Auto_Ship_Out.robot
Resource    ../Resources/Agent_Commissioning.robot

*** Variables ***
${ENV}
${UserName}     6297001303009_admin
${Password}     6297001303009_P@ssw0rd
${SSCC_Num}     2
${SGTIN_Num}    3

*** Test Cases ***
Agent Commissioning and Ship Out
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    Agent Commissioning    ${Name}
    Auto Ship Out    ${Name}
    Sleep    2s
    #[Teardown]  Close Browser