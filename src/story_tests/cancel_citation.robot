*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
Cancel button should cancel text input
    Go To  ${HOME_URL}
    Click Button  Create new citation
    Input Text  citation_key  example
    Click Button  Cancel

Cancel button should cancel creating new citation
    Go To  ${HOME_URL}
    Click Button  Create new citation
    Input Text  citation_key  example
    Select From List By Label  name=type  Book
    Input Text  title  Example title
    Click Button  Cancel
    Page Should Not Contain  Example title

Cancel button should cancel editing citation
    Go To  ${HOME_URL}
    Click Button  Create new citation
    Create Citation Required Fields  example  Book  Original Title
    Click Button  Edit
    Input Text  name=title  Changed Title
    Click Button  Save changes
    Page Should Not Contain  Original title
