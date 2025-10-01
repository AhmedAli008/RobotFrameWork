*** Settings ***
Library      SeleniumLibrary
#Library      ../API/Token_SSCC_Permit_Num.py


*** Variables ***
${URL}
${Browser}  chrome

*** Keywords ***
Login Page
    [Arguments]  ${ENV}   ${Username}     ${Password}
    Open Browser to Login Page      ${ENV}
    #Get Token From Login    ${ENV}    ${Username}    ${Password}
    Maximize Browser Window
    Sleep    3s
    Type In Username    ${username}
    Type In Password    ${password}
    Submit credentials
    Welcome Page Should be Open

Open Browser to Login Page
    [Arguments]     ${ENV}
    ${URL}   Set Variable If
    ...     '${ENV}' == 'test'    https://wes.test.originsysglobal.com/
    ...     '${ENV}' == 'stage'   https://atp.aws.originsysglobal.com/
    Open Browser    ${URL}  ${Browser}
    Title Should Be     ORIDX TT

Type In Username
    [Arguments]     ${Username}
    Input Text    id=username    ${Username}

Type In Password
    [Arguments]     ${Password}
    Input Text    id=password    ${Password}

Submit credentials
    Click Button    xpath=//button[contains(text(), 'LOGIN')]

Welcome Page Should be Open
    Title Should Be    ORIDX TT

