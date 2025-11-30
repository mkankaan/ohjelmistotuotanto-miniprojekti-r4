*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
Date Containing Numbers In Day Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  a.2.2025
    Element Should Be Disabled  create

Date Containing Numbers In Month Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  1.a.2025
    Element Should Be Disabled  create

Date Containing Numbers In Year Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  1.1.2025a
    Element Should Be Disabled  create

Date With Too Many Parts Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  1.2.3.4
    Element Should Be Disabled  create

Date With Too Few Parts Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  1.1.
    Element Should Be Disabled  create

Date In The Future Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  1.1.2100
    Element Should Be Disabled  create

Incorrect Leap Year Date Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  29.2.2021
    Element Should Be Disabled  create

Correct Leap Year Date Should Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  29.2.2020
    Element Should Be Enabled  create

Valid Date In Format DD.MM.YYYY Should Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  30.11.2025
    Element Should Be Enabled  create

Valid Date In Format D.M.YYYY Should Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  3.4.2025
    Element Should Be Enabled  create

Zero In Day Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  0.2.2020
    Element Should Be Disabled  create

Zero In Month Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  1.0.2020
    Element Should Be Disabled  create

Zero In Year Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  0.2.0
    Element Should Be Disabled  create

Day Beyond 31 Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  32.1.2025
    Element Should Be Disabled  create

Month Beyond 12 Should Not Succeed
    Fill Citation Required Fields  a  Book  a
    Input Text  name=urldate  1.13.2025
    Element Should Be Disabled  create


