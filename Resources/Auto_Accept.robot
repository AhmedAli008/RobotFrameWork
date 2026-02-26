*** Settings ***
Library     SeleniumLibrary
Resource    Common_Keywords.robot

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
    Safe Click Button    xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    2s
    Wait For Element And Input    xpath=/html/body/div[1]/div[1]/main/div[5]/div[2]/table/thead/tr/th[5]/div[2]/div/div/div/div/input    ${File_Name}
    Sleep    2s

Accept File
    Safe Click Button    xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    #Click Element    xpath=/html/body/div[7]/div[3]/ul/li[2]
    Press Keys    None    ARROW_DOWN
    Sleep    1s
    Press Keys    None    ENTER
    Sleep    2s
    Safe Click Button    xpath=//button[contains(text(), 'Confirm')]
    Sleep    3s
    Safe Click Button    xpath=//button[contains(text(), 'Close')]