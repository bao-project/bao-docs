.. _contributing:

Contributing
============

The development of Bao projects' components uses the Github ecosystem for
contributions, code review, bug reporting, discussion of ideas or any other
community development, or project management activities. Therefore, every
:term:`contributor` should first create a Github account, if they do not have
one already.

If you plan to contribute a significant portion of code, such as an
architecture or platform port, a new subsystem or feature, please consider
creating a discussion thread, where the design and trade-offs can be first
debated among the community and **maintainers**.

We also recommend you to read our :ref:`licensing terms and the DCO
claim <licensing>` before making any contribution.

.. _contrib_roles:

Roles
-----

The project defines three essential types of roles in the development and
contribution process: **developer**, **code owner**, and **maintainer**.

A **developer** can be internal (if they are part of the project's core team)
or are an outside :term:`contributor`. Anyone that contributes in any way to
the project (e.g., code, reviews, issues, etc) is assigned to this role.

A **code owner** must either be part of the core team or someone invited and
marked as an outside collaborator by a **maintainer**. He is responsible for
overseeing the development of one or multiple subsystems, that must have a
proven record of deep understanding of that modules, specifically by having
heavily contributed to their design and/or implementation. Besides, he must
participate in code reviews that affect their assigned subsystems.

A **maintainer** must always be part of the core team. He is the person
ultimately responsible for everything in the repository, including code
structure, quality, functionality, overall repository architecture, and
interoperability. In all, making sure the repository adheres to the project
quality standards, high-level goals and vision. They are also responsible for
repository management tasks which include:

* setting up :ref:`branch protection rules<branch_protection>`, in particular
  for the ``main`` branch;
* assigning subsystems to code-owners through the :ref:`.CODEOWNERS
  file<github_files>`;
* keep an updated :ref:`list of authors and contributors<github_files>`;
* coordinating and moderating code reviews;
* final approval and merging of pull-requests (:term:`PR`);
* coordinating, moderating and closing of issues;
* setting up the repository's :ref:`CI pipeline via Github
  Actions<github_actions>`;
* manage :ref:`topic branches<topic_branches>` (e.g. delete stale ones);
* maintain the overall organization of the repository;
* inviting outside collaborators;

A repository must always have at least one **maintainer**, that is implicitly
the **code owner** of any subsystems that do not have any other. If a
**maintainer** steps down, it should first nominate a successor, preferably out
of the **code owners**.

.. _contribution_workflow:

Contribution Workflow
---------------------

The project's development flow for all repositories is centered around the
``main`` branch. Any code contribution, be it internal or external, takes the
form of a Github :term:`PR` to the ``main`` branch. The ``main`` branch is then
tagged periodically according to the defined :ref:`versioning
scheme<versioning>`.

.. _topic_branches:

Internal Topic Branches
***********************

For long-running developments, internal contributors may create topic branches
in the repository itself. Topic branch names should be prefixed with by
``<type>/`` (where type is one of the predetermined :ref:`branch types
<commit_branch_types>`), followed by a short descriptor written in lower snake
case. For example, when developing a new feature the branch should be named
``feat/my_new_feature``.

Once development on a topic branch ceases, either because it was merged to
``main`` or for some reason discarded, the branch must be deleted.
**Maintainers** are ultimately responsible for deleting stale of merged topic
branches.

Submitting Commits
******************

If you are an external :term:`contributor` or do not have write permissions to
the repository you wish to contribute to, first of all, you should `fork that
repository <https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_.
If you do have write privileges over the original repository, you carry out the
development directly on it. Follow these steps:

1. Create a topic branch from the ``main`` branch;

.. note::

    It is possible to create a topic branch based on another branch. This may
    be necessary if the changes are dependent on that specific branch.
    However, if this occurs during **step 4** of the process, it is mandatory
    to make the target branch the one that the new branch is based on.

2. Make all the necessary commits and push your work to your remote fork.
   Make sure that all the introduced commits and the overall branch follow
   the :ref:`commit and PR guidelines<commit_guidelines>`;
3. Make sure the branch is synced and can be merged or rebased on ``main``
   without conflicts. If necessary, `rewrite the branch's history
   <https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History>`_, by rebasing
   it on ``main``;
4. `Create a PR <https://docs.github.com/en/pull-requests/
   collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-
   requests/creating-a-pull-request>`_ targeting the original repository's
   ``main`` branch;
5. Patiently wait for reviews and be engaged when they arrive:

    * participate in the discussion with **reviewers**;
    * address any refactoring, fixes, or other modifications to your code
      contribution raised by the **reviewers'** comments. In doing so, add new
      commits to the existing pull request. If existing commits need to be
      modified, rewrite the history and force push them to maintain a clean
      linear history;
    * always reply to each inline comment/conversation topic opened by the
      reviewer and never mark it as resolved yourself. The **reviewer**
      must be the one to close that conversation in case they agree with the
      changes;
    * re-request a review from **reviewers'** after you have addressed all
      their concerns and modification requests;
    * if the **reviewers** are taking too long, try contacting the :term:`PR`
      assignee.

Review Assignment
*****************

A :term:`PR` must have at least one assignee and be approved by at least two
**reviewers**. The assignee must be a **maintainer** which will be responsible
for getting the :term:`PR` through, having the ultimate say on its acceptance
and that must carry out the final merge. **Maintainers** must coordinate to
choose among them the assignee as PRs arrive. One of the **reviewers** must
also be a **maintainer** (which can coincide with the assignee).

If a **code owner** exist for the code being submitted, at least one of them
(for each of the files/subsystems) must review the code. **Code owners** will
be automatically assigned as **reviewers** if the **maintainers** are correctly
managing the :ref:`.CODEOWNERS file<github_files>`. If there are not enough
**reviewers**, the assignee is responsible for appointing a second
**reviewer**. Preferably, a project's internal :term:`contributor`. They might
also require and invite more **reviewers** if there is no consensus.

Review Guide
************

As much as possible, code quality and enforced standards/guidelines will be
automatically checked in the :ref:`CI pipeline <ci>`. **Reviewers** must be
particularly attentive to the ones that are not addressed by these automated
tools.

The following are some tips all **reviewers** should take into account:

* Make sure the code is readable, well commented (includes doxygen comments),
  and the :term:`PR` provide the appropriate/necessary documentation;
* The code follows the project's :ref:`coding guidelines<coding_guidelines>` as
  much as possible, especially those not automatically checked such as:

    * code organization, that is, are the files placed correctly? (e.g.,
      architecture specific files in the *arch* directory);
    * naming conventions for files, functions, variables, types, etc.

* The :term:`PR` complies with all the relevant standards mandated for the
  specific language or repo in question (e.g. :ref:`MISRA<misra>`);
* There are no obscure binary blobs included in the :term:`PR`;
* Understand the design and implementation decisions behind the :term:`PR`; Try
  to imagine how you'd go about implementing the same functionality, and engage
  in discussion when it does not match the proposed approach. Discuss the
  trade-offs of the various approaches.
* Have a holistic view of the code in mind:

    * how do the modifications affect other subsystems and the
      maintainability and evolution of the code base?;
    * does the design follow the same philosophy of the over module, repo
      or project? Be it at the API, architecture, or implementation levels.

* Be on the look out for bugs in both the  implementation (e.g. precision loss
  or wrong operator precedence) and the semantic (does it correctly achieve the
  desired functionality). Try to reason about corner cases.
* New files contain the necessary :ref:`license and copyright
  information<licensing>`;
* All the necessary requirement and traceability artifacts or tags are
  correctly added or updated;

Review the code as much as possible by opening discussions and adding comments
inline in the ``Files Changed`` tab of the :term:`PR`, and opening a review.
When you are done click the ``Finish Review`` button and submit the review
either by only commenting or requesting explicit changes. As the
:term:`contributor` addresses your concerns mark each item as resolved. When
you are happy with the current state with the :term:`PR` and agree it should be
merged, add a final review with an explicit approval. Beware there might still
be new commits after you have approved the :term:`PR` and you might need or be
asked to review it again.

Finally, although obvious, self-reviewing is prohibited.

Final Approval and Merging
**************************

The final approval of the :term:`PR` to ``main`` must be carried out by a
**maintainer**. They should verify the following checklist, although some of it
might be automatically checked and enforced by GitHub:

* was reviewed by at least by two **reviewers**;
* all review comments, suggestions or modification requests have been
  addressed;
* passes all :ref:`CI pipeline <ci>` checks;
* can be rebased on ``main`` without any conflict;

The **maintainer** shall have as the main objective when integrating the
:term:`PR` to maintain a linear git history. Therefore, it should preferably
perform either a rebase of the :term:`PR` branch on ``main`` (or fast-forward
merge if possible) or perform a squash merge if they deem necessary.

If the :term:`PR` originates from an internal topic branch, the branch should
be deleted.

Finally, the **maintainer** should update any :term:`contributor`,
:ref:`author and/or code owner files<github_files>`, especially when new files
are created.

.. _commit_guidelines:

Commit, Branch, and PRs Guidelines
----------------------------------

PRs: Commit History
*******************

All contributions must be submitted via Github PRs. You should ensure that all
commits in the history within the :term:`PR`:

* have messages that follow the :ref:`conventional commit style<commits_style>`
* introduce small, self-contained logical units of modifications/extensions
  and don't include irrelevant changes (typo or formatting fixes should be
  submitted in dedicated PRs);
