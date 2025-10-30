*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
&{GTIN}
${Permit Name}    shp/MP/48913/2020
${TABLE_ROWS}     xpath=//*[@id="root"]/div[1]/main/div[3]/div[2]/table/tbody/tr

*** Keywords ***
Permit Number
    [Arguments]    ${UserName}
    Open Permit Number
    Search about Permit
    Veirfy Permit Number    ${UserName}

Open Permit Number
    Click Element    xpath=//*[@id="permit-number"]

Search about Permit
    Sleep    1s
    Click Button     xpath=//button[@aria-label="Show/Hide filters"]
    Sleep    1s
    Input Text     xpath=/html/body/div[1]/div[1]/main/div[3]/div[2]/table/thead/tr/th[2]/div[2]/div/div/div/div/input     ${Permit Name}
    Sleep    2s

Veirfy Permit Number 
    [Arguments]    ${UserName}
    ${count}=    Get Element Count    ${TABLE_ROWS}
    TRY
        Should Be Equal As Integers    ${count}    2
        Delete Permit Number
        Add Permit Number    ${UserName}
    EXCEPT
        Add Permit Number    ${UserName}
    END

Delete Permit Number
    Click Button     xpath=//button[@aria-label="Row Actions"]
    Sleep    2s
    #Click Element    xpath=/html/body/div[8]/div[3]/ul/li[2]
    Press Keys    None    ARROW_DOWN
    Sleep    1s 
    Press Keys    None    ENTER
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'Confirm')]

Add Permit Number
    [Arguments]    ${UserName}
    #Add Permit
    Sleep    2s
    Click Button    xpath=//button[contains(text(), 'New Permit')]
    Sleep    2s
    #Select GTIN
    &{GTIN}    Check GTIN based UserName    ${UserName}
    #Add Permit Name
    Input Text    xpath=//input[@id="permitNumber"]   ${Permit Name}
    #Select Product 
    Click Element    xpath=//*[@id="permitNumberLines[0].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Input Text    xpath=/html/body/div[7]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input    ${GTIN.gtin1}
    Sleep    2s
    Click Element    xpath=/html/body/div[7]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[1]
    #Create Lote
    ${Lot}    Random Lot
    Input Text    xpath=//input[@id="permitNumberLines[0].lot"]     ${Lot}
    #Add Qty
    Input Text    xpath=//input[@id="permitNumberLines[0].quantity"]    100
    #Add Line
    Click Button    xpath=//button[contains(text(), 'Add Line')]
    Sleep    2s
    #Select Product 
    Click Element    xpath=//*[@id="permitNumberLines[1].product"]/div[1]/div/div[1]/input
    Sleep    2s
    Input Text    xpath=/html/body/div[7]/div/div/div[2]/div/div[5]/div/table/tbody/tr[2]/td[2]/div/div[2]/div/div/div[1]/input    ${GTIN.gtin2}
    Sleep    2s
    Click Element    xpath=/html/body/div[7]/div/div/div[2]/div/div[6]/div/div/div[1]/div/table/tbody/tr[1]
    #Create Lote
    ${Lot}    Random Lot
    Input Text    xpath=//input[@id="permitNumberLines[1].lot"]     ${Lot}
    #Add Qty
    Input Text    xpath=//input[@id="permitNumberLines[1].quantity"]    100
    #Confirm 
    Click Button    xpath=//button[contains(text(), 'Confirm')]



Check GTIN based UserName
    [Arguments]    ${UserName}
    IF    ${UserName[:13]} == 6251151000003
        ${GTIN}  Create Dictionary
        ...    gtin1=06251151000201  
        ...    gtin2=06251151000157
        RETURN    &{GTIN}
    ELSE IF    ${UserName[:13]} == 6297001303009
        &{GTIN}   Create Dictionary
        ...    gtin1=08430469004189  
        ...    gtin2=08430469000075
        RETURN    &{GTIN}
    END

Random Lot
    ${str}  Generate Random String    5
    RETURN    ${str}