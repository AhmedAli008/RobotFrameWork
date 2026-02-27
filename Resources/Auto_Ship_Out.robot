*** Settings ***
Library     SeleniumLibrary
Resource    Common_Keywords.robot

*** Keywords ***
Auto Ship Out
    [Arguments]     ${Name}    ${Supplier}
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Search File    ${Name}
    Shipout File    ${Supplier}

Search File
    [Arguments]     ${File_Name}
    Safe Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[1]/div[2]/div[2]/div/button[1]
    Sleep    2s
    Wait For Element And Input    xpath=/html/body/div[1]/div[1]/main/div[5]/div[2]/table/thead/tr/th[5]/div[2]/div/div/div/div/input    ${File_Name}
    Sleep    2s

Shipout File
    Safe Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]/table/tbody/tr[1]/td[10]/button
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Ship Out')]
    #Press Keys    None    ARROW_DOWN
    #Press Keys    None    ARROW_DOWN
    #Press Keys    None    ENTER
    Sleep    2s
    Wait For Element And Input    xpath=//*[@id="partner"]    6294018311140
    Sleep    2s
    #Click Element    xpath=/html/body/div[4]/div[3]
    Sleep    3s
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    Safe Click Button    xpath=//button[contains(text(), 'Confirm')]
    Sleep    3s
    # Try multiple modal button locators
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=/html/body/div[7]/div[3]/div/div[1]/button    3s
    Run Keyword If    ${status}    JS Click Element    xpath=/html/body/div[7]/div[3]/div/div[1]/button
    ...    ELSE    Click Modal Close Button

Click Modal Close Button
    # Fallback: try other modal button locators
    ${status8}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=/html/body/div[8]/div[3]/div/div[1]/button    2s
    Run Keyword If    ${status8}    JS Click Element    xpath=/html/body/div[8]/div[3]/div/div[1]/button
    ...    ELSE    Try Generic Modal Button

Try Generic Modal Button
    # Try generic modal close button
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'MuiDialog')]//button    2s
    Run Keyword If    ${status}    JS Click Element    xpath=//div[contains(@class, 'MuiDialog')]//button
    ...    ELSE    Press Keys    None    ESCAPE