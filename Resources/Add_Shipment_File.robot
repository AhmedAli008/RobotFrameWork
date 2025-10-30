*** Settings ***
Library     SeleniumLibrary
Library     ../API/Add_Shipment_File_From_CT.py
Resource    Permit_Number.robot

*** Variables ***
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[3]/div/button
${Wait_Time}    10s
${Page_Load_In_Shipment}    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]

*** Keywords ***
Add Shipment File
    [Arguments]     ${ENV}     ${Username}     ${Password}     ${SSCC_Num}    ${SGTIN_Num}
    ${SSCC_Num}    Convert To Integer    ${SSCC_Num}
    ${SGTIN_Num}    Convert To Integer    ${SGTIN_Num}
    Permit Number    ${Username}
    Sleep    2s
    Go To Home
    Sleep    2s
    Wait Until Page Contains Element   ${Selector}
    Open Shipment File
    Wait Until Page Contains Element    ${Page_Load_In_Shipment}
    ${Name}    Add Shipment File Fetch File Name   ${Env}     ${Username}     ${Password}    ${SSCC_Num}    ${SGTIN_Num}
    Sleep    1s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    RETURN  ${Name}

Add Shipment File sGTIN
    [Arguments]     ${ENV}     ${Username}     ${Password}    ${NUM}
    Permit Number    ${Username}
    Sleep    2s
    Go To Home
    Sleep    2s
    Wait Until Page Contains Element   ${Selector}
    Open Shipment File
    Wait Until Page Contains Element    ${Page_Load_In_Shipment}
    ${Name}    Add Shipment File Sgtin Fetch File Name   ${Env}     ${Username}     ${Password}  ${NUM}
    Sleep    1s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    RETURN  ${Name}


Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]

Open Shipment File
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[3]/div/button

