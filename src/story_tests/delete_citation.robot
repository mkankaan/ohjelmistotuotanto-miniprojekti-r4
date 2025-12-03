*** Settings ***
Resource  resource.robot
Suite Setup  Open And Configure Browser
Suite Teardown  Close Browser
Test Setup  Reset Citations And Go To Start Page

*** Test Cases ***
Delete Citation Successfully
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Wait Until Page Contains Element    css=#type option    timeout=10
    Input Text  name=citation_key  TestKey2024
    Select From List By Index    id=type    1
    Input Text  name=title  Test Book Title
    Click Button  Create
    Go To  ${HOME_URL}
    Page Should Contain  TestKey2024
    Click Delete Button For Citation  TestKey2024
    Handle Alert  ACCEPT
    Page Should Not Contain  TestKey2024

Cancel Delete Citation
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Wait Until Page Contains Element    css=#type option    timeout=10
    Input Text  name=citation_key  TestKey2024
    Select From List By Index    id=type    1
    Input Text  name=title  Test Book Title
    Click Button  Create
    Go To  ${HOME_URL}
    Page Should Contain  TestKey2024
    Click Delete Button For Citation  TestKey2024
    Handle Alert  DISMISS
    Page Should Contain  TestKey2024

Delete Multiple Citations
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Wait Until Page Contains Element    css=#type option    timeout=10
    Input Text  name=citation_key  FirstCitation
    Select From List By Index    id=type    1
    Input Text  name=title  First Book
    Click Button  Create
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Wait Until Page Contains Element    css=#type option    timeout=10
    Input Text  name=citation_key  SecondCitation
    Select From List By Index    id=type    1
    Input Text  name=title  Second Book
    Click Button  Create
    Go To  ${HOME_URL}
    Page Should Contain  FirstCitation
    Page Should Contain  SecondCitation
    Click Delete Button For Citation  FirstCitation
    Handle Alert  ACCEPT
    Page Should Not Contain  FirstCitation
    Page Should Contain  SecondCitation

*** Keywords ***
Click Delete Button For Citation
    [Arguments]  ${citation_key}
    ${xpath}=  Set Variable  //li[contains(., 'Citation key:') and contains(., '${citation_key}')]//button[@type='submit' and contains(text(), 'Delete')]
    Click Button  ${xpath}