* are logically related (unrelated modifications or fixes must be addressed
  in a separate ``branch/pull-request``);
* follow a logical order. That is, a commit that has a dependence on the
  modifications by a different commit of the same :term:`PR`, is after the
  former.
* adhere to the project's :ref:`coding guidelines<coding_guidelines>` for the
  targeted languages;
* tag the necessary requirements;
* introduce code that is readable and sufficiently commented/documented;
* pass all :ref:`base CI pipeline<ci>` checks, by running them locally;
* make sure your code works: test your code in as many targets as possible
  and write the needed automated tests;
* introduces or updates the necessary documentation;
* the branch can be rebased on ``main`` without conflicts;
* the :ref:`appropriate license and copyright information<licensing>` is
  present and updated;
* make sure you have the rights to all the submitted code and that :ref:`all
  commits contain a sign-off message<commit_signoff>`, acknowledging the
  :ref:`DCO<dco>`;

Commits: Structure, Format, and Sign-off
****************************************

All commits follow a set of guidelines for the message structure and format.
Moreover, they should all be sign-off by the contributor.

.. _commits_style:

Message Structure
#################

The git commit messages must always contain a **header**, a **body**, and a
**footer**. We follow the `Convential Commits
<https://www.conventionalcommits.org/en/v1.0.0/?>`_ specification (with some
slight deviations) that provides an easy set of rules for creating an explicit
commit history. This leads to more readable messages that are self-explanatory
through the project history.

