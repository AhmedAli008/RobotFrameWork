*** Settings ***
Library     SeleniumLibrary
Library     ../API/Decommission.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Keywords ***
Open Decommission
    Sleep    2s
    Go To Home
    Open Decommission Screen

Scan To Decommission
    [Arguments]     ${ENV}  ${Username}     ${SSCC To Scan}
    Decommission To Scan    ${ENV}  ${Username}     ${SSCC To Scan}

Submit Decommission
    Reload Page
    Execute JavaScript    document.body.style.zoom='80%'
    Sleep    2s
    Click Submit Decommission
    Confirm Decommission

Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]
    
Open Decommission Screen
    Sleep    1s
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[5]/div/button

Click Submit Decommission
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/button
    Sleep    2s
    
Confirm Decommission
    Click Element    id=reason
    Sleep    2s
    Click Element    xpath=//li[contains(text(),'Other')]
    Sleep    2s
    Click Button    xpath=//button[contains(text(),'Confirm')]