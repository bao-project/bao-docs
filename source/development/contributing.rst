.. _contributing:

Contributing
============

The development of Bao projects' components uses the Github ecosystem for
contributions, code review, bug reporting, discussion of ideas or any other
community development or project management activities. Therefore, every
contributor should first create a Github account, if they do not have one
already.

If you plan to contribute a significant portion of code, such as a architecture
or platform port, a new subsystem or feature, please consider creating a
discussion thread, where the design and trade-offs can be first debate among
the community and maintainers.

We also recommend you to read our :ref:`licensing terms and the DCO
claim <licensing>` before making any contribution.

Roles
-----

The project defines three essential kind of roles in the development and
contribution process: developer, code owner and maintainer. A *developer* can
be internal (if they are part of the project's core team) or are an outside
contributor. A *code owner* must either be part of the core team or someone
invited and marked as an outside collaborator by a maintainer. A *maintainer*
must always be part of the core team.

A **developer** is anyone that contributes in any way to the project (be it
code, reviews, issues, etc). A **code owner** is someone responsible for
overseeing the development of one or multiple subsystems, that must have a
proven record of deep understanding of that modules, specifically by having
heavily contributed to their design and/or implementation. A code owner must
participate in code reviews that affect their assigned subsystems. A
**maintainer** is the person ultimately responsible for everything in the
repository, including code structure, quality, functionality, overall
repository architecture and interoperability. In all, making sure the
repository adheres to the project quality standards, high-level goals and
vision. Also they are responsible for repository management tasks which
include:

* setting up :ref:`branch protection rules<branch_protection>`, in particular
  for the ``main`` branch;
* assigning subsystems to code-owners through the :ref:`.CODEOWNERS
  file<github_files>`;
* keep an updated :ref:`list of authors and contributors<github_files>`;
* coordinating and moderating code reviews;
* final approval and merging of pull-requests;
* coordinating, moderating and closing of issues;
* setting up the repository's :ref:`CI pipeline via Github
  Actions<github_actions>`;
* manage :ref:`topic branches<topic_branches>` (e.g. delete stale ones);
* maintain the overall organization of the repository;
* inviting outside collaborators;

A repository must always have at least one maintainer, that is implicitly the
code owner of any subsystems that do not have any other. If a maintainer steps
down, it should first nominate a successor, preferably out of the code owners.

.. _contribution_workflow:

Contribution Workflow
---------------------

The project's development flow for all repositories is centered around the
`main` branch. Any code contribution, be it internal or external, takes the
form of a Github pull-request (PR) to the main branch. The main branch is then
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
`feat/my_new_feature`.

Once development on a topic branch ceases, either because it was merged to
``main`` or for some reason discarded, the branch must be deleted. Maintainers
are ultimately responsible for deleting stale of merged topic branches.

Submitting Commits
******************

If you are an external contributor, or do not have write permissions to the
repository you wish to contribute to, first of all, you should `fork that
repository <https://docs.github.com/en/get-started/quickstart/fork-a-repo>`_.
If you do have write privileges over the original repository, you carry out the
development directly on it. Follow these steps:

1. Create a topic branch from the ``main`` branch;
2. Make all the necessary commits and push your work to your remote fork.
   Make sure that all the introduced commits and the overall branch follow
   the :ref:`commit and pull-request guidelines<commit_guidelines>`;
3. Make sure the branch is synced and can be merged or rebased on ``main``
   without conflicts. If necessary, `rewrite the branch's history
   <https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History>`_, by rebasing
   it on ``main``;
4. `Create a pull-request <https://docs.github.com/en/pull-requests/
   collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-
   requests/creating-a-pull-request>`_ targeting the original repository's
   ``main`` branch;
5. Patiently wait for reviews and be engaged when they arrive:

    * participate in the discussion with reviewers;
    * address any refactoring, fixes, or other modifications to your code
      contribution raised by the reviewers' comments. In doing so, add new
      commits to the existing pull request. If existing commits need to be
      modified, rewrite the history and force push them to maintain a clean
      linear history;
    * if the reviewers are are taking too long, try contacting the PR
      assignee.

Review Assignment
*****************

A pull-request must have at least one assignee and be approved by at least two
reviewers. The assignee must be a maintainer which will be responsible for
getting the PR through, having the ultimate say on its acceptance and that must
carry out the final merge. Maintainers must coordinate to choose among them the
assignee as pull-requests arrive. One of the reviewers must also be a
maintainer (which can coincide with the assignee).

If a code owners exist for the code being submitted, at least one of code
owners (for each of the files/subsystems) must review the code. Code owners
will be automatically assigned as reviewers given maintainers are correctly
managing the :ref:`.CODEOWNERS file<github_files>`. If there aren't enough reviewers, the
assignee  is responsible for appointing a second reviewer. Preferably, a
project's internal contributor. They might also require and invite more
reviewers if there is no consensus.

Reviewing Guide
***************

As much as possible, code quality and enforced standards/guidelines will be
automatically checked in the :ref:`CI pipeline <ci>`. Reviewers must be
particularly attentive to the ones that are not addressed by these automated
tools.

The following are some tips all reviewers should take into account:

* Make sure the code is readable, well commented (includes doxygen comments),
  and the PR provide the appropriate/necessary documentation;
* The code follows the project's :ref:`coding guidelines<coding_guidelines>` as
  much as possible, especially those not automatically checked such as:

    * code organization, that is, are the files placed correctly? (e.g.,
      architecture specific files in the *arch* directory);
    * naming conventions for files, functions, variables, types, etc.

* The PR complies with all the relevant standards mandated for the specific
  language or repo in question (e.g. :ref:`MISRA<misra>`);
* There are no obscure binary blobs included in the PR;
* Understand the design an implementation decisions behind the PR; Try to
  imagine how you'd go about implementing the same functionality, and
  engage in discussion when it does not match the proposed approach.
  Discuss the trade-offs of the various approaches.
* Have a holistic view of the code in mind:

    * how do the modifications affect other subsystems and the
      maintainability and evolution of the code base?;
    * does the design follow the same philosophy of the over module, repo
      or project? Be it at the API, architecture or implementation levels.

* Be on the look out for bugs on both a implementation (e.g. precision loss
  or wrong operator precedence) and semantic (does it correctly achieve the
  desired functionality). Try to reason about corner cases.
* New files contain the necessary :ref:`license and copyright
  information<licensing>`;
* All :ref:`commits are signed correctly<commit_signing>`;
* All the necessary :ref:`requirement and traceability artifacts<>` or
  tags are correctly added or updated;

Review the code as much as possible by opening discussions and adding comments
inline in the ``Files Changed`` tab of the PR, and opening a review. When you're
done click the ``Finish Review`` button and submit the review either by only
commenting or requesting explicit changes. As the contributor addresses your
concerns mark each item as resolved. When you are happy with the current state
with the pull-request and agree it should be merged, add a final review with an
explicit approval. Beware there might still be new commits after you've
approved the PR and you might need or be asked to review it again.

Finally, although obvious, self-reviewing is prohibited.

Final Approval and Merging
**************************

The final approval of the pull-request to ``main`` must be carried out by a
maintainer. They should verify the following checklist, although some of it
might be automatically checked and enforced by GitHub:

* was reviewed by at least by two reviewers;
* all review comments, suggestions or modification requests have been
  addressed;
* passes all :ref:`CI pipeline <ci>` checks;
* can be rebased on ``main`` without any conflict;

The maintainer shall have as the main objective when integrating the PR to
maintain a clear git history. Therefore, it should preferably perform either a
rebase of the PR branch on ``main`` (or fast-forward merge if possible) or
perform a squash merge if they deem necessary. If the PR originates from an
internal topic branch, the branch should be deleted. Only in extreme cases
where the PR has a long list of commits with heavy and intertwined refactoring,
a direct merge is acceptable.

At this point the maintainer should update any contributor, :ref:`author and/or
code owner files<github_files>`, especially when new files are created.

.. _commit_guidelines:

Commit and Pull-Request Guidelines
----------------------------------

All contributions must be submitted via Github pull-requests. You should ensure
that all commits within the PR:

* have messages that follow the :ref:`conventional commit style<>`
* introduce small, self-contained logical units of modifications/extensions
  and don't include irrelevant changes (typo or formatting fixes should be
  submitted in dedicated PRs);
