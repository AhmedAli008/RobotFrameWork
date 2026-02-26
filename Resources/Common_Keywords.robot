*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Safe Click Element
    [Documentation]    Safely clicks an element by scrolling into view and using JS click if needed
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Wait Until Element Is Enabled    ${locator}    ${timeout}
    Scroll Element Into View    ${locator}
    Sleep    0.5s
    ${status}=    Run Keyword And Return Status    Click Element    ${locator}
    Run Keyword If    not ${status}    JS Click Element    ${locator}

Safe Click Button
    [Documentation]    Safely clicks a button by scrolling into view and using JS click if needed
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Wait Until Element Is Enabled    ${locator}    ${timeout}
    Scroll Element Into View    ${locator}
    Sleep    0.5s
    ${status}=    Run Keyword And Return Status    Click Button    ${locator}
    Run Keyword If    not ${status}    JS Click Element    ${locator}

JS Click Element
    [Documentation]    Clicks an element using JavaScript (bypasses overlay issues)
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute JavaScript    arguments[0].click();    ARGUMENTS    ${element}

Wait And Click Element
    [Documentation]    Waits for element and clicks using JavaScript
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Sleep    1s
    JS Click Element    ${locator}

Scroll And Click
    [Documentation]    Scrolls to element and clicks
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Scroll Element Into View    ${locator}
    Sleep    0.5s
    JS Click Element    ${locator}

Wait For Element And Input
    [Documentation]    Waits for element to be visible then inputs text
    [Arguments]    ${locator}    ${text}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Wait Until Element Is Enabled    ${locator}    ${timeout}
    Input Text    ${locator}    ${text}

Close Overlay If Present
    [Documentation]    Closes any overlay/modal that might be blocking clicks
    ${status}=    Run Keyword And Return Status    Click Element    xpath=//button[contains(@class, 'close') or contains(text(), 'Close') or contains(text(), 'X')]
    Run Keyword If    ${status}    Sleep    1s
