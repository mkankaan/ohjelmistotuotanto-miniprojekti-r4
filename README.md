# Citation helper

[![CI](https://github.com/mkankaan/ohjelmistotuotanto-miniprojekti-r4/actions/workflows/ci.yaml/badge.svg)](https://github.com/mkankaan/ohjelmistotuotanto-miniprojekti-r4/actions/workflows/ci.yaml)
[![codecov](https://codecov.io/gh/mkankaan/ohjelmistotuotanto-miniprojekti-r4/graph/badge.svg?token=EV73KLLNA0)](https://codecov.io/gh/mkankaan/ohjelmistotuotanto-miniprojekti-r4)

A Flask web application for managing citations in LaTeX and converting citations to BibTeX. 

- [Backlog](https://helsinkifi-my.sharepoint.com/:x:/g/personal/kmatleen_ad_helsinki_fi/IQB_5FRo87a0QpDoPP9JqRrwAQ5L4NhVh8tueMy3X8KeSVg?e=9jUfL5)<br/>
- [Installation](#installation) <br/>
    - [Database Setup](#setup) <br/>
    - [Run the Application](#run) <br/>
    - [Testing](#testing) <br/>
- [Changelog v1.1.0 (2025-11-26)](#changelog) <br/>
- [Definition of Done](#dod) <br/>
- [Acceptance Criteria](#acc) <br/>
    - [Sprint 2](#sprint2) <br/>

## <a name="installation"></a> Installation
### <a name="setup"></a> Database Setup
Clone the project and create a file called `.env` to the root of the project. The file should have the following contents:
```
DATABASE_URL=postgresql://xxx
TEST_ENV=true
SECRET_KEY=random_string
```
The URL must start with `postgresql`, not `postgres`.

### <a name="run"></a> Run the Application
1. Make sure Poetry is installed. Run `$ poetry install` in the root folder.
2. Enter the Poetry virtual environment by running `$ eval $(poetry env activate)`.
3. **Before running for the first time**, run `$ python src/db_helper.py` to create the needed database tables.
4. Start the application by running `$ python src/index.py`.

### <a name="testing"></a> Testing
Unit tests can be run with `$ pytest src/tests`.

Robot tests can be run with `$ robot src/story_tests`.

## <a name="changelog"></a> Changelog v1.2.0 (2025-11-26)

**Added features**
- The user can generate a BibTeX snippet of all citations stored in the database.
- The user can automatically fill the citation creation form using a Crossref DOI.

**Fixed issues**
- Fixed the issue where the button on the citation creation form was clickable if the fields were not filled correctly.
- Fixed the issue where the field names were not shown on the front page.

## <a name="dod"></a> Definition of Done

- Each user story has clearly defined acceptance criteria, which can be found in the README file and also the backlog that is linked in the README file.
- Test coverage is kept at a sufficient level, and all implementation-related tests are run in the CI service, with results visible to everyone.
- The code follows a consistent style, which is verified with the Pylint tool before acceptance.
- The application's architecture is clear, and naming conventions are consistent and descriptive of their purpose.
- Documentation is kept up to date. The README includes instructions for running and testing the application locally.
- Change history is maintained in a clear and documented way: commit messages describe the changes made.
- Code is refactored for better quality.

## <a name="acc"></a> Acceptance criteria

(#) = priority

### Sprint 1

Forgot!

### <a name="sprint2"></a> Sprint 2

#### The fields of the form do not accept wrong data types and the form does not allow sending them (#1) [complete]
- The user can only input numbers into the 'year' field
- The user can only input a valid URL, ISBN and DOI into the respective fields
- The submit button is not pressable if certain fields contain invalid values

#### The user can see the names of different fields related to a citation (#1) [complete]
- Correct names are displayed next to corresponding fields

#### The user can fetch citation information using a DOI (#2)
- The Populate button is disabled when field does not contain a valid DOI, or a string (such as an URL) ending in a valid DOI
- Populating fills up all fields where information is found
- Populating also checks validity of Submit button
- Automatic fetching supports Crossref citations, more may be added later

If there is time:

#### The user can generate a BibTeX snippet containing the citations (#3) [complete]
- The user can click a Generate BibTeX button to generate a copy-pasteable BibTeX snippet of all citations in the database
- The button is unclickable if there are no citations
- The generated BibTeX works correctly when pasted into a LaTeX document and the sources can be referred to with the citation key

#### The user can edit citations (#4) [incomplete]
- The user can click on an Edit button next to a citation to open the edit form
- The content of the citation is pre-filled in the edit form fields
- The user can edit the fields and press Save to save changes
- The edit form fields don't accept wrong data types and the form does not allow sending them
- The edited citation is shown correctly

#### The user can delete a citation (#4) [incomplete]
- The user can click on a Delete button next to a citation
- A pop-up asks the user to confirm if they want to delete the citation
- If the user clicks yes, the start page will reload and the deleted citation is gone
- If the user clicks no, the citation is still on the page
