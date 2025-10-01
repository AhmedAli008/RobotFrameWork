*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Inbound_Adhoc.robot
Resource    ../Resources/Outbound_Adhoc.robot
Resource    ../Resources/Blind_Receive.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${GLN_Supplier}  6285125000027

*** Test Cases ***
#Update
Blind Receive and Inbound Outbound Adhoc
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    Get Payload To Add File    ${ENV}    ${UserName}    ${Password}
    Blind Receive   ${ENV}   ${GLN_Supplier}
    Sleep    3s
    Inbound Adhoc   ${ENV}      ${GLN_Supplier}
    Outbound Adhoc  ${ENV}