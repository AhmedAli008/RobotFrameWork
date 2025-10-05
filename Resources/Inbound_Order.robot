*** Settings ***
Library     SeleniumLibrary
Library     String
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Variables ***
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button

*** Keywords ***
Inbound Order
    [Arguments]     ${ENV}  ${Supplier}    ${UserName}
    Go To Home
    Open Inbound
    New Order
    ${Doc.No}    Random String
    Insert All Req Data    ${Supplier}    ${Doc.No}
    Scan Inbound Order     ${Doc.No}    ${ENV}    ${UserName}


Go To Home
    Sleep    2s
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]

Open Inbound
    Wait Until Page Contains Element    ${Selector}
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button
    

New Order
    Sleep    1s
    Click Button    xpath=//button[contains(text(), 'New Order')]

Insert All Req Data
    [Arguments]    ${Supplier}    ${Doc.No}
    #Doc.Type
    Sleep    1s
    Click Element    xpath=//*[@id="documentType"]
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Doc.Num
    Input Text   xpath=//*[@id="documentNumber"]    ${Doc.No}
    #Order Type
    Click Element    xpath=//*[@id="orderType"]
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Supplier
    Input Text    xpath=//*[@id="supplier"]    ${Supplier}
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Product
    Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Input Text   xpath=/html/body/div[6]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input   ${data['GTIN']}
    Sleep    3s
    Click Element    xpath=/html/body/div[6]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[1]
    Input Text    xpath=//*[@id="lines[0].quantity"]    6
    Input Text    xpath=//*[@id="lines[0].lot"]    ${data['Lot']}
    #Confirm
    Click Button    xpath=//button[contains(text(), 'Confirm')]
    
Scan Inbound Order
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//*[@id="full-width-tabpanel-0"]/div/div[2]/div[1]/div[2]/div[2]/div/button[1]
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[1]/div/div/div[2]/div[2]/table/thead/tr/th[3]/div[2]/div/div/div/div/input    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]
    Sleep    2s
    Click Element    xpath=//li[@class="MuiButtonBase-root MuiMenuItem-root MuiMenuItem-gutters MuiMenuItem-root MuiMenuItem-gutters css-r2hyib"]
    #Scan Items
    Inbound Order Scan    ${ENV}        ${UserName}    ${data['parent1_to_scan']}    ${Doc.No}
    Inbound Order Scan    ${ENV}        ${UserName}    ${data['parent2_to_scan']}    ${Doc.No}
    Inbound Order Scan    ${ENV}        ${UserName}    ${data['parent3_to_scan']}    ${Doc.No}
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Submit Accepted
    Sleep    5s
    Click Button    xpath=//button[contains(text(), 'Submit')]
    Sleep    5s
    
    
Random String
    ${str}  Generate Random String    8
    Return From Keyword    ${str}