*** Settings ***
Library     SeleniumLibrary
Library     String
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Variables ***
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button

*** Keywords ***
Create Inbound Order
    [Arguments]     ${ENV}  ${Supplier}    ${Doc.No}    ${Qty Num}
    Open Inbound
    New Order
    Insert All Req Data    ${Supplier}    ${Doc.No}    ${Qty Num}


Open Inbound
    Sleep    2s
    Click Element    id=logistic-operations
    Sleep    1s
    Click Element    id=inbound
    

New Order
    Sleep    1s
    Click Button    xpath=//button[contains(text(), 'New Order')]

Insert All Req Data
    [Arguments]    ${Supplier}    ${Doc.No}    ${Qty Num}
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
    Sleep    2s
    Input Text   xpath=/html/body/div[6]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input   ${data['GTIN']}
    Sleep    3s
    Click Element    xpath=/html/body/div[6]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[1]
    Input Text    xpath=//*[@id="lines[0].quantity"]    ${Qty Num}
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
    Click Element    xpath=/html/body/div[7]/div[3]/ul/li[1]
    #Scan Items
    Scan Items    ${Doc.No}    ${ENV}    ${UserName}
    
    
Scan Items
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        ${Msg}    Inbound Order Scan    ${ENV}    ${UserName}    ${value}    ${Doc.No}
        TRY
            Should Be Equal As Strings    ${Msg}    Quantity exceeded the limit
            Execute JavaScript    alert("${Msg}")
            Sleep    5s
            Handle Alert     timeout=3s
            ${Qty Num}    Get Length    ${data_SGTIN}
            Edit Order    ${Doc.No}    ${Qty Num}
            Scan Inbound Order    ${Doc.No}    ${ENV}    ${UserName}
        EXCEPT
            Continue For Loop
        END
    END 
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    #Submit Accepted
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Submit')]
    
Edit Order
    [Arguments]    ${Doc.No}     ${Qty Num}
    Go Back
    #Search about Doc.No
    Sleep    2s
    Click Button    xpath=//*[@id="full-width-tabpanel-0"]/div/div[2]/div[1]/div[2]/div[2]/div/button[1]
    Sleep    2s
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[1]/div/div/div[2]/div[2]/table/thead/tr/th[3]/div[2]/div/div/div/div/input    ${Doc.No}
    #Click Edit from Actions
    Sleep    2s
    Click Button    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]
    Sleep    2s
    Click Element    xpath=/html/body/div[7]/div[3]/ul/li[3]
    Sleep    2s
    #Edit Qty
    Input Text    xpath=//*[@id="lines[0].quantity"]    ${Qty Num}
    Sleep    2s
    #Confirm Edit
    Click Button    xpath=//button[contains(text(),'Confirm')]

Random String
    ${str}  Generate Random String    8
    RETURN    ${str}