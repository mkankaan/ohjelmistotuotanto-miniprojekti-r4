*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Todos

*** Test Cases ***
At start there are no todos
    Go To  ${HOME_URL}
    Title Should Be  Citation helper
    Page Should Contain  Amount of citations: 0

Citing a book should succeed
    Go To  ${HOME_URL}
    Click Link  Create new citation
    Select From List By Label  name=type  Book
    Input Text  name=title  Example
    Input Text  name=author  Example
    Input Text  name=year  3023
    Click Button  Create
    Page Should Contain  Amount of citations: 1

