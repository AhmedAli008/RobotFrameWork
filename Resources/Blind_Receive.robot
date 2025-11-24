*** Settings ***
Library     SeleniumLibrary
Library     ../API/Blind_Receive.py
Library    ../API/Generate_Json_File.py
Variables  ../API/Token_SSCC_Permit_Num.py

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
        Scan Parent    ${ENV}    ${Supplier}    ${value}
        Reload Page
        FOR    ${Index}    IN RANGE    ${SGTIN Num}
            Scan Child    ${ENV}    ${Supplier}    ${data_SGTIN['SGTIN'+ str(${SGTIN Serials})]}
            ${SGTIN Serials}    Evaluate    ${SGTIN Serials}+1
        END 
        Reload Page
        Submit Aggregation
        Sleep    3s
    END
    Submit Blind Receive
    #Go To Home
    #Open Shipment File


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
    Sleep    2s
    Click Element    id=logistic-operations
    Sleep    1s
    Click Element    id=inbound
    Sleep    2s
    Click Button    xpath=//button[contains(text(),'Blind Receive')]

Select Supplier
    [Arguments]     ${Supplier}
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    2s
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[5]/div/div/div/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input    ${Supplier}

Action To Scan
    Sleep    1s
    Click Button    xpath=//button[@aria-label='Row Actions']
    Sleep    3s
    #Click Element    xpath=/html/body/div[7]/div[3]/ul/li
    Press Keys    None    ENTER
    Sleep    3s

Aggregate Button
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/button[1]

    

