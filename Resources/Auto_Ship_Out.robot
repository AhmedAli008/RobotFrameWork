*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Auto Ship Out
    [Arguments]     ${Name}    ${Supplier}
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    Search File    ${Name}
    Shipout File    ${Supplier}

Search File
    [Arguments]     ${File_Name}
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    2s
    Input Text    id=filter-name    ${File_Name}
    Sleep    2s

Shipout File
    [Arguments]    ${Supplier}
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Ship Out')]
    #Press Keys    None    ARROW_DOWN
    #Press Keys    None    ARROW_DOWN
    #Press Keys    None    ENTER
    Sleep    2s
    Input Text    xpath=//*[@id="partner"]    ${Supplier}
    Sleep    2s
    #Click Element    xpath=/html/body/div[4]/div[3]
    Sleep    3s
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    Click Button    xpath=//button[contains(text(), 'Confirm')]
    Sleep    3s
    Click Button    xpath=/html/body/div[7]/div[3]/div/div[1]/button