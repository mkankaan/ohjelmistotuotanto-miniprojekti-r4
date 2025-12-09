*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations And Go To Start Page
Test Teardown  Reset Citations And Go To Start Page

*** Test Cases ***
Citations with year in selected range are shown
    Create Citation Required Fields And Year  test1  Book  Example1  1970
    Create Citation Required Fields And Year  test2  Book  Example2  2011
    Input Text  name=min_year  2000
    Input Text  name=max_year  2020
    Click Button  Apply
    Page Should Contain  Example2

Citations with year outside selected range are not shown
    Create Citation Required Fields And Year  test1  Book  Example1  1970
    Create Citation Required Fields And Year  test2  Book  Example2  2025
    Input Text  name=min_year  2000
    Input Text  name=max_year  2020
    Click Button  Apply
    Page Should Not Contain  Example1
    Page Should Not Contain  Example2

One of the year fields may be left empty
    Create Citation Required Fields And Year  test1  Book  Example1  1970
    Create Citation Required Fields And Year  test2  Book  Example2  2025
    Input Text  name=min_year  2000
    Click Button  Apply
    Page Should Not Contain  Example1
    Page Should Contain  Example2

Apply button is disabled if input is not a valid year
    Input Text  name=min_year  aaa
    Element Should Be Disabled  filter-apply

Apply button is disabled if given minimum year is greater than given maximum year
    Input Text  name=min_year  2025
    Input Text  name=max_year  1990
    Element Should Be Disabled  filter-apply

Reset button resets filter
    Create Citation Required Fields And Year  test1  Book  Example1  1970
    Input Text  name=min_year  2000
    Click Button  Apply
    Click Button  Reset
    Page Should Contain  Example1

*** Keywords ***
Create Citation Required Fields And Year
    [Arguments]  ${citation_key}  ${type}  ${title}  ${year}
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Input Text  name=citation_key  ${citation_key}
    Select From List By Label  name=type  ${type}
    Input Text  name=title  ${title}
    Input Text  name=year  ${year}
    Click Button  Create