Each commit message has the following structure:

.. code-block:: none

    [header]
        <type>(<scope>): <description>

    [body]
        <free-form-description>

    [footer]
        <ref-issue>
        <ref-req>
        <ref-misra>
        <sign-off>

**Message header**

The commit message **header** has a special format that includes a **type**, a
optional **scope**, and a **description**. The prefix ``<type>`` consists of a
noun describing the type of commit. These nouns are pre-defined and described
in the below table (:ref:`msg_format`). The *optional* prefix ``<scope>`` may
be provided after the type to identify the subsystem, architecture of platform
affected by the changes. The ``<description>`` field follows immediately after
the colon and space after the type/scope prefix. It must provide a short
summary of the code changes.

**Message body**

The commit message **body** must be descriptive enough to address in the
``<free-form-description>`` at least the following points:

* describes the introduced features, fixes, extensions, and refactoring;
* provide a brief rationale for the chosen implementation or overall approach;
* how are you sure it works, i.e., describe the tests and corner cases you ran;

**Message footer**

The ``<footer>`` consists of a list of optional references when the commit:

* ``<ref-issue>``: addresses a GitHub issue (issue ID)
* ``<ref-misra>``: introduces a misra deviation (misra deviation or permit ID)
* ``<ref-req>``: implements a given requirement (requirement ID)
* ``<sign-off>``: a sign-off message that attests that he agrees with the
  :term:`contributor` adheres :ref:`dco` (see :ref:`commit_signoff`)

**Commit Example:**

.. code-block:: none

    feat(atf): add partitions initialization routine

    Start developing the partitions initialization routine. To achieve this we
    need to: 1. Wake-up each partitions primary cpu (the partition is
    responsible to start-up the other cpus) 2. Set-up cookie registers that
    should only be accessible by the partitioner (design decision) 3. Jump to
    the partition entrypoint A conditional pre-processor macro defines what
    should be included (atf_stubs.h) or excluded when building the partitioner
    for the ATF (ATF_BUILD).

    Issue: #123
    Signed-off-by: Your Name <your.name@example.com>

.. _msg_format:

Message Format
##############

The format of the message, especially the header, is checked using the `gitlint
<https://jorisroovers.com/gitlint/>`_ tool referenced in :ref:`CI
pipeline<ci>`. For detailed information on the commit format check the
``.gitlint`` file in the `CI repository
<https://github.com/bao-project/bao-ci>`_, which defines a certain set of rules
that comply with the following list:

* **Header** must follow Conventional Commits style
* **Header** length must be < 80 chars and > 10 chars.
* **Header** cannot have trailing whitespace (space or tab)
* **Header** cannot have trailing punctuation (?:!.,;)
* **Header** cannot contain hard tab characters (``\t``)
* **Header** cannot have leading whitespace (space or tab)
* **Body** message must be always specified
* **Body** lines must be < 80 chars
* **Body** cannot have trailing whitespace (space or tab)
* **Body** cannot contain hard tab characters (``\t``)
* **Body** first line (second line of commit message) must be empty
* **Body** length must be at least 20 characters
* **Body** message must be specified
* **Body** must contain references to certain files if those files are changed
  in the last commit

