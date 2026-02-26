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
    Open Outbound
    New Order
    Insert All Req Data    ${Doc.No}    ${Qty Num}


Open Outbound
    Sleep    2s
    Click Element    id=logistic-operations
    Sleep    1s
    Click Element    id=outbound-orders

New Order
    Sleep    2S
    Click Button    xpath=//button[contains(text(), 'New Order')]    

Insert All Req Data
    [Arguments]    ${Doc.No}    ${Qty Num}
    Sleep    3s
    #Document Type
    Click Element    id=documentType   
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Document Number
    Input Text    id=documentNumber    ${Doc.No}
    #Order Type
    Click Element     id=orderType
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Buyer
    Input Text     id=buyer    ${outbound_supplier}
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Shipping Type
    Click Element    id=shippingType
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Product
    Click Element     xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Input Text    xpath=/html/body/div[7]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input    ${data['GTIN']}
    Sleep    2s
    Click Element    xpath=//tr[@class='dx-row dx-data-row dx-column-lines' and @aria-rowindex='1']
    #Quantity
    Input Text    id=lines[0].quantity    ${Qty Num}
    #Batch or Lot
    Input Text    id=lines[0].lot    ${data['Lot']}
    Sleep    2s
    #Confirm 
    Click Button    xpath=//button[contains(text(), 'Confirm')]

Scan Outbound Order
    [Arguments]   ${Doc.No}
    Sleep    2s
    #Search about Document Number
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Input Text    id=filter-documentNumber    ${Doc.No}
    #Select Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Scan')]
    #Scan
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        #Outbound Order Scan   ${ENV}    ${value}    ${Doc.No}
        Input Text    id=test-scan-field    ${value}
        Click Button    xpath=//button[contains(text(),'Test Scan')]
    END 
    Execute JavaScript    document.body.style.zoom='70%'
    #Confirm Ship Out
    Sleep    2s
    Click Button     xpath=//button[contains(text(),'Ship Out')]


