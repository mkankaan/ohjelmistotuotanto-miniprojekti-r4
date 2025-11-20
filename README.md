# Citation helper

[![CI](https://github.com/mkankaan/ohjelmistotuotanto-miniprojekti-r4/actions/workflows/ci.yaml/badge.svg)](https://github.com/mkankaan/ohjelmistotuotanto-miniprojekti-r4/actions/workflows/ci.yaml)
[![codecov](https://codecov.io/gh/mkankaan/ohjelmistotuotanto-miniprojekti-r4/graph/badge.svg?token=EV73KLLNA0)](https://codecov.io/gh/mkankaan/ohjelmistotuotanto-miniprojekti-r4)

A Python web application for managing citations in LaTeX and converting citations to BibTeX. 

[BACKLOG](https://helsinkifi-my.sharepoint.com/:x:/g/personal/kmatleen_ad_helsinki_fi/IQB_5FRo87a0QpDoPP9JqRrwAWshwMsht0EJbNXPVjgYSlE?e=QAMZ1i)

## Installation
### Database Setup
Clone the project and create a file called `.env` to the root of the project. The file should have the following contents:
```
DATABASE_URL=postgresql://xxx
TEST_ENV=true
SECRET_KEY=random_string
```
The URL must start with `postgresql`, not `postgres`.

### Run The Application
1. Make sure Poetry is installed. Run `$ poetry install` in the root folder.
2. Enter the Poetry virtual environment by running `$ eval $(poetry env activate)`.
3. **Before running for the first time**, run `$ python src/db_helper.py` to create the needed database tables.
4. Start the application by running `$ python src/index.py`.

### Testing
Unitests can be run with `$ pytest src/tests`.

Robot tests can be run with `$ robot src/story_tests`.

## Changelog v1.0.0 (2025-11-20)

**Added features**

- Add a book citation
- View all added citations

## Definition of Done

- Each user story has clearly defined acceptance criteria, which can be found in the backlog that is linked in the README file.
- Test coverage is kept at a sufficient level, and all implementation-related tests are run in the CI service, with results visible to everyone.
- The code follows a consistent style, which is verified with the Pylint tool before acceptance.
- The application's architecture is clear, and naming conventions are consistent and descriptive of their purpose.
- Documentation is kept up to date. The README includes instructions for running and testing the application locally.
- Change history is maintained in a clear and documented way: commit messages describe the changes made.
