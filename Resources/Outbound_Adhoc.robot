*** Settings ***
Library     SeleniumLibrary
Library     ../API/Outbound_Scan.py
Library     Collections
Variables   ../API/Outbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Variables ***
${Wait_Time}    20s
${Home_Page}    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[2]/div/button
${Tag_Wait}     id=full-width-tab-1
${Table_Wait}   xpath=//*[@id="full-width-tabpanel-1"]/div
${Text_Wait}    xpath=//*[@id="full-width-tabpanel-1"]/div/div/div[2]/table/thead/tr/th[2]
${Action_Wait}  xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]
${Drop_Wait}    xpath=/html/body/div[4]/div[3]/ul/li
${Button_Wait}  xpath=//button[contains(text(), 'Ship Out')]

*** Keywords ***
Outbound Adhoc
    #Wait Until Page Contains Element    ${Home_Page}
    [Arguments]     ${ENV}
    Sleep    3s
    Go TO Outbound AdHoc
    Search about Adhoc Supplier
    Select Adhoc Supplier
    Sleep    2s
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        Outbound Adhoc Scan    ${ENV}    ${value}
    END 
    Sleep    2s
    Reload Page
    #Sleep    3s
    #Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Submit Ship Out
    Sleep    5s

Outbound Adhoc SGTIN
    #Wait Until Page Contains Element    ${Home_Page}
    [Arguments]     ${ENV}
    Sleep    3s
    Go TO Outbound AdHoc
    Search about Adhoc Supplier
    Select Adhoc Supplier
    Sleep    2s
    FOR    ${key}    ${value}    IN    &{data_SGTIN}
        Outbound Adhoc Scan    ${ENV}    ${value}
    END 
    Sleep    2s
    Reload Page
    #Sleep    3s
    #Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Submit Ship Out
    Sleep    5s


Go TO Outbound AdHoc
    Sleep    2s
    Click Element    id=logistic-operations
    Sleep    1s
    Click Element    id=outbound-orders
    #Wait Until Page Contains Element   ${Tag_Wait}
    Sleep    3s
    Click Button    id=full-width-tab-1
    Wait Until Page Contains Element   ${Table_Wait}

Search about Adhoc Supplier
    Click Button    xpath=//*[@id="full-width-tabpanel-1"]/div/div/div[1]/div[2]/div[2]/div/button[1]
    Wait Until Page Contains Element   ${Text_Wait}
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[2]/div/div/div/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input    ${outbound_supplier}

Select Adhoc Supplier
    Wait Until Page Contains Element   ${Action_Wait}
    Sleep    1s
    Click Button    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]
    #Wait Until Page Contains Element   ${Drop_Wait}
    #Click Element    xpath=/html/body/div[4]/div[3]/ul/li
    Sleep    2s
    Press Keys    None    ENTER

Submit Ship Out
    #Wait Until Page Contains Element    ${Button_Wait}
    Click Button    xpath=//button[contains(text(), 'Ship Out')]
