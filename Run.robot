*** Settings ***
Library     SeleniumLibrary
Library     API/Generate_Json_File.py
Resource    Resources/Login_Page.robot
#Resource    Resources/Add_Shipment_File.robot
Resource    Resources/Inbound_Adhoc.robot
Resource    Resources/Outbound_Adhoc.robot
Resource    Resources/Auto_Accept.robot
Resource    Resources/Auto_Ship_Out.robot
Resource    Resources/Pack_By_Aggregation.robot
Resource    Resources/Pack_By_Add_And_Remove.robot
Resource    Resources/Unpack.robot
Resource    Resources/Decommission.robot
Resource    Resources/Blind_Receive_and_Accept.robot

*** Variables ***
${ENV}
${UserName}     6251151000003_admin
${Password}     adminP@ssw0rd
${GLN_Supplier}     6285125000027

*** Test Cases ***
Add File And Receive And Ship Out
    Login Page   ${ENV}   ${UserName}     ${Password}
    Sleep    1s
    #${Name}   Add Shipment File   ${ENV}  ${UserName}   ${Password}
    #Auto Accept    ${Name}
    #Auto Ship Out    ${Name}
    #Inbound Adhoc   ${ENV}
    #Outbound Adhoc  ${ENV}
    #${SSCC}     Pack By Aggregation    ${ENV}
    #Unpack By Parent    ${ENV}    ${UserName}    ${SSCC}
    #Pack By Aggregation    ${ENV}
    #Unpack By Child    ${ENV}    ${UserName}
    #Sleep    2s
    #${SSCC}     Pack By Add    ${ENV}    ${UserName}
    #Log    ${SSCC}
    #Scan To Decommission    ${ENV}    ${UserName}
    #Open Decommission
    #Scan To Decommission    ${ENV}    ${UserName}    ${SSCC}
    #Submit Decommission
    Get Payload To Add File    ${ENV}    ${UserName}    ${Password}
    Blind Receive   ${ENV}   ${GLN_Supplier}
    Sleep    3s
    Auto Accept    BlindReceive
    Sleep    10s
    [Teardown]  Close Browser
