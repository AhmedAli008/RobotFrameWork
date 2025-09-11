*** Settings ***
Library     SeleniumLibrary
Library     ../API/Add_Shipment_File_From_CT.py


*** Variables ***
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[3]/div/button
${Wait_Time}    10s
${Page_Load_In_Shipment}    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]

*** Keywords ***
Add Shipment File
    [Arguments]     ${ENV}     ${Username}     ${Password}
    Wait Until Page Contains Element   ${Selector}
    Open Shipment File
    Wait Until Page Contains Element    ${Page_Load_In_Shipment}
    ${Name}    Add Shipment File Fetch File Name   ${Env}     ${Username}     ${Password}
    Sleep    1s
    Reload Page
    RETURN  ${Name}


Open Shipment File
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[3]/div/button

