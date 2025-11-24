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
    Click Button    xpath=//*[@id="full-width-tabpanel-0"]/div/div[2]/div[1]/div[2]/div[2]/div/button[1]
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[1]/div/div/div[2]/div[2]/table/thead/tr/th[3]/div[2]/div/div/div/div/input    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]
    Sleep    2s
    Click Element    xpath=/html/body/div[7]/div[3]/ul/li[1]

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