*** Settings ***
Library     SeleniumLibrary
Library     ../API/UnPack_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py
Resource    Common_Keywords.robot

*** Keywords ***
Unpack By Parent
    [Arguments]    ${Parent}
    Sleep    3s
    Open UnPack Screen
    #Unpack By Parent To Scan    ${ENV}    ${Username}    ${Parent}
    Input Text    id=test-scan-field    ${Parent}
    Click Button    xpath=//button[contains(text(),'Test Scan')]
    Sleep    3s
    Execute JavaScript    document.body.style.zoom='70%'
    #Submit Unpack By Parent
    Submit Unpack

Unpack By Child
    Sleep    3s
    Open UnPack Screen
    Sleep    2s
    Select Unpack By Child
    #Unpack By Child To Scan    ${ENV}    ${Username}    ${data_SSCC['SSCC1']}
    Input Text    id=test-scan-field    ${data_SSCC['SSCC1']}
    Click Button    xpath=//button[contains(text(),'Test Scan')]
    Sleep    3s
    Execute JavaScript    document.body.style.zoom='70%'
    #Submit Unpack By Child
    Submit Unpack

Unpack By Child sGTIN
    Sleep    3s
    Open UnPack Screen
    Sleep    2s
    Select Unpack By Child
    #Unpack By Child To Scan    ${ENV}    ${Username}    ${data_SGTIN['SGTIN1']}
    Input Text    id=test-scan-field    ${data_SGTIN['SGTIN1']}
    Click Button    xpath=//button[contains(text(),'Test Scan')]
    Sleep    3s
    Execute JavaScript    document.body.style.zoom='70%'
    Reload Page
    Submit Unpack By Child


Open UnPack Screen
    Sleep    2s
    Wait And Click Element    id=logistic-operations
    Sleep    2s
    Wait And Click Element    id=unpack

Select Unpack By Child
    Safe Click Button    id=full-width-tab-1

Submit Unpack
    Safe Click Button    xpath=//button[contains(text(), 'Submit')]