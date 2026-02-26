*** Settings ***
Library     SeleniumLibrary
Library     ../API/Outbound_Scan.py
Library     Collections
Variables   ../API/Outbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py
Resource    Common_Keywords.robot

*** Keywords ***
Create Outbound Order
    [Arguments]    ${Doc.No}    ${Qty Num}
    Sleep    2s
    Open Outbound
    New Order
    Insert All Req Data    ${Doc.No}    ${Qty Num}


Open Outbound
    Sleep    2s
    Wait And Click Element    id=logistic-operations
    Sleep    2s
    Wait And Click Element    id=outbound-orders

New Order
    Sleep    2S
    Safe Click Button    xpath=//button[contains(text(), 'New Order')]

Insert All Req Data
    [Arguments]    ${Doc.No}    ${Qty Num}
    Sleep    5s
    #Document Type
    Wait And Click Element    id=documentType
    Input Text    id=documentType    PO
    Wait Until Element Is Visible    id=documentType-option-0    10s
    Sleep    4s
    Click Element    id=documentType-option-0
    Sleep    1s
    #Document Number
    Wait For Element And Input    id=documentNumber    ${Doc.No}
    #Order Type
     Sleep    3s
     Wait Until Element Is Visible    id=orderType    5s
     Wait And Click Element    id=orderType
     Input Text    id=orderType    Local
     Wait Until Element Is Visible    id=orderType-option-0    5s
     Sleep    4s
     Click Element    id=orderType-option-0
     Sleep    1s
    #Buyer
    Wait For Element And Input    id=buyer    ${outbound_supplier}
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Shipping Type

    Wait And Click Element      id=shippingType
    Input Text                  id=shippingType    Normal
    Wait Until Element Is Visible    xpath=//li[contains(text(),'Normal')]    10s
    Click Element               xpath=//li[contains(text(),'Normal')]

    #Product
    Wait And Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Wait For Element And Input    xpath=/html/body/div[7]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input    ${data['GTIN']}
    Sleep    2s
    Wait And Click Element    xpath=//tr[@class='dx-row dx-data-row dx-column-lines' and @aria-rowindex='1']
    #Quantity
    Wait For Element And Input    xpath=//input[@id='lines[0].quantity']    ${Qty Num}
    #Batch or Lot
    Wait For Element And Input    xpath=//input[@id='lines[0].lot']    ${data['Lot']}
    Sleep    2s
    #Confirm
    Safe Click Button    xpath=//button[contains(text(), 'Confirm')]

Scan Outbound Order
    [Arguments]    ${ENV}    ${Doc.No}
    Sleep    3s
    #Search about Document Number

    ${status}=    Run Keyword And Return Status    Safe Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Run Keyword If    not ${status}    Safe Click Button  id=filter-documentNumber  #xpath=//*[@id="full-width-tabpanel-0"]//button[contains(@aria-label, 'filter') or contains(@aria-label, 'Filter')]
    Sleep    2s
    Wait For Element And Input    id=filter-documentNumber  ${Doc.No}    15s  #xpath=//input[contains(@placeholder, 'Filter') or ancestor::th[contains(.,'Doc')]]    ${Doc.No}    15s
    #Select Scan from Actions
    Sleep    2s
    Safe Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    ${status}=    Run Keyword And Return Status    Wait And Click Element    xpath=//li[contains(text(),'Scan') or contains(.,'Scan')]    3s
    Run Keyword If    not ${status}    Press Keys    None    ENTER
    #Scan
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Outbound Order Scan   ${ENV}    ${value}    ${Doc.No}
    END
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Confirm Ship Out
    Sleep    2s
    JS Click Element    xpath=//button[contains(text(),'Ship Out')]


