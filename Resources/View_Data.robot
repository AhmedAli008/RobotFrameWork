*** Settings ***
Library     SeleniumLibrary
Resource    Common_Keywords.robot

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
    Safe Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[1]/div[2]/div[2]/div/button[1]
    Sleep    2s
    Wait For Element And Input    xpath=/html/body/div[1]/div[1]/main/div[5]/div[2]/table/thead/tr/th[5]/div[2]/div/div/div/div/input    ${File_Name}
    Sleep    2s

View
    Safe Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]/table/tbody/tr[1]/td[10]/button
    Sleep    2s
    #Click Element    xpath=/html/body/div[7]/div[3]/ul/li[2]
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ARROW_DOWN
    Sleep    1s
    Press Keys    None    ENTER

Close View
    #Click Button     xpath=/html/body/div[7]/div[3]/div/div[1]/button
    Press Keys    None    ESC