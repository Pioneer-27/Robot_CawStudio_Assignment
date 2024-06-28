*** Settings ***
Library           SeleniumLibrary
Library           String

*** Variables ***

*** Keywords ***
Open Window
    [Arguments]    ${browser}
    ${url}=    Set Variable    https://testpages.herokuapp.com/styled/tag/dynamic-table.html
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
