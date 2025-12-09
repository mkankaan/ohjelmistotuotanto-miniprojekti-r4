*** Settings ***
Resource  resource.robot
Suite Setup  Open And Configure Browser
Suite Teardown  Close Browser
Test Setup  Reset Citations And Go To Start Page
Test Teardown  Reset Citations And Go To Start Page

*** Test Cases ***
Select All Successfully
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Wait Until Page Contains Element    css=#type option    timeout=10
    Input Text  name=citation_key  TestKey2024
    Select From List By Index    id=type    1
    Input Text  name=title  Test Book Title
    Click Button  Create
    Go To  ${HOME_URL}
    Page Should Contain  Test Book Title
    Click Button  Select all
    Page Should Contain  Citations selected: 1

De-select All Successfully
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
    Page Should Contain  Amount of citations: 2
    Click Button  Select all
    Page Should Contain  Citations selected: 2
    Click Button  De-select all
    Page Should Contain  Citations selected: 0

Delete Selected Successfully
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
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Wait Until Page Contains Element    css=#type option    timeout=10
    Input Text  name=citation_key  ThirdCitation
    Select From List By Index    id=type    1
    Input Text  name=title  Third Book
    Click Button  Create
    Go To  ${HOME_URL}
    Page Should Contain  Amount of citations: 3
    Click Button  Select all
    Page Should Contain  Citations selected: 3
    Click Button  Delete selected
    Handle Alert  ACCEPT
    Page Should Contain  Amount of citations: 0
