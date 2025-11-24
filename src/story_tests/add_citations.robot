*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations

*** Test Cases ***
At start there are no citations
    Go To  ${HOME_URL}
    Title Should Be  Citation helper
    Page Should Contain  Amount of citations: 0

Citing a book should succeed
    Go To  ${HOME_URL}
    Create Citation Required Fields  example  Book  Example
    Page Should Contain  Amount of citations: 1

Citing a book with only a key and name should succeed
    Go To  ${HOME_URL}
    Click Button  Create new citation
    Input Text  name=citation_key  example
    Select From List By Label  name=type  Book
    Input Text  name=title  Example
    Click Button  Create
    Page Should Contain  Amount of citations: 1

Create button should be disabled if year field contains a non numerical value
    Go To  ${HOME_URL}
    Click Button  Create new citation
    Input Text  name=citation_key  example
    Select From List By Label  name=type  Book
    Input Text  name=title  Example
    Input Text  name=year  YES
    Element Should Be Disabled  create

Citing a book with one author should succeed with all fields visible
    Go To  ${HOME_URL}
    Create Citation  example  Book  Example  Ex1  3033  Ex  Ex  Ex  Ex
    Page Should Contain  Citation key
    Page Should Contain  Title
    Page Should Contain  Author
    Page Should Contain  Publisher
    Page Should Contain  Year
    Page Should Contain  ISBN
    Page Should Contain  DOI
    Page Should Contain  URL

Citing a book with multiple authors should succeed
    Go To  ${HOME_URL}
    Create Citation  example  Book  Example  Ex1 and Ex2  3033  Ex  Ex  Ex  Ex
    Page Should Contain  Authors
