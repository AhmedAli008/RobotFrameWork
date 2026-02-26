*** Settings ***
Library     SeleniumLibrary
Library     String
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py
Resource    Common_Keywords.robot

*** Variables ***
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button
${POPUP_SEARCH_INPUT}     xpath=(//div[contains(@class,'dx-overlay-wrapper')])[last()]//tr[contains(@class,'dx-datagrid-filter-row')]/td[2]//input
${POPUP_FIRST_ROW}        xpath=(//div[contains(@class,'dx-overlay-wrapper')])[last()]//table//tbody/tr[1]
${POPUP_SECOND_ROW}       xpath=(//div[contains(@class,'dx-overlay-wrapper')])[last()]//table//tbody/tr[2]
${TABLE_ROWS}             xpath=(//div[contains(@class,'dx-overlay-wrapper')])[last()]//table//tbody/tr

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
    Wait And Click Element    id=logistic-operations
    Sleep    2s
    Wait And Click Element    id=inbound

New Order
    Sleep    2s
    Safe Click Button    xpath=//button[contains(text(), 'New Order')]

Insert All Req Data
    [Arguments]    ${Supplier}    ${Doc.No}
    #Doc.Type
    Sleep    3s
    Wait Until Element Is Visible    id=documentType    15s
    Wait And Click Element    id=documentType
    Input Text    id=documentType    PO
    Wait Until Element Is Visible    id=documentType-option-0    10s
    Sleep    4s
    Click Element    id=documentType-option-0
    Sleep    1s
    #Doc.Num
    Wait For Element And Input    id=documentNumber    ${Doc.No}
    #Order Type
        Sleep    3s
        Wait Until Element Is Visible    id=orderType    15s
        Wait And Click Element    id=orderType
        Input Text    id=orderType    Local
        Wait Until Element Is Visible    id=orderType-option-0    10s
        Sleep    4s
        Click Element    id=orderType-option-0
        Sleep    1s

    #Supplier
    Wait For Element And Input    id=supplier    ${Supplier}
    Sleep     1s
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    
Insert Product
    [Arguments]    ${Qty Num}
    Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Wait Until Element Is Visible    ${POPUP_SEARCH_INPUT}    10s
    Input Text    ${POPUP_SEARCH_INPUT}    ${data['GTIN']}
    Sleep    3s
    Wait Until Element Is Visible    ${POPUP_FIRST_ROW}    10s
    #Select the first row that contains the GTIN value
    Click Element    xpath=(//div[contains(@class,'dx-overlay-wrapper')])[last()]//table//tbody//td[contains(text(),'${data['GTIN']}')]
    Sleep    3s
    Input Text    xpath=//*[@id="lines[0].quantity"]    ${Qty Num}
    #Input Text    xpath=//*[@id="lines[0].lot"]    ${data['Lot']}

Insert Mixed Product
    [Arguments]    ${Qty Num}
    Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Wait Until Element Is Visible    ${POPUP_SEARCH_INPUT}    10s
    Input Text    ${POPUP_SEARCH_INPUT}    ${data['GTIN']}
    Sleep    3s
    Wait Until Element Is Visible    ${POPUP_FIRST_ROW}    10s
    Click Element    ${POPUP_FIRST_ROW}
    Input Text    xpath=//*[@id="lines[0].quantity"]    ${Qty Num}
    Input Text    xpath=//*[@id="lines[0].lot"]    ${data['Lot']}
    #Add Line
    Click Button    xpath=//button[contains(text(),'Add Line')]
    Click Element    xpath=//*[@id="lines[1].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Wait Until Element Is Visible    ${POPUP_SEARCH_INPUT}    10s
    Input Text    ${POPUP_SEARCH_INPUT}    ${data['GTIN1']}
    Sleep    3s
    Wait Until Element Is Visible    ${POPUP_SECOND_ROW}    10s
    Click Element    ${POPUP_SECOND_ROW}
    Input Text    xpath=//*[@id="lines[1].quantity"]    ${Qty Num}
    Input Text    xpath=//*[@id="lines[1].lot"]    ${data['Lot1']}

Insert Multi SKU Product
    Click Element    xpath=//*[@id="lines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Wait Until Element Is Visible    ${POPUP_SEARCH_INPUT}    10s
    Input Text    ${POPUP_SEARCH_INPUT}    ${data['GTIN']}
    Sleep    3s
    ${count}=   Get Element Count    ${TABLE_ROWS}
    Wait Until Element Is Visible    ${POPUP_FIRST_ROW}    10s
    Click Element    ${POPUP_FIRST_ROW}
    Input Text    xpath=//*[@id="lines[0].quantity"]    10
    Input Text    xpath=//*[@id="lines[0].lot"]    ${data['Lot']}
    TRY
        Should Be Equal As Integers    ${count}    3
        #Add Line
        Click Button    xpath=//button[contains(text(),'Add Line')]
        Click Element    xpath=//*[@id="lines[1].product"]/div[1]/div/div[1]/input
        Sleep    2s
        Wait Until Element Is Visible    ${POPUP_SEARCH_INPUT}    10s
        Input Text    ${POPUP_SEARCH_INPUT}    ${data['GTIN']}
        Sleep    3s
        Wait Until Element Is Visible    ${POPUP_SECOND_ROW}    10s
        Click Element    ${POPUP_SECOND_ROW}
        Input Text    xpath=//*[@id="lines[1].quantity"]    10
        Input Text    xpath=//*[@id="lines[1].lot"]    ${data['Lot']}
    EXCEPT
        Execute JavaScript    alert("No Multi SKU for this Product")
        Sleep    5s
        Handle Alert     timeout=3s
    END

Confirm Order
    Safe Click Button    xpath=//button[contains(text(), 'Confirm')]

Scan Inbound Order
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    3s
    # Try multiple filter button locators
    Click Filter Button
    Sleep    2s
    # Try to input in filter field
    Input Filter Value    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Row Actions And Select Scan
    #Scan Items
    Scan Items    ${Doc.No}    ${ENV}    ${UserName}

Click Filter Button
    ${status1}=    Run Keyword And Return Status    Safe Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Return From Keyword If    ${status1}
    ${status2}=    Run Keyword And Return Status    Safe Click Button    xpath=//button[contains(@aria-label, 'filter')]
    Return From Keyword If    ${status2}
    ${status3}=    Run Keyword And Return Status    Safe Click Button    xpath=//div[contains(@class, 'tabpanel')]//button[1]
    Return From Keyword If    ${status3}
    Log    Could not find filter button

Input Filter Value
    [Arguments]    ${value}
    ${status1}=    Run Keyword And Return Status    Wait For Element And Input    xpath=//input[contains(@placeholder, 'Filter')]    ${value}    10s
    Return From Keyword If    ${status1}
    ${status2}=    Run Keyword And Return Status    Wait For Element And Input    xpath=//thead//input    ${value}    10s
    Return From Keyword If    ${status2}
    ${status3}=    Run Keyword And Return Status    Wait For Element And Input    xpath=//th[contains(.,'Doc')]//input    ${value}    10s
    Return From Keyword If    ${status3}
    Log    Could not find filter input field

Click Row Actions And Select Scan
    Safe Click Button    xpath=//button[@aria-label='Row Actions']
    Sleep    2s
    ${status}=    Run Keyword And Return Status    Wait And Click Element    xpath=//li[contains(text(),'Scan') or contains(.,'Scan')]    3s
    Run Keyword If    not ${status}    Press Keys    None    ENTER

Scan Inbound Order Twice To Remove
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    3s
    Click Filter Button
    Sleep    2s
    Input Filter Value    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Row Actions And Select Scan
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
    Click Button    xpath=//*[@id="full-width-tabpanel-0"]/div/div/div[2]/button
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
    Safe Click Button    xpath=//button[contains(text(), 'Submit')]
    Sleep    5s


Scan Inbound Order after Exeed Limit
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    3s
    Click Filter Button
    Sleep    2s
    Input Filter Value    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Row Actions And Select Scan
    #Scan Items
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Inbound Order Scan    ${ENV}    ${UserName}    ${value}    ${Doc.No}
    END

Scan Inbound Order Multi SKU
    [Arguments]    ${Doc.No}    ${ENV}    ${UserName}
    #Search about Doc.No
    Sleep    3s
    Click Filter Button
    Sleep    2s
    Input Filter Value    ${Doc.No}
    #Click Scan from Actions
    Sleep    2s
    Click Row Actions And Select Scan
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
    Safe Click Button    xpath=//button[contains(text(), 'Submit')]
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
    Safe Click Button    xpath=//button[contains(text(), 'Submit')]
    Sleep    5s
    
Edit Order
    [Arguments]    ${Doc.No}     ${Qty Num}
    Go Back
    #Search about Doc.No
    Sleep    3s
    Click Filter Button
    Sleep    2s
    Input Filter Value    ${Doc.No}
    #Click Edit from Actions
    Sleep    2s
    Safe Click Button    xpath=//button[@aria-label='Row Actions']
    Sleep    2s
    # Navigate to Edit option (3rd item)
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    Sleep    2s
    #Edit Qty
    Wait And Click Element    xpath=//*[@id="lines[0].quantity"]
    Press Keys    None    BACKSPACE
    Wait For Element And Input    xpath=//*[@id="lines[0].quantity"]    ${Qty Num}
    Sleep    2s
    #Confirm Edit
    Click Button    xpath=//button[contains(text(),'Confirm')]

Random String
    ${str}  Generate Random String    8
    RETURN    ${str}