*** Settings ***
Library     SeleniumLibrary
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py
Resource    Common_Keywords.robot

*** Variables ***
${Selector}     xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button
${Wait_Time}    20s
${Page_Load}    id=full-width-tab-1
${Table_Load}   xpath=//*[@id="full-width-tabpanel-1"]/div/div[2]/div[1]/div[2]/div[2]
${Text_Load}    xpath=//*[@id="full-width-tabpanel-1"]/div/div[2]/div[2]/table/tbody
${Action_Load}  xpath=//*[@id="full-width-tabpanel-1"]/div/div[2]/div[2]/table/tbody/tr/td[3]/button
${Drop_List_Wait}   xpath=/html/body/div[4]/div[3]/ul/li
${Wait_Button}      xpath=//button[contains(text(), 'Submit')]


*** Keywords ***
Inbound Adhoc
    [Arguments]    ${Supplier}
    Sleep    3s
    Go To AdHoc Inbound
    Search About Supplier    ${Supplier}
    Select Supplier
    Sleep    1s
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        #Inbound Adhoc Scan    ${ENV}    ${Supplier}    ${value}
        Input Text    id=test-scan-field    ${value}
        Click Button    xpath=//button[contains(text(),'Test Scan')]
    END
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Wait Until Page Contains Element   ${Wait_Button}
    Submit Scan
    Sleep    3s

Inbound Adhoc Without Supplier
    Sleep    3s
    Go To AdHoc Inbound
    Select Without Supplier
    FOR    ${key}    ${value}    IN    &{data_SSCC}
        #Inbound Adhoc Without Supplier Scan   ${ENV}    ${value}
        Input Text    id=test-scan-field    ${value}
        Click Button    xpath=//button[contains(text(),'Test Scan')]
    END    
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Wait Until Page Contains Element   ${Wait_Button}
    Submit Scan
    Sleep    3s

Inbound Adhoc sGTIN
    [Arguments]     ${Supplier}
    Sleep    3s
    Go To AdHoc Inbound
    Search About Supplier    ${Supplier}
    Select Supplier
    Sleep    1s
    FOR    ${key}    ${value}    IN    &{data_SGTIN}
        #Inbound Adhoc Scan    ${ENV}    ${Supplier}    ${value}
        Input Text    id=test-scan-field    ${value}
        Click Button    xpath=//button[contains(text(),'Test Scan')]
    END    
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    10s
    Wait Until Page Contains Element   ${Wait_Button}
    Submit Scan
    Sleep    3s

Go To AdHoc Inbound
    Sleep    2s
    Wait And Click Element    id=logistic-operations
    Sleep    2s
    Wait And Click Element    id=inbound
    Execute JavaScript    document.body.style.zoom='70%'
    #Wait Until Page Contains Element   ${Page_Load}
    Sleep    3s
    Safe Click Button    xpath=//button[contains(text(),'Adhoc')]

Search About Supplier
    [Arguments]    ${Supplier}
    Wait Until Page Contains Element    ${Table_Load}
    Sleep    2s
    Safe Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Wait Until Page Contains Element   ${Text_Load}
    Wait For Element And Input    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[2]/div/div/div[2]/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input   ${Supplier}

Select Supplier
    Wait Until Page Contains Element   ${Action_Load}
    Sleep    2s
    #Wait Until Element Is Enabled    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]   timeout=5s
    Safe Click Button    xpath=//button[@aria-label="Row Actions"]
    #Wait Until Page Contains Element   ${Drop_List_Wait}
    Click Element    xpath=//p[contains(text(),'Scan')]
    Sleep    2s
    #Press Keys    None    ENTER

Submit Scan
    Wait Until Element Is Visible    xpath=//button[contains(text(), 'Submit')]    10s
    JS Click Element    xpath=//button[contains(text(), 'Submit')]

Select Without Supplier
    Sleep    2s
    Safe Click Button    xpath=//button[contains(text(), 'Without Supplier')]
    Sleep    2s