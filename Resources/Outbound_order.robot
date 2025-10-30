*** Settings ***
Library     SeleniumLibrary
Library     ../API/Outbound_Scan.py
Library     Collections
Variables   ../API/Outbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Keywords ***
Create Outbound Order
    [Arguments]    ${Doc.No}    ${Qty Num}
    Sleep    2s
    Go To Home
    Open Outbound
    New Order
    Insert All Req Data    ${Doc.No}    ${Qty Num}

Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]

Open Outbound
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[2]/div/button
New Order
    Click Button    xpath=//button[contains(text(), 'New Order')]    

Insert All Req Data
    [Arguments]    ${Doc.No}    ${Qty Num}
    Sleep    2s
    #Document Type
    Click Element    xpath=//input[@id='documentType']    
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Document Number
    Input Text    xpath=//input[@id='documentNumber']    ${Doc.No}
    #Order Type
    Click Element     xpath=//input[@id='orderType']
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Buyer
    Input Text     xpath=//input[@id='buyer']    ${outbound_supplier}
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Shipping Type
    Click Element    xpath=//input[@id='shippingType']
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Product
    Click Element     xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Input Text    xpath=/html/body/div[6]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input    ${data['GTIN']}
    Sleep    2s
    Click Element    xpath=//tr[@class='dx-row dx-data-row dx-column-lines' and @aria-rowindex='1']
    #Quantity
    Input Text    xpath=//input[@id='lines[0].quantity']    ${Qty Num}
    #Batch or Lot
    Input Text    xpath=//input[@id='lines[0].lot']    ${data['Lot']}
    Sleep    2s
    #Confirm 
    Click Button    xpath=//button[contains(text(), 'Confirm')]

Scan Outbound Order
    [Arguments]    ${ENV}    ${Doc.No}
    Sleep    2s
    #Search about Document Number
    Click Button    xpath=//*[@id="full-width-tabpanel-0"]/div/div[2]/div[1]/div[2]/div[2]/div/button[1]
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[1]/div/div/div[2]/div[2]/table/thead/tr/th[3]/div[2]/div/div/div/div/input    ${Doc.No}
    #Select Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//li[@class="MuiButtonBase-root MuiMenuItem-root MuiMenuItem-gutters MuiMenuItem-root MuiMenuItem-gutters css-r2hyib"]
    #Scan
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Outbound Order Scan   ${ENV}    ${value}    ${Doc.No}
    END 
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Confirm Ship Out
    Sleep    2s
    Click Button     xpath=//button[contains(text(),'Ship Out')]


