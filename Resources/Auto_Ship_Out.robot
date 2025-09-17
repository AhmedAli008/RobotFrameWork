*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Auto Ship Out
    [Arguments]     ${Name}
    Sleep    2s
    Search File    ${Name}
    Shipout File

Search File
    [Arguments]     ${File_Name}
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[1]/div[2]/div[2]/div/button[1]
    Sleep    2s
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[5]/div[2]/table/thead/tr/th[5]/div[2]/div/div/div/div/input    ${File_Name}
    Sleep    2s

Shipout File
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]/table/tbody/tr[1]/td[10]/button
    Sleep    2s
    Click Element    xpath=/html/body/div[4]/div[3]/ul/li[4]
    Sleep    2s
    Input Text    xpath=//*[@id="partner"]    6294018311140
    Sleep    2s
    #Click Element    xpath=/html/body/div[4]/div[3]
    #Sleep    3s
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ENTER
    Click Button    xpath=/html/body/div[4]/div[3]/div/form/div[3]/div/button
    Sleep    3s
    Click Button    xpath=/html/body/div[4]/div[3]/div/div[1]/button