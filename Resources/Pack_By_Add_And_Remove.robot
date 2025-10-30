*** Settings ***
Library     SeleniumLibrary
Library     ../API/Pack_By_Add.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Variables ***


*** Keywords ***
Pack By Add
    [Arguments]     ${ENV}  ${Username}
    Open Pack Screen
    Select Pack By Add Tag
    Pack By Add To Scan    ${ENV}    ${Username}    ${data['parent1_to_scan']}
    Pack By Add To Scan    ${ENV}    ${Username}    ${data['parent2_to_scan']}
    Pack By Add To Scan    ${ENV}    ${Username}    ${data['parent3_to_scan']}
    Reload Page
    Sleep    3s
    ${SSCC after Pack}    Submit Pack By Add
    RETURN  ${SSCC after Pack}



Open Pack Screen
    Sleep    1s
    Click Element    id=logistic-operations
    Click Element    id=pack
    
Select Pack By Add Tag
    Sleep    3s
    Click Button    id=full-width-tab-2