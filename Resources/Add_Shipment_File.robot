*** Settings ***
Library     SeleniumLibrary
Library     ../API/Add_Shipment_File_From_CT.py
Resource    Permit_Number.robot

*** Variables ***
${Selector}     id=logistic-operation
${Selector2}     id=files
${Wait_Time}    10s
${Page_Load_In_Shipment}    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]

*** Keywords ***
Add Shipment File
    [Arguments]     ${ENV}     ${Username}     ${Password}     ${SSCC_Num}    ${SGTIN_Num}
    ${SSCC_Num}    Convert To Integer    ${SSCC_Num}
    ${SGTIN_Num}    Convert To Integer    ${SGTIN_Num}
    Permit Number    ${Username}
    Sleep    3s
    #Wait Until Page Contains Element   ${Selector}
    #Wait Until Page Contains Element   ${Selector}
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
    Wait Until Page Contains Element   ${Selector}
    Open Shipment File
    Wait Until Page Contains Element    ${Page_Load_In_Shipment}
    ${Name}    Add Shipment File Sgtin Fetch File Name   ${Env}     ${Username}     ${Password}  ${NUM}
    Sleep    1s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    RETURN  ${Name}



Open Shipment File
    Click Element    id=logistic-operations
    Click Element    id=files

