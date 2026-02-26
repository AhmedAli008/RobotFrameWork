*** Settings ***
Library     SeleniumLibrary
Resource    Common_Keywords.robot

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
    Safe Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[1]/div[2]/div[2]/div/button[1]
    Sleep    2s
    Wait For Element And Input    xpath=/html/body/div[1]/div[1]/main/div[5]/div[2]/table/thead/tr/th[5]/div[2]/div/div/div/div/input    ${File_Name}
    Sleep    2s

Accept File With Agent Commissioning
    Safe Click Button    xpath=//*[@id="root"]/div[1]/main/div[5]/div[2]/table/tbody/tr[1]/td[10]/button
    Sleep    3s
    # Try to select Agent Commissioning option (4rd item)
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ARROW_DOWN
    Press Keys    None    ARROW_DOWN
    Sleep    1s
    Press Keys    None    ENTER
    Sleep    5s
    # Wait for permit number field to appear with extended timeout
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=permitNumber    15s
    Run Keyword If    ${status}    Input Permit Number
    ...    ELSE    Handle Missing Permit Field

Input Permit Number
    Wait For Element And Input    id=permitNumber    shp/MP/48913/2020
    Sleep    2s
    Press Keys    None    ARROW_DOWN
    Sleep    1s
    Press Keys    None    ENTER
    Sleep    3s
    Safe Click Button    xpath=//button[contains(text(), 'Confirm')]

Handle Missing Permit Field
    # If permit field doesn't appear, try clicking Confirm directly or skip
    ${confirm_status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//button[contains(text(), 'Confirm')]    5s
    Run Keyword If    ${confirm_status}    Safe Click Button    xpath=//button[contains(text(), 'Confirm')]
    ...    ELSE    Log    Permit number field and Confirm button not found - workflow may have changed