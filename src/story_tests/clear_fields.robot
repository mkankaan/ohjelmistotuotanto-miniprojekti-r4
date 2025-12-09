*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
At start clear button should be disabled
    Go To  ${NEW_CITATION_URL}
    Title Should Be  Create a new citation
    Element Should Be Disabled  clear

Clear button should be enabled if any field is filled
    Go To  ${NEW_CITATION_URL}
    Input Text  name=title  Example
    Element Should Be Enabled  clear

Clicking clear button should clear all form fields
    Go To  ${NEW_CITATION_URL}
    Input Text  name=citation_key  ex
    Select From List By Label  name=type  Book
    Input Text  name=title  Example
    Input Text  name=author  Moomin Troll
    Input Text  name=year  1990
    Input Text  name=publisher  Moominvalley
    Input Text  name=isbn  444-555-66666-7-8
    Input Text  name=doi  10.1000/moomin
    Input Text  name=url  https://www.moominvalley.io
    Input Text  name=urldate  8.12.2025
    Click Button  clear
    Textfield Should Contain  name=citation_key  ${EMPTY}
    Textfield Should Contain  name=title  ${EMPTY}
    Textfield Should Contain  name=author  ${EMPTY}
    Textfield Should Contain  name=year  ${EMPTY}
    Textfield Should Contain  name=publisher  ${EMPTY}
    Textfield Should Contain  name=isbn  ${EMPTY}
    Textfield Should Contain  name=doi  ${EMPTY}
    Textfield Should Contain  name=url  ${EMPTY}
    Textfield Should Contain  name=urldate  ${EMPTY}

