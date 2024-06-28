*** Settings ***
Library           SeleniumLibrary
Library           String
Variables         ../test_data/table_data.json
Resource          ../../src_main/resources/user_keywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           Collections

*** Test Cases ***
HomePage
    [Setup]    Open Window    edge
    Wait Until Element Is Visible    //*//*[text()='Table Data']    30
    Click Element    //*//*[text()='Table Data']
    Wait Until Element Is Visible    //*//*[@id='jsondata']    30
    ${jfile}    Load JSON From File    D:\\RobotFramework\\test_data\\table_data.json
    ${json_name}=    Get Value From JSON    ${jfile}    $.members[:].name
    Log To Console    ${json_name}
    ${json_age}=    Get Value From JSON    ${jfile}    $.members[:].age
    Log To Console    ${json_age}
    ${json_data}=    Transform To Json    ${json_name}    ${json_age}
    Log To Console    ${json_data}
    ${new_item}=    Evaluate    json.dumps(${json_data})
    Log To Console    ${new_item}
    Input Text    //*//*[@id='jsondata']    ${new_item}
    Wait Until Element Is Visible    //*//*[@id='refreshtable']    50
    Scroll Element Into View    //*//*[@id='refreshtable']
    Sleep    3
    Click Button    //*//*[@id='refreshtable']
    ${rows} =    Get Element Count    //table[@id="dynamictable"]//tr
    Wait Until Element Is Visible    id=dynamictable    10
    FOR    ${index}    IN RANGE    2    ${rows}+1
    ${row} =    Get WebElement    //*[@id="dynamictable"]//tr[${index}]
    @{cells} =    Get WebElements    //*[@id="dynamictable"]//tr[${index}]//td
    ${data} =    Create List
    FOR    ${cell}    IN    @{cells}
        Sleep    1s
        Wait Until Element Is Visible    ${cell}
        ${text} =    Get Element Attribute    ${cell}    innerText
        ${data} =    Evaluate    [cell.text for cell in $cells]
        Log    ${cell} contains text: ${text}
    END
    Log To Console    ${data}
    END
    FOR    ${i}    IN RANGE    0    ${json_name.__len__()}
        ${name}=    Get From List    ${json_name}    ${i}
        ${age}=    Get From List    ${json_age}    ${i}
        ${dict_item} =    Create Dictionary    ${name}    ${age}
        Log To Console    ${dict_item}
    END

*** Keywords ***
Transform To Json
    [Arguments]    ${keys}    ${values}
    ${json_list} =    Create List
    FOR    ${i}    IN RANGE    0    ${keys.__len__()}
        ${name}=    Get From List    ${keys}    ${i}
        ${age}=    Get From List    ${values}    ${i}
        ${dict_item} =    Create Dictionary    name=${name}    age=${age}
        Append To List    ${json_list}    ${dict_item}
    END
    [Return]    ${json_list}

Comparable Json
    [Arguments]    ${keys}    ${values}
    ${json_ls} =    Create List
    FOR    ${i}    IN RANGE    0    ${keys.__len__()}
        ${name}=    Get From List    ${keys}    ${i}
        ${age}=    Get From List    ${values}    ${i}
        ${dict_item} =    Create Dictionary    ${name}    ${age}
        Append To List    ${json_ls}    ${dict_item}
    END
    [Return]    ${json_ls}
