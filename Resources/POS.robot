*** Settings ***
Library    SeleniumLibrary
Library    ../API/POS_Scan.py
Variables    ../API/Token_SSCC_Permit_Num.py

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
    Sleep    2s
Open POS
    Click Element    id=point-of-sale

Scan SSCC
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        #Scan POS   ${ENV}    ${value}
        Input Text    id=test-scan-field    ${value}
        Click Button    xpath=//button[contains(text(),'Test Scan')]
    END 

Scan SGTIN
    FOR    ${key}    ${value}    IN    &{data_SGTIN}
        #Scan POS   ${ENV}    ${value}
        Input Text    id=test-scan-field    ${value}
        Click Button    xpath=//button[contains(text(),'Test Scan')]
    END 
Submit POS
    Click Button    xpath=//button[contains(text(),'Submit')]
