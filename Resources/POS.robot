*** Settings ***
Library    SeleniumLibrary
Library    ../API/POS_Scan.py
Variables    ../API/Token_SSCC_Permit_Num.py
Resource    Common_Keywords.robot

*** Keywords ***
Dispance SSCC
    Sleep    2s
    Open POS
    Scan SSCC
    Sleep    2s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Submit POS
    Sleep    2s

Dispance SGTIN
    Sleep    2s
    Open POS
    Scan SGTIN
    Sleep    2s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Submit POS

Open POS
    Wait And Click Element    id=point-of-sale

Scan SSCC
    [Arguments]    ${ENV}
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Scan POS   ${ENV}    ${value}
    END

Scan SGTIN
    FOR    ${key}    ${value}    IN    &{data_SGTIN}
        Scan POS   ${ENV}    ${value}
    END

Submit POS
    Safe Click Button    xpath=//button[contains(text(),'Submit')]