* are logically related (unrelated modifications or fixes must be addressed
  in a separate branch/pull-request);
* follow a logical order. That is, a commit that has a dependence on the
  modifications by a different commit of the same PR, is after the former.
* adhere to the project's :ref:`coding guidelines<>` for the targeted
  languages;
* tag the necessary :ref:`requirements<>`;
* introduce code that is readable and sufficiently commented/documented;
* pass all :ref:`base CI pipeline<ci>` checks, by running them locally;
* make sure you code works: test you code in as many targets as possible
  and write the needed automated tests;
* introduces or updates the necessary documentation;
* the branch can be rebased on ``main`` without conflicts;
* the :ref:`appropriate license and copyright information<licensing>` is
  present and updated;
* make sure you have the rights to all the submitted code and that
  :ref:`all commits contain a sign-off message`, acknowledging the
  :ref:`DCO<dco>`;

Commits: Structure and Format
*****************************

.. _dco-sign-off:

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

* describes the introduced features, fixes, extensions, refactoring;
* provide a brief rationale for the chosen implementation or overall approach;
* how are you sure it works, i.e., describe the tests and corner cases you ran;

**Message footer**

The ``<footer>`` consists of a list of optional references when the commit:

* ``<ref-issue>``: addresses a GitHub issue (issue ID)
* ``<ref-misra>``: introduces a misra deviation (misra deviation or permit ID)
* ``<ref-req>``: implements a given requirement (requirement ID)
* ``<sign-off>``: a sign-off message that attests that he agrees with the
  contributor adheres :ref:`dco` (see :ref:`commit_signing`)

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
``.gitlint`` file in the :ref:`CI repository<>`, which defines a certain set of
rules that comply with the following list:

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