.. _commit_signoff:

Commit Sign-off
###############

All commits must contain a sign-off message that attests you adhere to the
:ref:`DCO<dco>` containing:

* ``Your Name`` should be replaced by your legal name
* ``your.email@example.com`` should be replaced by your email that you are
  using to author the commit

This message must follow the format:

.. code-block:: none

    Signed-off-by: Your Name <your.email@example.com>

You can easily add this to your commit by using ``-s`` flag when running the
``git commit`` command. Beware that if your changing an existing signed
commit, you should add your sign-off right after the previous author. Make sure
that your local git name and email configuration are correct and match the ones
used in you GitHub account.

.. code-block:: shell

    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"

PRs: Title and Body (Templates)
###############################

When submitting a PR, the title message should follow this structure:

.. code-block:: none

    <branch-type>/<branch-name>: <short-summary>

All PRs follow a designate template located in
``.github/pull_request_template.md`` file. Each time a contributor opens a PR,
the Github will automatically generated a body for the PR that follows that
template. The contributor must follow the template guidelines before submitting
the PR.

.. _commit_branch_types:

Commits and Branch Types
************************

The following are the allowed types for topic branches, commits, and PRs:

* ``fix``: bug fix
* ``ref``: refactoring of a code block that neither fixes a bug nor adds a
  feature
