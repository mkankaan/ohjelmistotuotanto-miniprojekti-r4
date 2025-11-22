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

All Citation Fields Are Shown
    Go To  ${HOME_URL}
    Create Book Citation  testkey  Clean Code  Martin, Robert  2008  Prentice Hall  123-456-78987-6-5  10.1000/182  https://www.example.com
    Page Should Contain  testkey
    Page Should Contain  Clean Code
    Page Should Contain  Martin, Robert
    Page Should Contain  2008
    Page Should Contain  Prentice Hall
    Page Should Contain  123-456-78987-6-5
    Page Should Contain  10.1000/182
    Page Should Contain  https://www.example.com

Multiple Citations Are Shown
    Reset Citations And Go To Start Page
    Page Should Contain  Amount of citations: 0
    Create Book Citation Required Fields  key1  Example1
    Create Book Citation Required Fields  key2  Example2
    Create Book Citation Required Fields  key3  Example3
    Page Should Contain  key1
    Page Should Contain  Example1
    Page Should Contain  key2
    Page Should Contain  Example2
    Page Should Contain  key3
    Page Should Contain  Example3


*** Keywords ***
Create Book Citation
    [Arguments]  ${citation_key}  ${title}  ${authors}  ${year}  ${publisher}  ${isbn}  ${doi}  ${url}
    Go To  ${NEW_CITATION_URL}
    Input Text  name=citation_key  ${citation_key}
    Select From List By Label  name=type  Book
    Input Text  name=title  ${title}
    Input Text  name=author  ${authors}
    Input Text  name=year  ${year}
    Input Text  name=publisher  ${publisher}
    Input Text  name=isbn  ${isbn}
    Input Text  name=doi  ${doi}
    Input Text  name=url  ${url}
    Click Button  Create

Create Book Citation Required Fields
    [Arguments]  ${citation_key}  ${title}
    Go To  ${NEW_CITATION_URL}
    Input Text  name=citation_key  ${citation_key}
    Select From List By Label  name=type  Book
    Input Text  name=title  ${title}
    Click Button  Create



