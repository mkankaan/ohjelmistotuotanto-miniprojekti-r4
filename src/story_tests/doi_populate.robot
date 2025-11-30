*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations

*** Test Cases ***
At start create and populate buttons are disabled
  Go To  ${NEW_CITATION_URL}
  Element Should Be Disabled  create
  Element Should Be Disabled  submit-doi

Populate should remain disabled with invalid input
  Go To  ${NEW_CITATION_URL}
  Input Text  name=doi-populate  time-flies-like-an-arrow_fruit-flies-like-a-banana
  Element Should Be Disabled  submit-doi
  Input Text  name=doi-populate  10.11111/  clear=True
  Element Should Be Disabled  submit-doi
  Input Text  name=doi-populate  10.11111/Ice-Toboggan Corki  clear=True
  Element Should Be Disabled  submit-doi
  Input Text  name=doi-populate  11.1111/whatsapp  clear=True
  Element Should Be Disabled  submit-doi
  Input Text  name=doi-populate  10.111/malpite  clear=True

Populate should be enabled with valid input
  Go To  ${NEW_CITATION_URL}
  Input Text  name=doi-populate  10.1145/3699538.3699545  clear=True
  Element Should Be Enabled  submit-doi
  Input Text  name=doi-populate  https://doi.org/10.1145/3699538.3699545  clear=True
  Element Should Be Enabled  submit-doi

Citate creation succeeds with valid DOI
  Go To  ${HOME_URL}
  Page Should Contain  Amount of citations: 0
  Click Button  Create new citation
  Input Text  name=citation_key  monarch-kogmaw
  Input Text  name=doi-populate  10.1145/3699538.3699545
  Element Should Be Enabled  submit-doi
  Click Button  submit-doi
  Wait Until Element Is Enabled  create  timeout=10
  Click Button  create
  Page Should Contain  Amount of citations: 1
