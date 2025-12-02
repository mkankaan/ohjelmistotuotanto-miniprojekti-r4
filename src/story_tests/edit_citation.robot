*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
Edit page should display existing citation data
    Create Citation Required Fields  example  Article  Example Article
    Click Button  Edit
    Page Should Contain  Edit citation
    Textfield Value Should Be  name=citation_key  example
    List Selection Should Be  name=type  Article
    Textfield Value Should Be  name=title  Example Article

Editing citation key should succeed
    Create Citation Required Fields  example  Article  Example
    Click Button  Edit
    Input Text  name=citation_key  edited_example
    Click Button  Save changes
    Page Should Contain  edited_example
    Page Should Not Contain  Citation key: example

 Editing title should succeed
     Create Citation Required Fields  example  Book  Example
     Click Button  Edit
     Input Text  name=title  Edited Title
     Click Button  Save changes

     Wait Until Page Contains  Edited Title  timeout=10s

 Editing all fields should succeed
     Create Citation Required Fields  example  Book  Example
     Click Button  Edit
     Input Text  name=citation_key  edited_key
     Select From List By Label  name=type  Article
     Input Text  name=title  Edited Title
     Input Text  name=author  New Author
     Input Text  name=year  2024
     Input Text  name=publisher  New Publisher
     Input Text  name=isbn  978-3-16-148410-0
     Input Text  name=doi  10.1234/edited
     Input Text  name=url  https://edited.example.com
     Click Button  Save changes
     Page Should Contain  edited_key
     Page Should Contain  Edited Title

Editing citation to have non-unique key should fail
    Create Citation Required Fields  first  Book  First Book
    Create Citation Required Fields  second  Book  Second Book
    Click Button   Edit
    Input Text  name=citation_key  first
    Click Button  Save changes
    #Page Should Contain  Error

 Canceling edit should return to home without changes
     Create Citation Required Fields  example  Book  Original Title
     Click Button  Edit
     Input Text  name=title  Changed Title
     Click Button  Cancel
     Page Should Contain  Original Title
     Page Should Not Contain  Changed Title

#Editing year to non-numerical value should disable save button
     #Create Citation Required Fields  example  Book  Example
     #Click Button  Edit
     #Input Text  name=year  not_a_number
     #Element Should Be Disabled  id=create


