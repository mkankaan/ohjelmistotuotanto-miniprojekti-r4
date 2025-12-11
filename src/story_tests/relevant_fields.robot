*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset Citations
Test Teardown    Reset Citations

*** Test Cases ***
Only relevant fields are shown for article type when creating citation
	Fill Citation Required Fields  exampleArticle  Article  Example Article  
	Input Text  name=author  Author A and Author B
	Input Text  name=year  2024  
	Input Text  name=journal  Journal of Examples
    Input Text  name=pages  2-10
    Input Text  name=volume  10
    Input Text  name=number  2
	Input Text  name=doi  10.1234/example.doi  
	Input Text  name=url  https://www.examplearticle.com
    Input Text  name=urldate  15.06.2024
	Click Button  Create
	Title Should Be  Citation helper


Only relevant fields are shown for book type when creating citation
	Fill Citation Required Fields  exampleBook  Book  Example Book  
	Input Text  name=author  Author C and Author D
	Input Text  name=year  2023
	Input Text  name=publisher  Example Publisher
	Input Text  name=isbn  123-456-78987-6-5
    Input Text  name=doi  10.1234/book.doi
    Input Text  name=url  https://www.examplebook.com
    Input Text  name=urldate  10.05.2023
	Click Button  Create
	Title Should Be  Citation helper


Only relevant fields are shown for conference type when creating citation
	Fill Citation Required Fields  exampleConference  Conference  Example Conference Paper  
	Input Text  name=author  Author E
	Input Text  name=year  2022
    Input Text  name=publisher  Conf Publisher
    Input Text  name=booktitle  Proceedings of ExampleConf
    Input Text  name=pages  100-110
    Input Text  name=doi  10.1234/conf.doi
	Input Text  name=url  https://www.exampleconference.com
    Input Text  name=urldate  20.11.2022
	Click Button  Create
	Title Should Be  Citation helper



Only relevant fields are shown for Book Chapter type when creating citation
	Fill Citation Required Fields  exampleBookChapter  Book Chapter  Example Book Chapter  
	Input Text  name=author  Author F and Author G
	Input Text  name=year  2021
	Input Text  name=publisher  Example Publisher
    Input Text  name=booktitle  Example Book
    Input Text  name=pages  30-45
    Input Text  name=chapter  3
    Input Text  name=doi  10.1234/chapter.doi
	Click Button  Create
	Title Should Be  Citation helper


Only relevant fields are shown for Other type when creating citation
	Fill Citation Required Fields  exampleOther  Other  Example Other Work  
	Input Text  name=author  Author H
	Input Text  name=year  2020
    Input Text  name=publisher  Misc Publisher
    Input Text  name=doi  10.1234/misc.doi
	Input Text  name=url  https://www.exampleother.com
    Input Text  name=urldate  05.09.2020
	Click Button  Create
	Title Should Be  Citation helper

Only relevant fields are shown for article type when editing citation
    Fill Citation Required Fields  exampleArticle  Article  Example Article
    Input Text  name=author  Author A and Author B
    Input Text  name=year  2024
    Input Text  name=journal  Journal of Examples
    Input Text  name=volume  10
    Input Text  name=number  2
    Input Text  name=pages  1-10
    Input Text  name=doi  10.1234/example.doi
    Input Text  name=url  https://www.examplearticle.com
    Click Button  Create
    Click Button  Edit
    Title Should Be  Edit citation

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="year"]       style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="journal"]    style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="volume"]     style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="number"]     style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="pages"]      style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="doi"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="url"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="urldate"]    style
    Should Not Contain  ${style}  display: none

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="publisher"]  style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="isbn"]       style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="booktitle"]  style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="chapter"]    style
    Should Contain  ${style}  display: none


Only relevant fields are shown for book type when editing citation
    Fill Citation Required Fields  exampleBook  Book  Example Book
    Input Text  name=author  Author C and Author D
    Input Text  name=year  2023
    Input Text  name=publisher  Example Publisher
    Input Text  name=isbn  123-456-78987-6-5
    Input Text  name=doi  10.1234/book.doi
    Input Text  name=url  https://www.examplebook.com
    Click Button  Create
    Click Button  Edit
    Title Should Be  Edit citation

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="year"]       style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="publisher"]  style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="isbn"]       style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="doi"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="url"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="urldate"]    style
    Should Not Contain  ${style}  display: none

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="journal"]    style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="booktitle"]  style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="pages"]      style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="volume"]     style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="number"]     style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="chapter"]    style
    Should Contain  ${style}  display: none


Only relevant fields are shown for conference type when editing citation
    Fill Citation Required Fields  exampleConference  Conference  Example Conference Paper
    Input Text  name=author  Author E
    Input Text  name=year  2022
    Input Text  name=booktitle  Proceedings of ExampleConf
    Input Text  name=pages  100-110
    Input Text  name=publisher  Conf Publisher
    Input Text  name=doi  10.1234/conf.doi
    Input Text  name=url  https://www.exampleconference.com
    Click Button  Create
    Click Button  Edit
    Title Should Be  Edit citation

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="year"]       style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="booktitle"]  style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="pages"]      style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="publisher"]  style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="doi"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="url"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="urldate"]    style
    Should Not Contain  ${style}  display: none

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="journal"]    style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="isbn"]       style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="volume"]     style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="number"]     style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="chapter"]    style
    Should Contain  ${style}  display: none


Only relevant fields are shown for Book Chapter type when editing citation
    Fill Citation Required Fields  exampleBookChapter  Book Chapter  Example Book Chapter
    Input Text  name=author  Author F and Author G
    Input Text  name=year  2021
    Input Text  name=booktitle  Example Book
    Input Text  name=chapter  3
    Input Text  name=pages  30-45
    Input Text  name=publisher  Example Publisher
    Input Text  name=doi  10.1234/chapter.doi
    Input Text  name=url  https://www.examplechapter.com
    Click Button  Create
    Click Button  Edit
    Title Should Be  Edit citation

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="year"]       style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="booktitle"]  style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="chapter"]    style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="pages"]      style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="publisher"]  style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="doi"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="url"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="urldate"]    style
    Should Not Contain  ${style}  display: none

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="journal"]    style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="isbn"]       style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="volume"]     style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="number"]     style
    Should Contain  ${style}  display: none


Only relevant fields are shown for Other type when editing citation
    Fill Citation Required Fields  exampleOther  Other  Example Other Work
    Input Text  name=author  Author H
    Input Text  name=year  2020
    Input Text  name=publisher  Misc Publisher
    Input Text  name=doi  10.1234/misc.doi
    Input Text  name=url  https://www.exampleother.com
    Click Button  Create
    Click Button  Edit
    Title Should Be  Edit citation

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="year"]       style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="publisher"]  style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="doi"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="url"]        style
    Should Not Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="urldate"]    style
    Should Not Contain  ${style}  display: none

    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="journal"]    style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="booktitle"]  style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="pages"]      style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="volume"]     style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="number"]     style
    Should Contain  ${style}  display: none
    ${style}=    Get Element Attribute  xpath=//div[@class="form-item bibtex-field" and @data-name="chapter"]    style
    Should Contain  ${style}  display: none
