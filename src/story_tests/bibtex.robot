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
    Create Citation Required Fields  test  Book  Test
    Click Button  Generate BibTeX
    Page Should Contain  BibTeX

Show Bibtex Correctly
    Create Citation  testkey  Book  Mystery Book  Mystery Author  1990  WSOY  847-397-27609-1-2  10.1000/444  https://www.mysterybook.com  2.4.2011
    Wait Until Page Contains    Amount of citations: 1    timeout=10
    Go To  ${BIBTEX_URL}
    Page Should Contain  @book{testkey,
    Page Should Contain  title = \{Mystery Book\}
    Page Should Contain  author = \{Mystery Author\}
    Page Should Contain  year = \{1990\}
    Page Should Contain  publisher = \{WSOY\}
    Page Should Contain  isbn = \{847-397-27609-1-2\}
    Page Should Contain  doi = \{10.1000/444\}
    Page Should Contain  url = \{https://www.mysterybook.com\}
    Page Should Contain  urldate = \{2.4.2011\}

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


