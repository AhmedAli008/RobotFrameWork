*** Settings ***
Library     SeleniumLibrary
Library     String
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py
Resource    Inbound_Adhoc.robot

*** Keywords ***
Non Serialize Adhoc
    [Arguments]     ${Supplier}    ${Qty Num}
    Go To AdHoc Inbound
    Search About Supplier    ${Supplier}
    Select Supplier
    Select NonSerialize Tab
    Insert All Non Serialize Data    ${Qty Num}
    Submit Order


Select NonSerialize Tab
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Non-Serialization')]

Insert All Non Serialize Data
    [Arguments]    ${Qty Num}
    #GTIN
    Click Element    id=gtin
    Input Text    id=gtin    ${data['GTIN']}
    Sleep    2s
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