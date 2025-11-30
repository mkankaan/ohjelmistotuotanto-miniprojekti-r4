*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
At start there are no citations
    Go To  ${HOME_URL}
    Title Should Be  Citation helper
    Page Should Contain  Amount of citations: 0

Citing a book with only a key and name should succeed
    Create Citation Required Fields  example  Book  Example
    Page Should Contain  Amount of citations: 1

Create button should be disabled if year field contains a non numerical value
    Go To  ${NEW_CITATION_URL}
    Fill Citation Required Fields  example  Book  Example
    Input Text  name=year  YES
    Click Button  create
    Page Should Contain  Create a new citation                     # create button might be enabled so better to check if we are still on the create page

Create button should be disabled if citation key field contains a non unique value
    Create Citation Required Fields  example  Book  Example
    Fill Citation Required Fields  example  Book  Example
    Sleep  5s					 # wait for possible async validation
    Click Button  create
    Page Should Contain  Create a new citation

Citing a book with one author should succeed with all fields visible
    Create Citation  example  Book  Example  Ex1  3033  Ex  123-456-78987-6-5  10.1000/182  https://www.example.com
    Title Should Be  Citation helper
    Page Should Contain  Citation key
    Page Should Contain  Title
    Page Should Contain  Author
    Page Should Contain  Publisher
    Page Should Contain  Year
    Page Should Contain  ISBN
    Page Should Contain  DOI
    Page Should Contain  URL

Citing a book with multiple authors should succeed
    Create Citation  example  Book  Example  Ex1 and Ex2  3033  Ex  123-456-78987-6-5  10.1000/182  https://www.example.com
    Page Should Contain  Authors
   
Citing a book after editing a non unique citation key should succeed
    Create Citation Required Fields  example  Book  Example
    Fill Citation Required Fields  example  Book  Example
    Page Should Contain  Create a new citation
    Input Text  name=citation_key  notExample
    Input Text  name=title  Example
    Click Button  create
    Page Should Contain  Amount of citations: 2