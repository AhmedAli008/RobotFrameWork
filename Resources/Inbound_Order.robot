*** Settings ***
Library     SeleniumLibrary
Library     String
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Variables ***
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button
${TABLE_ROWS}     xpath=/html/body/div[6]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr

*** Keywords ***
Create Inbound Order
    [Arguments]     ${Supplier}    ${Doc.No}    ${Qty Num}
    Open Inbound
    New Order
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Insert All Req Data    ${Supplier}    ${Doc.No}
    Insert Product    ${Qty Num}
    Confirm Order

Create Inbound Order Multi SKU
    [Arguments]     ${Supplier}    ${Doc.No}    ${Qty Num}
    Open Inbound
    New Order
    Insert All Req Data    ${Supplier}    ${Doc.No}
    Insert Multi SKU Product
    Confirm Order

Create Mixed Inbound Order
    [Arguments]     ${Supplier}    ${Doc.No}    ${Qty Num}
    Open Inbound
    New Order
    Insert All Req Data    ${Supplier}    ${Doc.No}
    Insert Mixed Product    ${Qty Num}
    Confirm Order

Open Inbound
    Sleep    2s
    Click Element    id=logistic-operations
    Sleep    1s
    Click Element    id=inbound
    
New Order
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'New Order')]

Insert All Req Data
    [Arguments]    ${Supplier}    ${Doc.No} 
    #Doc.Type
    Sleep    2s
    Click Element    id=documentType
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Doc.Num
    Input Text   id=documentNumber    ${Doc.No}
    #Order Type
    Click Element    id=orderType
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    #Supplier
    Input Text    id=supplier    ${Supplier}
    Sleep     1s
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    
Insert Product
    [Arguments]    ${Qty Num}
    Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Input Text   xpath=/html/body/div[6]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input   ${data['GTIN']}
    Sleep    3s
    Click Element    xpath=/html/body/div[6]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[1]
    Input Text    id=lines[0].quantity    ${Qty Num}
    #Input Text    id=lines[0].lot    ${data['Lot']}

Insert Mixed Product
    [Arguments]    ${Qty Num}
    Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Input Text   xpath=/html/body/div[6]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input   ${data['GTIN']}
    Sleep    3s
    Click Element    xpath=/html/body/div[6]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[1]
    Input Text    id=lines[0].quantity    ${Qty Num}
    Input Text    id=lines[0].lot    ${data['Lot']}
    #Add Line
    Click Button    xpath=//button[contains(text(),'Add Line')]
    Click Element    xpath=//*[@id="lines[1].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Input Text   xpath=/html/body/div[7]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input   ${data['GTIN1']}
    Sleep    3s
    Click Element    xpath=/html/body/div[7]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[2]
    Input Text    id=lines[1].quantity    ${Qty Num}
    Input Text    id=lines[1].lot    ${data['Lot1']}

Insert Multi SKU Product
    Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Input Text   xpath=/html/body/div[6]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input   ${data['GTIN']}
    Sleep    3s
    ${count}=   Get Element Count    ${TABLE_ROWS}
    Click Element    xpath=/html/body/div[6]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[1]
    Input Text    id=lines[0].quantity    10
    Input Text    id=lines[0].lot    ${data['Lot']}
    TRY
        Should Be Equal As Integers    ${count}    3
        #Add Line
        Click Button    xpath=//button[contains(text(),'Add Line')]
        Click Element    xpath=//*[@id="lines[1].product"]/div[1]/div/div[1]/input
        Sleep    2s
        Input Text   xpath=/html/body/div[7]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input   ${data['GTIN']}
        Sleep    3s
        Click Element    xpath=/html/body/div[7]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[2]
        Input Text    id=lines[1].quantity    10
        Input Text    id=lines[1].lot    ${data['Lot']}
    EXCEPT
        Execute JavaScript    alert("No Multi SKU for this Product")
        Sleep    5s
        Handle Alert     timeout=3s
    END

Confirm Order
    Click Button    xpath=//button[contains(text(), 'Confirm')]
    
Scan Inbound Order
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Input Text   id=filter-documentNumber    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Scan')]
    #Scan Items
    Scan Items    ${Doc.No}    ${ENV}    ${UserName}

