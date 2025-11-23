*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations

*** Test Cases ***
Show Bibtex Correctly
    Go To  ${HOME_URL}
    Create Book Citation Required Fields  testkey  Clean Code
    Go To  ${BIBTEX_URL}
    Page Should Contain  @book{testkey,
    Page Should Contain  title = \{Clean Code\}

Show Bibtex Of Multiple Citations
    Go To  ${HOME_URL}
    Create Book Citation Required Fields  testkey1  Clean Code
    Create Book Citation Required Fields  testkey2  Even Cleaner Code
    Go To  ${BIBTEX_URL}
    Page Should Contain  @book{testkey1,
    Page Should Contain  @book{testkey2,
    Page Should Contain  title = \{Clean Code\}
    Page Should Contain  title = \{Even Cleaner Code\}


*** Keywords ***
Create Book Citation Required Fields
    [Arguments]  ${citation_key}  ${title}
    Go To  ${NEW_CITATION_URL}
    Input Text  name=citation_key  ${citation_key}
    Select From List By Label  name=type  Book
    Input Text  name=title  ${title}
    Click Button  Create



