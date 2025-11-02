*** Settings ***
Library     SeleniumLibrary
Resource    ../Resources/Login_Page.robot
Resource    ../Resources/Add_Shipment_File.robot
Resource    ../Resources/View_Data.robot
Resource    ../Resources/Inbound_Adhoc.robot
Resource    ../Resources/Pack_By_Aggregation.robot
Resource    ../Resources/Unpack.robot
Resource    ../Resources/Outbound_Adhoc.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${NUM}    10

*** Test Cases ***
Upload and Adhoc Scan and Pack sGTIN
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    ${Name}   Add Shipment File sGTIN   ${ENV}  ${UserName}   ${Password}    ${NUM}
    View Data    ${Name}
    Sleep    3s
    Inbound Adhoc sGTIN    ${ENV}    ${data['supplier_to_add_shipment_file']}
    Pack By Aggregation sGTIN    ${ENV}
    Unpack By Child sGTIN    ${ENV}    ${UserName}
    Outbound Adhoc SGTIN    ${ENV}
    [Teardown]  Close Browser