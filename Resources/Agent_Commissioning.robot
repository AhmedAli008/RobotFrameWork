*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Agent Commissioning
    [Arguments]     ${Name}
    Sleep    2s
    Execute JavaScript    document.body.style.zoom='70%'
    Search File    ${Name}
    Accept File With Agent Commissioning
    Reload Page


Search File
    [Arguments]     ${File_Name}
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    1s
    Input Text    id=filter-name    ${File_Name}
    Sleep    1s

Accept File With Agent Commissioning
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Commissioning')]
    #Press Keys    None    ARROW_DOWN
    #Press Keys    None    ARROW_DOWN
    #Press Keys    None    ARROW_DOWN
    #Sleep    1s 
    #Press Keys    None    ENTER
    Sleep    2s
    Input Text    id=permitNumber    shp/MP/48913/2020
    Sleep    1s
    Press Keys    None    ARROW_DOWN
    Sleep    1s 
    Press Keys    None    ENTER
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Confirm')]