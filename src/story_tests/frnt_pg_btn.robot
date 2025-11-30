*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations

*** Test Cases ***
User can return to front page from create citation page
	Go To  ${NEW_CITATION_URL}
	Click Button  Front page
	Title Should Be  Citation helper


User can return to front page from bibtex page
	Go To  ${BIBTEX_URL}
	Click Button  id=front_page
	Title Should Be  Citation helper
	
User can return to front page from edit citation page
	Go To  ${HOME_URL}
	Create Citation Required Fields  example  Book  Example Title
	Click Button  Edit
	Click Button  id=front_page
	Title Should Be  Citation helper

Front page does not contain front page button
	Go To  ${HOME_URL}
	Page Should Not Contain Button  id=front_page