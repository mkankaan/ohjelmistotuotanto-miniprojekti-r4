*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
User Can Generate Citation Key Automatically
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anexampl
	Click Button  create
	Page Should Contain  Amount of citations: 1

User Can Generate Citation Key Using Year
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Input Text  name=year  2023
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anex2023
	Click Button  create
	Page Should Contain  Amount of citations: 1