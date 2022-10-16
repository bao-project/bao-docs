## PR Description

Before saving the PR, please delete this description and add only your summary/description of the PR.
Please include a summary of the change that tries to answer the following general questions:
- What does this change introduce? Why is it required?
- Which main blocks are affected?

If your changes are included in the following categories, please try also to answer to these specific questions to enhance your summary:
- The PR changes introduces a new feature...
  - What new feature is being introduced?
  - Is the feature described in any of the requirements?
- The PR changes solves a bug...
  - What bug does it solve? What was the previous behavior/warning/error?
  - Is the bug described in any issue ticket number?
- The PR changes refactors a code/doc block...
  - Why the code/doc block needed to be refactored?
  - Is the improvement described in any issue ticket number?
- The PR changes the build system...
  - What building block of the build system was changed?
  - Has any external dependency been introduced?
- The PR changes adds new tests...
  - What new tests were introduced or corrected?

### Type of change

Before saving the PR, please delete this description and the below options that are not relevant.
If you are not sure which type of change are you introducing, please read [Contributing](https://github.com/bao-project/bao-docs/blob/main/source/development/contributing.rst) documentation.

- **feat**: introduces a new functionality
  - Logical unit: <name>
- **fix**: bug fix
  - Logical unit: <name>
  - Fixes a specific issue: <#ticket-number>
- **ref**: refactoring of a code/doc block
  - Logical unit: <name>
- **build**: changes that affect the build system or external dependencies
  - Logical unit: <name>
- **test**: adding missing tests or correcting existing ones
  - Test unit/suite: <name>
- **ci**: changes to the CI configuration files and scripts
  - CI checker unit: <name>
- **style**: changes that do not affect the meaning of the code (formatting, typos, naming, etc.)
- **update**: changes that brings a feature, setup, or configuration up to date by adding new or updated information
  - Logical unit: <name>

## Checklist:

- [ ] The changes follows the documentation guidelines described in [here](https://github.com/bao-project/bao-docs/blob/main/source/development/doc_guidelines.rst).
- [ ] The changes generate no new warnings when building the project. If so, I have justified above.
- [ ] I have run the CI checkers before submitting the PR to avoid unnecessary runs of the workflow.
