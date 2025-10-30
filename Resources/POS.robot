*** Settings ***
Library    SeleniumLibrary
Library    ../API/POS_Scan.py
Variables    ../API/Token_SSCC_Permit_Num.py

*** Keywords ***
Dispance SSCC
    [Arguments]    ${ENV}
    Sleep    2s
    Open POS
    Scan SSCC    ${ENV}
    Sleep    2s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    2s
    Submit POS

Dispance SGTIN
    [Arguments]    ${ENV}
    Sleep    2s
    Open POS
    Scan SGTIN    ${ENV}
    Sleep    2s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    2s
    Submit POS
Open POS
    Click Element    id=point-of-sale

Scan SSCC
    [Arguments]    ${ENV} 
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Scan POS   ${ENV}    ${value}
    END 

Scan SGTIN
    [Arguments]    ${ENV}
    FOR    ${key}    ${value}    IN    &{data_SGTIN}
        Scan POS   ${ENV}    ${value}
    END 
Submit POS
    Click Button    xpath=//button[contains(text(),'Submit')]
