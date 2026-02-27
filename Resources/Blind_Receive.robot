*** Settings ***
Library     SeleniumLibrary
Library     ../API/Blind_Receive.py
Library    ../API/Generate_Json_File.py
Variables  ../API/Token_SSCC_Permit_Num.py
Resource   Common_Keywords.robot

*** Variables ***


*** Keywords ***
Blind Receive
    [Arguments]   ${ENV}   ${Supplier}    ${SGTIN Num}
    Open Blind Receive
    Select Supplier  ${Supplier}
    Action To Scan
    Execute JavaScript    document.body.style.zoom='70%'
    ${SGTIN Serials}     Set Variable   1
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Aggregate Button
        Execute JavaScript    document.body.style.zoom='70%'
        Sleep    2s
        Scan Parent    ${value}
        FOR    ${Index}    IN RANGE    ${SGTIN Num}
            Scan Child    ${data_SGTIN['SGTIN'+ str(${SGTIN Serials})]}
            ${SGTIN Serials}    Evaluate    ${SGTIN Serials}+1
        END
        Reload Page
        Submit Aggregation
        Sleep    3s
    END
    Submit Blind Receive
    #Go To Home
    #Open Shipment File


#Scan Parent
#    [Arguments]     ${ENV}  ${Supplier}   ${Parent}
#    Scan Parent Blind Receive    ${ENV}    ${Supplier}    ${Parent}
#
#Scan Child
#    [Arguments]     ${ENV}  ${Supplier}     ${Child}
#    Scan Child Blind Receive    ${ENV}    ${Supplier}    ${Child}

Scan Parent
    [Arguments]      ${Parent}
    Input Text    id=test-scan-field    ${Parent}
    Click Button    xpath=//button[contains(text(),'Test Scan')]

Scan Child
    [Arguments]     ${Child}
    Input Text    id=test-scan-field     ${Child}
    Click Button    xpath=//button[contains(text(),'Test Scan')]

Submit Aggregation
    Sleep    3s
    Wait Until Element Is Visible    xpath=//*[@id="root"]/div[1]/main/div[4]/button    10s
    JS Click Element    xpath=//*[@id="root"]/div[1]/main/div[4]/button

Submit Blind Receive
    Wait Until Element Is Visible    xpath=//*[@id="root"]/div[1]/main/div[5]/button[2]    10s
    JS Click Element    xpath=//*[@id="root"]/div[1]/main/div[5]/button[2]

Open Blind Receive
    Sleep    2s
    Wait And Click Element    id=logistic-operations
    Sleep    2s
    Wait And Click Element    id=inbound
    Sleep    2s
    Safe Click Button    xpath=//button[contains(text(),'Blind Receive')]

Select Supplier
    [Arguments]     ${Supplier}
    Sleep    2s
    Safe Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    2s
    Wait For Element And Input    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[5]/div/div/div/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input    ${Supplier}

Action To Scan
    Sleep    1s
    Safe Click Button    xpath=//button[@aria-label='Row Actions']
    Sleep    3s
    Click Element    xpath=//p[contains(text(),'Scan')]
    #Press Keys    None    ENTER
    Sleep    3s

Aggregate Button
    Safe Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/button[1]

    

