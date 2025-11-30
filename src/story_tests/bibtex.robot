*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations

*** Test Cases ***
Generate Bibtex Button Should Be Unclickable If There Are No Citations
    Go To  ${HOME_URL}
    Click Button  Generate BibTeX
    Page Should Contain  Citation helper

Button Should Be Clickable If There Are Citations
    Go To  ${HOME_URL}
    Create Citation Required Fields  test  Book  Test
    Click Button  Generate BibTeX
    Page Should Contain  BibTeX

Show Bibtex Correctly
    Go To  ${HOME_URL}
    Create Citation Required Fields  testkey  Book  Clean Code
    Wait Until Page Contains    Amount of citations: 1    timeout=10
    Go To  ${BIBTEX_URL}
    Page Should Contain  @book{testkey,
    Page Should Contain  title = \{Clean Code\}

Show Bibtex Of Multiple Citations
    Go To  ${HOME_URL}
    Create Citation Required Fields  testkey1  Book  Clean Code
    Create Citation Required Fields  testkey2  Book  Even Cleaner Code
    Wait Until Page Contains    Amount of citations: 2    timeout=10
    Go To  ${BIBTEX_URL}
    Page Should Contain  @book{testkey1,
    Page Should Contain  @book{testkey2,
    Page Should Contain  title = \{Clean Code\}
    Page Should Contain  title = \{Even Cleaner Code\}


