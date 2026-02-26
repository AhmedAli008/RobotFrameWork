*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Auto Accept
    [Arguments]     ${Name}
    Sleep    2s
    Execute JavaScript    document.body.style.zoom='70%'
    Search File    ${Name}
    Accept File
    Reload Page
    
Search File
    [Arguments]     ${File_Name}
    Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    1s
    Input Text    id=filter-name   ${File_Name}
    Sleep    1s

Accept File
    Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    Click Element    xpath=//p[contains(text(),'Accept')]
    #Press Keys    None    ARROW_DOWN
    #Sleep    1s 
    #Press Keys    None    ENTER
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Confirm')]
    Sleep    3s
    Click Button    xpath=//button[contains(text(), 'Close')]