*** Settings ***
Library     SeleniumLibrary
Library     ../API/Inbound_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

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
    [Arguments]     ${ENV}
    Sleep    2s
    Go To Home
    Wait Until Page Contains Element    ${Selector}
    Go To AdHoc Inbound
    Search About Supplier
    Select Supplier
    Sleep    1s
    Inbound Adhoc Scan      ${ENV}    ${data['parent1_to_scan']}
    Inbound Adhoc Scan      ${ENV}    ${data['parent2_to_scan']}
    Inbound Adhoc Scan      ${ENV}    ${data['parent3_to_scan']}
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Wait Until Page Contains Element   ${Wait_Button}
    Submit Scan
    Sleep    3s
Go To AdHoc Inbound
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[1]/div/button
    #Wait Until Page Contains Element   ${Page_Load}
    Sleep    3s
    Click Button    id=full-width-tab-1

Search About Supplier
    Wait Until Page Contains Element    ${Table_Load}
    Click Button    xpath=//*[@id="full-width-tabpanel-1"]/div/div[2]/div[1]/div[2]/div[2]/div/button[1]
    Wait Until Page Contains Element   ${Text_Load}
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[2]/div/div/div[2]/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input    ${data['supplier_to_add_shipment_file']}

Select Supplier
    Wait Until Page Contains Element   ${Action_Load}
    Sleep    1s
    #Wait Until Element Is Enabled    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]   timeout=5s
    Click Button    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]
    Wait Until Page Contains Element   ${Drop_List_Wait}
    Click Element    xpath=/html/body/div[4]/div[3]/ul/li

Submit Scan
    Click Button    xpath=//button[contains(text(), 'Submit')]

Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]/div[2]


