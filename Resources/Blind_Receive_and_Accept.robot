*** Settings ***
Library     SeleniumLibrary
Library     ../API/Blind_Receive.py
Library    ../API/Generate_Json_File.py
Variables  ../API/Token_SSCC_Permit_Num.py

*** Variables ***


*** Keywords ***
Blind Receive
    [Arguments]   ${ENV}   ${Supplier}
    Open Blind Receive
    Select Supplier  ${Supplier}
    Action To Scan
    Execute JavaScript    document.body.style.zoom='70%'
    Aggregate Button
    Execute JavaScript    document.body.style.zoom='70%'
    Scan Parent    ${ENV}    ${Supplier}    ${data['parent1_to_scan']}
    Reload Page
    Scan Child    ${ENV}    ${Supplier}    ${data_SGTIN['SGTIN1']}
    Scan Child    ${ENV}    ${Supplier}    ${data_SGTIN['SGTIN2']}
    Reload Page
    Submit Aggregation
    Sleep    3s
    Aggregate Button
    Execute JavaScript    document.body.style.zoom='70%'
    Scan Parent    ${ENV}    ${Supplier}    ${data['parent2_to_scan']}
    Reload Page
    Scan Child    ${ENV}    ${Supplier}    ${data_SGTIN['SGTIN3']}
    Scan Child    ${ENV}    ${Supplier}    ${data_SGTIN['SGTIN4']}
    Reload Page
    Submit Aggregation
    Sleep    3s
    Aggregate Button
    Execute JavaScript    document.body.style.zoom='70%'
    Scan Parent    ${ENV}    ${Supplier}    ${data['parent3_to_scan']}
    Reload Page
    Scan Child    ${ENV}    ${Supplier}    ${data_SGTIN['SGTIN5']}
    Scan Child    ${ENV}    ${Supplier}    ${data_SGTIN['SGTIN6']}
    Reload Page
    Submit Aggregation
    Sleep    5s
    Submit Blind Receive
    Go To Home
    Open Shipment File


Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]

Open Shipment File
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[3]/div/button

Scan Parent
    [Arguments]     ${ENV}  ${Supplier}   ${Parent}
    Scan Parent Blind Receive    ${ENV}    ${Supplier}    ${Parent}

Scan Child
    [Arguments]     ${ENV}  ${Supplier}     ${Child}
    Scan Child Blind Receive    ${ENV}    ${Supplier}    ${Child}

Submit Aggregation
    Sleep    3s
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[4]/button

Submit Blind Receive
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/button[2]

Open Blind Receive
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button
    Sleep    2s
    Click Button    id=full-width-tab-4

Select Supplier
    [Arguments]     ${Supplier}
    Sleep    2s
    Click Button    xpath=//*[@id="full-width-tabpanel-4"]/div/div/div[1]/div[2]/div[2]/div/button[1]
    Sleep    2s
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[5]/div/div/div/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input    ${Supplier}

Action To Scan
    Sleep    1s
    Click Button    xpath=//button[@aria-label='Row Actions']
    Sleep    4s
    Click Element    xpath=/html/body/div[4]/div[3]/ul/li
    Sleep    3s

Aggregate Button
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/button[1]