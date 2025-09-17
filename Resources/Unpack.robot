*** Settings ***
Library     SeleniumLibrary
Library     ../API/UnPack_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Keywords ***
Unpack By Parent
    [Arguments]     ${ENV}  ${Username}  ${Parent}
    Sleep    2s
    Go To Home
    Open UnPack Screen
    Unpack By Parent To Scan    ${ENV}    ${Username}    ${Parent}
    Sleep    3s
    Execute JavaScript    document.body.style.zoom='70%'
    Submit Unpack By Parent

Unpack By Child
    [Arguments]     ${ENV}  ${Username}
    Sleep    2s
    Go To Home
    Open UnPack Screen
    Sleep    2s
    Select Unpack By Child
    Unpack By Child To Scan    ${ENV}    ${Username}    ${data['parent1_to_scan']}
    Sleep    3s
    Execute JavaScript    document.body.style.zoom='70%'
    Submit Unpack By Child
    

Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]

Open UnPack Screen
    Sleep    1s
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[7]/div/button

Select Unpack By Child
    Click Button    id=full-width-tab-1
Submit Unpack
    Click Button    xpath=//button[contains(text(), 'Submit')]