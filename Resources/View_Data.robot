*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
View Data
    [Arguments]     ${Name}
    Sleep    2s
    Execute JavaScript    document.body.style.zoom='70%'
    Search File    ${Name}
    View
Search File
    [Arguments]     ${File_Name}
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[1]/div[2]/div[2]/div/button[1]
    Sleep    1s
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[5]/div[2]/table/thead/tr/th[5]/div[2]/div/div/div/div/input    ${File_Name}
    Sleep    1s

View 
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]/table/tbody/tr[1]/td[10]/button
    Sleep    2s
    #Click Element    xpath=/html/body/div[7]/div[3]/ul/li[2]
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ARROW_DOWN
    Sleep    1s 
    Press Keys    None    ENTER