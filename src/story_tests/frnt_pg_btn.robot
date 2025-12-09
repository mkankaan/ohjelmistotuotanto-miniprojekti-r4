*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown  Reset Citations And Go To Start Page

*** Test Cases ***
User can return to front page from create citation page
	Go To  ${NEW_CITATION_URL}
	Click Element  id=front_page
	Title Should Be  Citation helper


User can return to front page from bibtex page
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Wait Until Page Contains Element    css=#type option    timeout=10
    Input Text  name=citation_key  TestKey2024
    Select From List By Index    id=type    1
    Input Text  name=title  Test Book Title
    Click Button  Create
    Go To  ${HOME_URL}
    Page Should Contain  Test Book Title
    Click Button  Select all
	Click Button  Generate BibTeX
	Wait Until Page Contains  Front page  timeout=5
	Click Button  Front page
	Wait Until Page Contains  Citation helper  timeout=5
	
User can return to front page from edit citation page
	Create Citation Required Fields  example  Book  Example Title
	Click Button  Edit
	Click Element  id=front_page
	Title Should Be  Citation helper

Front page does not contain front page button
	Go To  ${HOME_URL}
	Page Should Not Contain Element  id=front_page
