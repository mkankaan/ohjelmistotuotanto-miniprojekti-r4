*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${SERVER}             localhost:5001
${DELAY}              0.1 seconds
${HOME_URL}           http://${SERVER}
${RESET_URL}          http://${SERVER}/reset_db
${NEW_CITATION_URL}   http://${SERVER}/new_citation
${BIBTEX_URL}         http://${SERVER}/bibtex
${BROWSER}            chrome
${HEADLESS}           false

*** Keywords ***
Open And Configure Browser
    IF  $BROWSER == 'chrome'
        ${options}  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
        Call Method  ${options}  add_argument  --incognito
    ELSE IF  $BROWSER == 'firefox'
        ${options}  Evaluate  sys.modules['selenium.webdriver'].FirefoxOptions()  sys
        Call Method  ${options}  add_argument  --private-window
    END
    IF  $HEADLESS == 'true'
        Set Selenium Speed  0.01 seconds
        Call Method  ${options}  add_argument  --headless
    ELSE
        Set Selenium Speed  ${DELAY}
    END
    Open Browser  browser=${BROWSER}  options=${options}

Reset Citations
    Go To  ${RESET_URL}

Reset Citations And Go To Start Page
    Go To  ${RESET_URL}
    Go To  ${HOME_URL}

Reset Citations And Go To Bibtex Page
    Go To  ${RESET_URL}
    Go To  ${BIBTEX_URL}

Create Citation
    [Arguments]  ${citation_key}  ${type}  ${title}  ${authors}  ${year}  ${publisher}  ${isbn}  ${doi}  ${url}  ${urldate}
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Input Text  name=citation_key  ${citation_key}
    Select From List By Label  name=type  ${type}
    Input Text  name=title  ${title}
    Input Text  name=author  ${authors}
    Input Text  name=year  ${year}
    Input Text  name=publisher  ${publisher}
    Input Text  name=isbn  ${isbn}
    Input Text  name=doi  ${doi}
    Input Text  name=url  ${url}
    Input Text  name=urldate  ${urldate}
    Click Button  Create

Create Citation Required Fields
    [Arguments]  ${citation_key}  ${type}  ${title}
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Input Text  name=citation_key  ${citation_key}
    Select From List By Label  name=type  ${type}
    Input Text  name=title  ${title}
    Click Button  Create

Fill Citation Required Fields
    [Arguments]  ${citation_key}  ${type}  ${title}
    Go To  ${NEW_CITATION_URL}
    Wait Until Element Is Visible    name=citation_key    timeout=10
    Input Text  name=citation_key  ${citation_key}
    Select From List By Label  name=type  ${type}
    Input Text  name=title  ${title}