Scan Inbound Order Twice To Remove
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Input Text   id=filter-documentNumber    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Scan')]
    #Scan Items Twice To Remove
    Inbound Order Scan    ${ENV}    ${UserName}    ${data_SSCC['SSCC0']}    ${Doc.No}
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    ${Msg}    Inbound Order Scan    ${ENV}    ${UserName}    ${data_SSCC['SSCC0']}    ${Doc.No}
    ${Msg}    Set Variable    ${Msg['message']}
    Execute JavaScript    alert("${Msg}")
    Sleep    5s
    Handle Alert     timeout=3s
    #Click Confirm To Remove
    Inbound Order Scan To Remove    ${ENV}    ${UserName}    ${data_SSCC['SSCC0']}    ${Doc.No}
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Scan All Items
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Inbound Order Scan    ${ENV}    ${UserName}    ${value}    ${Doc.No}
    END
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Clear All
    Sleep    3s
    Click Button    xpath=//button[@aria-label="Clear All Scanned Items"]
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Confirm')]
    Sleep    3s
    #Scan All Items
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Inbound Order Scan    ${ENV}    ${UserName}    ${value}    ${Doc.No}
    END
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Submit Accepted
    Sleep    3s
    Click Button    xpath=//button[contains(text(), 'Submit')]
    Sleep    5s


Scan Inbound Order after Exeed Limit
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Input Text    id=filter-documentNumber    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Scan')]
    #Scan Items
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Inbound Order Scan    ${ENV}    ${UserName}    ${value}    ${Doc.No}
    END

Scan Inbound Order Multi SKU
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Input Text     id=filter-documentNumber    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Scan')]
    #Scan Items
    Scan Items Multi SKU   ${Doc.No}    ${ENV}    ${UserName}
    
    
Scan Items Multi SKU
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    ${Result}    Inbound Order Scan    ${ENV}    ${UserName}    ${data_SSCC['SSCC1']}    ${Doc.No}
    ${Msg}    Set Variable    ${Result['message']}
    TRY
        Should Be Equal As Strings    ${Msg}    More than one line is matching!
        Execute JavaScript    alert("${Msg}")
        Sleep    5s
        Handle Alert     timeout=3s
        Execute JavaScript    alert("${Result['data']}")
        Sleep    5s
        Handle Alert     timeout=3s
        ${Parent}    Set Variable    ${data_SSCC['SSCC1']}
        Inbound Order Scan Multi SKU    ${ENV}    ${UserName}    ${Parent}    ${Doc.No}
    EXCEPT
        Execute JavaScript    alert("${Msg}")
        Sleep    5s
        Handle Alert     timeout=3s
    END
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Submit Accepted
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Submit')]
    Sleep    3s

Scan Items
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        ${Msg}    Inbound Order Scan    ${ENV}    ${UserName}    ${value}    ${Doc.No}
        ${Msg}    Set Variable    ${Msg['message']}
        TRY
            Should Be Equal As Strings    ${Msg}    Quantity exceeded the limit
            Execute JavaScript    alert("${Msg}")
            Sleep    5s
            Handle Alert     timeout=3s
            ${Qty Num}    Get Length    ${data_SGTIN}
            Edit Order    ${Doc.No}    ${Qty Num}
            Scan Inbound Order after Exeed Limit    ${Doc.No}    ${ENV}    ${UserName}
        EXCEPT
            Continue For Loop
        END
    END 
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Submit Accepted
    Sleep    3s
    Click Button    xpath=//button[contains(text(), 'Submit')]
    Sleep    5s
    
Edit Order
    [Arguments]    ${Doc.No}     ${Qty Num}
    Go Back
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    2s
    Input Text    id=filter-documentNumber    ${Doc.No}
    #Click Edit from Actions
    Sleep    2s
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Edit')]
    Sleep    2s
    #Edit Qty
    Click Element    id=lines[0].quantity
    Press Keys    None    BACKSPACE
    Input Text    id=lines[0].quantity    ${Qty Num}
    Sleep    2s
    #Confirm Edit
    Click Button    xpath=//button[contains(text(),'Confirm')]

Random String
    ${str}  Generate Random String    8
    RETURN    ${str}