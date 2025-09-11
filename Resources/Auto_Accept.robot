*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Auto Accept
    [Arguments]     ${Name}
    Search File    ${Name}
    Accept File
    Reload Page
Search File
    [Arguments]     ${File_Name}
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[1]/div[2]/div[2]/div/button[1]
    Sleep    1s
    Input Text    xpath=/html/body/div[1]/div[1]/main/div[5]/div[2]/table/thead/tr/th[5]/div[2]/div/div/div/div/input    ${File_Name}
    Sleep    1s

Accept File
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]/table/tbody/tr[1]/td[10]/button
    Sleep    1s
    Click Element    xpath=/html/body/div[4]/div[3]/ul/li[2]
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Confirm')]
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Close')]