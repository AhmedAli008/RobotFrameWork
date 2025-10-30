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
${SSCC Num}    2
${SGTIN Num}    3
*** Test Cases ***
#Update
Blind Receive and Inbound Outbound Adhoc
    Login Page   ${ENV}   ${UserName}     ${Password}
    ${SSCC_Num}    Convert To Integer    ${SSCC_Num}
    ${SGTIN_Num}    Convert To Integer    ${SGTIN_Num}
    Sleep    2s
    Get Payload To Add File    ${ENV}    ${UserName}    ${Password}    ${SSCC Num}    ${SGTIN Num}
    Blind Receive   ${ENV}   ${GLN_Supplier}    ${SGTIN Num}
    Sleep    3s
    Inbound Adhoc   ${ENV}      ${GLN_Supplier}
    Outbound Adhoc  ${ENV}