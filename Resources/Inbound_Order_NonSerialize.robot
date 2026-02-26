*** Settings ***
Library     SeleniumLibrary
Library     String
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py
Resource    Inbound_Order.robot

*** Keywords ***
Non Serialize
    [Arguments]     ${Doc.No}    ${Qty Num}
    Open Inbound Order    ${Doc.No}
    Select NonSerialize Tab
    Insert All Non Serialize Data    ${Qty Num}
    Submit Order

Open Inbound Order
    [Arguments]    ${Doc.No}    
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Input Text    id=filter-documentNumber    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Scan')]

Select NonSerialize Tab
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Non-Serialization')]

Insert All Non Serialize Data
    [Arguments]    ${Qty Num}
    #GTIN
    Click Element    id=gtin
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Lot
    Input Text    id=batch    ${data['Lot']}
    #Qty
    Input Text    id=quantity    ${Qty Num}
    #Confirm
    Click Button    xpath=//button[contains(text(), 'Confirm')]

Submit Order
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Submit')]
    Sleep    2s