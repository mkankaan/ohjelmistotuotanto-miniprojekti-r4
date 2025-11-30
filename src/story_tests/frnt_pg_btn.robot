*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations

*** Test Cases ***
User can return to front page from create citation page
	Go To  ${NEW_CITATION_URL}
	Click Element  id=front_page
	Title Should Be  Citation helper


User can return to front page from bibtex page
	Go To  ${BIBTEX_URL}
	Click Element  id=front_page
	Title Should Be  Citation helper
	
User can return to front page from edit citation page
	Create Citation Required Fields  example  Book  Example Title
	Click Button  Edit
	Click Element  id=front_page
	Title Should Be  Citation helper

Front page does not contain front page button
	Go To  ${HOME_URL}
	Page Should Not Contain Element  id=front_page