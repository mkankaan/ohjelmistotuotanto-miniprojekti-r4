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
    Create Citation  testkey  Book  Clean Code  Martin, Robert  2008  Prentice Hall  123-456-78987-6-5  10.1000/182  https://www.example.com
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
    Create Citation Required Fields  key1  Book  Example1
    Create Citation Required Fields  key2  Book  Example2
    Create Citation Required Fields  key3  Book  Example3
    Page Should Contain  key1
    Page Should Contain  Example1
    Page Should Contain  key2
    Page Should Contain  Example2
    Page Should Contain  key3
    Page Should Contain  Example3



