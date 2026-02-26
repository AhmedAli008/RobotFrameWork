*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
View Data
    [Arguments]     ${Name}
    Sleep    2s
    Execute JavaScript    document.body.style.zoom='70%'
    Search File    ${Name}
    View
    Sleep    5s
    Close View
Search File
    [Arguments]     ${File_Name}
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    1s
    Input Text    id=filter-name    ${File_Name}
    Sleep    1s

View 
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'View')]
    #Press Keys    None    ARROW_DOWN
    #Press Keys    None    ARROW_DOWN
    #Sleep    1s 
    #Press Keys    None    ENTER

Close View
    #Click Button     xpath=/html/body/div[7]/div[3]/div/div[1]/button
    Press Keys    None    ESC