.. _commit_signing:

Commit Signing
**************

All commits must contain a sign-off message that attests you adhere to the
:ref:`DCO<dco>` containing:

* ``Your Name`` should be replaced by your legal name
* ``your.email@example.com`` should be replaced by your email that you are
  using to author the commit

This message must follow the format:

.. code-block:: none

    Signed-off-by: Your Name <your.email@example.com>

You can easily add this to your commit by using ``-s`` flag when running the
``git commit`` command. Beware that if your changing and existing signed
commit, you should add your sign-off right after the previous author.Make sure
that your local git name and email configuration are correct and match the ones
used in you GitHub account.

.. code-block:: none

    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"

All commits in a pull-request must be signed. To understand how to do this
checkout the `GitHub's Signing commits guide <https://docs.github.com/en/
authentication/managing-commit-signature-verification/signing-commits>`_. Make
sure that your `keys are correctly associated with the email <https://docs.
github.com/en/authentication/managing-commit-signature-verification/
associating-an-email-with-your-gpg-key>`_ associated with your GitHub account.


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
* ``.github/CODEOWNERS``: identifies the coder owners of the repository so
  they can be automatically notified for code-review. The file first line
  must assign all files to the repository's maintainers;
* ``.github/CONTRIBUTORS`` and ``.github/AUTHORS``: list all contributors
  and authors that submit code to that repository.


.. _branch_protection:

Branch Protection
*****************

All repositories' ``main`` branch must be configured with a set of protection
rules that aim at ensuring some of the rules defined in
:ref:`<contribution_workflow>`. In the repository's ``Settings -> Branches``
menu, a protection rules must be created with the following options:

* Require a pull request before merging:

    * Require approvals: 2
    * Dismiss stale pull request approvals when new commits are pushed
    * Require review from Code Owners

* Require status checks to pass before merging

    * Require branches to be up to date before merging

* Require conversation resolution before merging
* Require signed commits
* Require linear history
* Include administrators

Other topic branches might also be subject to protection rules at the will of
the repository's maintainers.

.. _github_actions:

CI/GitHub Actions
*****************

Every repository must have an automated :ref:`CI pipeline <ci>` setup using
GitHub Actions. Specifically, by adding workflow yaml files to the
``.github/workflows`` directory. The :ref:`CI repository <ci_repo>` contains a
number of templates as well as further instructions on how to set it up.

Here are a few workflows a maintainer should add to the repository's CI:

* commit message linting: apply gitlint to verify all the pull-requests'
  commit messages follow the conventional commit style;
* copyright and license check: making sure all files have the necessary
  license and copyright information;
* language format/linting: apply the language format checkers defined in
  the :ref:`CI repository <ci_repo>` for the repo's used languages (e.g.
  clang-format for C or pylint for python);
* static analysis: apply static analyses defined in :ref:`CI repository
  <ci_repo>` for the repo's used language (e.g. misra-check for C
  language);
* build: build the repository for a representative set of targets and
  configurations (using GitHub Actions' strategy matrix);

The maintainers are free to add more github workflows they feel are needed
due to the specificities of the repository.

.. _commit_branch_types:

Commit and Branch Types
-----------------------

The following are the allowed types for topic branches and commits:

* fix: bug fix
* ref: refactoring of a code block that neither fixes a bug nor adds a feature
* feat: a new feature
* build: changes that affect the build system or external dependencies
* doc: documentation only changes
* perf: a code change that improves performance
* wip: a code change that is still a work in progress
* exp: a code change that is purely experimental for now
* test: adding missing tests or correcting existing ones
* opt: modifications pertaining only to optimizations
* ci: changes to the CI configuration files and scripts
* style: changes that do not affect the meaning of the code (formatting,
  typos, naming, etc.)


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
