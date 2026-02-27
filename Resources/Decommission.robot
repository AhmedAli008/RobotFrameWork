*** Settings ***
Library     SeleniumLibrary
Library     ../API/Decommission.py
Variables   ../API/Token_SSCC_Permit_Num.py
Resource    Common_Keywords.robot

*** Keywords ***
Open Decommission
    Sleep    3s
    Open Decommission Screen

#Scan To Decommission
#    [Arguments]     ${ENV}  ${Username}     ${SSCC To Scan}
#    Decommission To Scan    ${ENV}  ${Username}     ${SSCC To Scan}

Scan To Decommission
    [Arguments]     ${SSCC To Scan}
    Sleep    2s
    Input Text    id=test-scan-field    ${SSCC To Scan}
    Sleep    2s
    Click Button    xpath=//button[contains(text(),'Test Scan')]


#Scan To Decommission
 #   [Arguments]     ${ENV}  ${Username}     ${SSCC To Scan}
  #  Decommission To Scan    ${ENV}  ${Username}     ${SSCC To Scan}

Submit Decommission
    Reload Page
    Execute JavaScript    document.body.style.zoom='80%'
    Sleep    2s
    Click Submit Decommission
    Confirm Decommission

Open Decommission Screen
    Sleep    2s
    Execute JavaScript    document.body.style.zoom='70%'
    Wait And Click Element    id=logistic-operations
    Sleep    2s
    Wait And Click Element    id=decommision

Click Submit Decommission
    Click Button    xpath=//button[contains(text(),'Submit')]
    Sleep    2s

Confirm Decommission
    Click Element    id=reason
    Sleep    2s
    Click Element    xpath=//li[contains(text(),'Other')]
    Sleep    2s
    Click Button    xpath=//button[contains(text(),'Confirm')]