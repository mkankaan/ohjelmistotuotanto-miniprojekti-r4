*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
User Can Generate Citation Key Using Only Title
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anexampl
	Click Button  create
	Page Should Contain  Amount of citations: 1

User Can Generate Citation Key Using Title and Year
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Input Text  name=year  2023
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anex2023
	Click Button  create
	Page Should Contain  Amount of citations: 1

Non Unique Title Only Citation Key Gets Suffix Number
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anexampl
	Click Button  create
	Page Should Contain  Amount of citations: 1
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anexampl1
	Click Button  create
	Page Should Contain  Amount of citations: 2

Non Unique Title and Year Citation Key Gets Suffix Number
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Input Text  name=year  2023
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anex2023
	Click Button  create
	Page Should Contain  Amount of citations: 1
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Input Text  name=year  2023
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anex20231
	Click Button  create
	Page Should Contain  Amount of citations: 2

Generation Overrides Existing Citation Key
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Input Text  name=citation_key  notck
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anexampl
	Click Button  create
	Page Should Contain  Amount of citations: 1

User Can Override Generated Citation Key
	Go To  ${NEW_CITATION_URL}
	Input Text  name=title  An Example Title
	Click Element  id=generate_ck
	Sleep  1s
	Textfield Value Should Be  css:input[name="citation_key"]  anexampl
	Sleep  1s
	Click Element  id=generate_ck
	Sleep  1s
	Input Text  name=citation_key  customck
	Click Button  create
	Page Should Contain  Amount of citations: 1