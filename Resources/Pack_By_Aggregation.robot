*** Settings ***
Library     SeleniumLibrary
Library     ../API/Pack_Scan.py
Variables   ../API/Token_SSCC_Permit_Num.py

*** Variables ***
${main_handle}

*** Keywords ***
Pack By Aggregation
    [Arguments]     ${ENV}
    Go To Home
    Open Pack Screen
    Pack By Aggregation To Scan    ${ENV}    ${data['parent1_to_scan']}
    Pack By Aggregation To Scan    ${ENV}    ${data['parent2_to_scan']}
    Pack By Aggregation To Scan    ${ENV}    ${data['parent3_to_scan']}
    Sleep    2s
    Reload Page
    Execute JavaScript    document.body.style.zoom='70%'
    Sleep    3s
    ${Aggregation SSCC}     Submit Pack By Aggregation
    Reload Page
    RETURN   ${Aggregation SSCC}


Go To Home
    Click Element    xpath=//*[@id="root"]/div[1]/div/div/ul/div[1]

Open Pack Screen
    Sleep    1s
    Click Button    xpath=//*[@id="root"]/div[1]/main/div[2]/div[6]/div/button
    
Submit Aggregation
    Click Button    xpath=//button[contains(text(), 'Submit')]

Switch To New Window
    ${windows}=    Get Window Handles
    Switch Window    ${windows[1]}

Close Additional Windows And Return To Main
    #${main_handle}=    Get Window Handles
    #${main_window}=    Get Window Names
    #@{windows}=    Get Window Handles
    #FOR    ${window}    IN    @{windows}
        #Run Keyword If    '${window}' != '${windows}[0]'
        #...    Run Keywords
        #...    Switch Window    ${window}    AND
        #...    Close Window
    #END
    #Switch Window    ${windows}[0]
    ${all_handles}=    Get Window Handles
    #Log    ${all_handles}[2]
    #${all_handles}=    Get Window Handles
    #Log    ${all_handles}[2]
    ${all_handles[1]}   Close Window
    #FOR    ${handle}    IN    @{all_handles}
       # Run Keyword If    '${handle}' != '${main_handle}'    Switch Window    ${handle}
       # Run Keyword If    '${handle}' != '${main_handle}'    Close Window
    #END
    #Switch Window    handle=${main_handle}
    #Execute JavaScript    window.open("https://google.com")

    #TRY
        #Wait Until Keyword Succeeds    5s    1s    Switch To New Window
        #Capture Page Screenshot    new_window.png
    #EXCEPT    NoSuchWindowException
        #Log    Failed to switch, using main window.
        #Switch Window    MAIN
    #END