* ``feat``: a new feature
* ``build``: changes that affect the build system or external dependencies
* ``doc``: documentation only changes [#]_
* ``perf``: a code change that improves performance
* ``wip``: a code change that is still a work in progress
* ``exp``: a code change that is purely experimental for now
* ``test``: adding missing tests or correcting existing ones
* ``opt``: modifications pertaining only to optimizations
* ``ci``: changes to the :term:`CI` configuration files and scripts [#]_
* ``style``: changes that do not affect the meaning of the code (formatting,
  typos, naming, etc.)
* ``update``: changes that brings a feature, setup, or configuration up to date
  by adding new or updated information (e.g., updating a version, adding a new
  item to a list, updating CODEOWNERS, bumping the :term:`CI` repo)

.. [#] Cannot be used in the `bao-docs
    <https://github.com/bao-project/bao-docs>`_ repo.
.. [#] Cannot be used in the `bao-ci <https://github.com/bao-project/bao-ci>`_
    repo.


Github Repository Setup and Management
--------------------------------------

.. _github_files:

Repository Files
****************

Github uses special files which might be used to highlight some information,
or automate some specific functionality. The project's repositories must have
the following files set up, relative to their top-level directory:

* ``README``: the readme file must have a summary about the repository's
  content, functionality, etc., as well as a quick guide on how to use it
  (build, install, etc.);
* ``LICENSE``: a document of the license chosen for the repository and other
  copyright or legal restrictions;
* ``CONTRIBUTORS`` and ``AUTHORS``: list all
  :ref:`contributors and authors<authors_and_contributors>` that submit code
  to that repository.
* ``.github/CODEOWNERS``: identifies the coder owners of the repository so
  they can be automatically notified for code-review. The file first line
  must assign all files to the repository's **maintainers**;
* ``.github/pull_request_template.md``: template to be automatically used and
  generated by Github when a PR is open.
* ``.github/ISSUE_TEMPLATE/bug_report.md``: template to be automatically used
  and generated by Github when a *bug*-labeled issue is open.
* ``.github/ISSUE_TEMPLATE/feature_request.md``: template to be automatically
  used and generated by Github when a *feature-request*-labeled issue is open.

.. _authors_and_contributors:

Author and Contributors
***********************

Besides the ``git log``, Bao Project's repositories should explicitly list
their contributors in to files at the repo's top-level:

* The ``CONTRIBUTORS`` file must list every person who contributes to the
  project, even in a minor way with bug fixes, optimizations, etc.

* The ``AUTHORS`` files list the developers who have made some significant
  contribution to the system, such as implementing a new feature, subsystem,
  port to a new architecture/platform, and the like.

These files must list :term:`contributor`/author per line, preferably in the
format

.. code-block:: none

    Contributor's Name <contributors@email.com>

using the name and e-mail associated with their Github accounts and commits.
However, if some :term:`contributor` requests to be listed in another format,
(e.g. using some alias), we can also accommodate it.

If a :term:`contributor` does not wish to be listed or have any of their
information removed, maintainers must fulfill their request.

Preferably, these files should list the contributors/authors in a chronologic
order regarding their first contribution. That means each time a new person
is added it is appended at the end of the file.

.. _branch_protection:

Branch Protection
*****************

All repositories' ``main`` branch must be configured with a set of protection
rules that aim at ensuring some of the rules defined in :ref:`contribution
workflow<contribution_workflow>`. In the repository's ``Settings -> Branches``
menu, the protection rules must be created with the following options:

* Require a pull request before merging:

    * Required approvals: 2
    * Dismiss stale pull request approvals when new commits are pushed
    * Required review from **code owners**

* Require the status checks to pass before merging

    * Require branches to be up to date before merging

* Require conversation resolution before merging
* Require linear history
* Do not allow bypassing the above settings

Other topic branches might also be subject to protection rules at the will of
the repository's **maintainers**.

.. _github_actions:

CI/GitHub Actions
*****************

Every repository must have an automated :ref:`CI pipeline <ci>` setup using
GitHub Actions. Specifically, by adding workflow yaml files to the
``.github/workflows`` directory. The `CI repository
<https://github.com/bao-project/bao-ci>`_ contains a number of templates as
well as further instructions on how to set it up.

Here are a few workflows a **maintainer** should add to the repository's
:term:`CI`:

* commit message linting: apply gitlint to verify all the PRs' commit messages
  follow the conventional commit style;
* copyright and license check: making sure all files have the necessary license
  and copyright information;
* language format/linting: apply the language format checkers defined in the
  :ref:`CI repository <gitact_checkers>` for the repo's used languages (e.g.
  clang-format for C or pylint for python);
* static analysis: apply static analyses defined in :ref:`CI repository
  <gitact_checkers>` for the repo's used language (e.g. misra-check for C
  language);
* build: build the repository for a representative set of targets and
  configurations (using GitHub Actions' strategy matrix);

The **maintainers** are free to add more Github workflows they feel are needed
due to the specificities of the repository.

Repository Templates
********************

The `bao-ci <https://github.com/bao-project/bao-ci>`_ repo provides a
``.github/templates`` folder containing general templates for PRs and Issues.
Please be advised that these only provide a set of general topics that a
maintainer can use as a basis. The maintainer is responsible for adapting these
templates by modifying them or adding fields that they feels are missing, given
the repository specificities.

PR Templates
############

A repository must provide a template that Github will use to auto-populate PR
description fields, structuring the report and guiding contributors on what
information they should provide. The :term:`maintainer` of the repository is
responsible for setting up and organizing these templates, adapting them to the
repository's specificities and constraints(e.g., type of changes, tests
performed).

The PR template is described in ``.github/pull_request_template.md``.

Issues Templates
################

A repository must provide templates that Github will use to auto-populate issue
description fields, structuring the report and guiding contributors on what
information they should provide. The :term:`maintainer` of the repository is
responsible for setting up and organizing these templates, adapting them to the
repository's specificities and constraints.

At least two issue templates must be created:

* ``.github/ISSUE_TEMPLATE/bug_report.md``: consistently details and organizes
  a bug report
* ``.github/ISSUE_TEMPLATE/feature_request.md``: details an idea/suggestion for
  a new feature and analyzes its trade-offs

Git Submodules Setup
********************

The Git submodules feature is used across several repositories. For example,
the CI workflow is typically added as a submodule on other repository
subsystems to enable the CI pipeline. When creating a submodule, a developer
must ensure that the ``.gitmodules`` configuration file (that stores the
mapping between the project’s URL and the local subdirectory) uses the SSH URL.

To add a submodule using an SSH URL, you can use the ``git submodule add``
command followed by the SSH URL of the repository you want to add as a
submodule.

For example:

.. code-block:: shell

    git submodule add ssh://git@example.com/path/to/repo.git

This will add the repository at the specified SSH URL as a submodule to your
current Git repository. Keep in mind that you need to have access to the
repository that you want to add as a submodule and be authenticated with the
appropriate credentials in order to use an SSH URL.

Final layout of the ``.gitmodules`` configuration file:

.. code-block:: none

    [submodule "ci"]
    path = ci
    url = git@github.com:bao-project/bao-ci.git

.. TODO:

.. Non-??? contributions
.. ----------------------

.. Reporting Bugs
.. **************

.. - issue labels?

.. Issue template


.. Proposing Ideas
.. ***************

.. discussions

.. how to introduce ideas

.. how to divide a planned (complex) feature into tasks and track them

.. Versioning
.. ----------

.. add ref to "requirements and traceability" mentions throughout the document
