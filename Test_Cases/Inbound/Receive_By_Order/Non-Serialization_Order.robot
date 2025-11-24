*** Settings ***
Library     SeleniumLibrary
Resource    ../../../Resources/Login_Page.robot
Resource    ../../../Resources/Add_Shipment_File.robot
Resource    ../../../Resources/Inbound_Order.robot
Resource    ../../../Resources/Inbound_Order_NonSerialize.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${GLN_Supplier}  6285125000027
${SSCC_Num}     3
${SGTIN_Num}    3

*** Test Cases ***
Non Serialization Inbound Order
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    2s
    ${SSCC_Num}    Convert To Integer    ${SSCC_Num}
    ${SGTIN_Num}    Convert To Integer    ${SGTIN_Num}
    Get Payload To Add File    ${ENV}    ${UserName}    ${Password}    ${SSCC Num}    ${SGTIN Num}
    ${Doc.No}    Random String
    ${Qty Num}    Evaluate     ${SSCC_Num}*${SGTIN_Num}
    Create Inbound Order     ${GLN_Supplier}    ${Doc.No}    ${Qty Num}
    Non Serialize    ${Doc.No}    ${Qty Num}
    [Teardown]  Close Browser