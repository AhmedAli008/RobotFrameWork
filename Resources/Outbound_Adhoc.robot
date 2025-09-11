*** Settings ***
Library     SeleniumLibrary
Library     ../API/Outbound_Scan.py
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
    Go To Home
    Sleep    1S
    Wait Until Page Contains Element    ${Selector}
    Go TO Outbound AdHoc
    Search about Adhoc Supplier
    Select Adhoc Supplier
    Sleep    2s
    Outbound Adhoc Scan    ${ENV}   ${data['parent1_to_scan']}
    Outbound Adhoc Scan    ${ENV}   ${data['parent2_to_scan']}
    Outbound Adhoc Scan    ${ENV}   ${data['parent3_to_scan']}
    Sleep    2s
    Reload Page
    #Sleep    3s
    #Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Submit Ship Out
    Sleep    5s
Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]

Go TO Outbound AdHoc
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[2]/div/button
    #Wait Until Page Contains Element   ${Tag_Wait}
    Sleep    3s
    Click Button    id=full-width-tab-1
    Wait Until Page Contains Element   ${Table_Wait}

Search about Adhoc Supplier
    Click Button    xpath=//*[@id="full-width-tabpanel-1"]/div/div/div[1]/div[2]/div[2]/div/button[1]
    Wait Until Page Contains Element   ${Text_Wait}
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[3]/div/div[2]/div/div/div/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input    ${outbound_adhoc_supplier}

Select Adhoc Supplier
    Wait Until Page Contains Element   ${Action_Wait}
    Sleep    1s
    Click Button    xpath=//button[@class="MuiButtonBase-root MuiIconButton-root MuiIconButton-sizeSmall css-1hhhz6a"]
    Wait Until Page Contains Element   ${Drop_Wait}
    Click Element    xpath=/html/body/div[4]/div[3]/ul/li

Submit Ship Out
    #Wait Until Page Contains Element    ${Button_Wait}
    Click Button    xpath=//button[contains(text(), 'Ship Out')]
