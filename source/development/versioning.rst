.. _versioning:

Releases and Versioning
=======================

Bao Project's repositories follow a `semantic versioning scheme <https://semver.org/>`_ where, for
each release, the specific `git commit is tagged
<https://git-scm.com/book/en/v2/Git-Basics-Tagging>`_ with  a label with the form
MAJOR.MINOR.PATCH, where each version component is incremented as following:

* **MAJOR** version when you make incompatible API changes
* **MINOR** version when you add functionality in a backward compatible manner
* **PATCH** version when you make backward compatible bug fixes

When incrementing a given version, the lower order components must be set to 0.

To illustrate, a project in its `2.3.1` version might:

* bump to `2.3.2` if a given bug is patched;
* go to `2.4.0` when adding new features that don't break interface compatibility;
* tag `3.0.0` when adding new features that break interface compatibility;

Release Cycle
-------------

Bao's Project releases follow a loosely time-based cycle. The expected release cadence,
specifically, bumping the **MINOR** or **MAJOR** versions, is expected to be every 4 to 8 months,
depending on the number of contributions on that given period. That is, if the number of
contributions does not justify a release bump, the release can be postponed to a maximum of 8
months.

Each release cycle is essentially composed by two stages:

* the **development stage**, where the normal development process goes on, PRs with either new
  features, fixes or other are submitted, reviewed and merged asynchronously, following the
  :ref:`contribution guidelines <contributing>`.

* during **stabilization stage**, the contributions made during the development stage should be
  thoroughly tested with the most comprehensive test batteries available. Further, integration
  tests may be added at this point. Besides new tests, maintainers must stop accepting PRs that are
  not bug fixes or documentation. This stage is expected to last between 2 to 8 weeks, so
  maintainers should be aware to stop the development stage after a maximum of about 6 months
  depending on the amount of new contributions. More contributions will require a longer
  pre-release stage.

At the end of the release cycle the version is tagged and the process starts all over again.

At any point during the release cycle **PATCH** version increments can be tagged to fix bugs,
especially safety hazards or security vulnerabilities.

Release Announcement
--------------------

For each release bump major or minor versions, a release announcement should be redact containing
the most relevant modifications compared to the previous release. It must highlight new features as
well any interface modifications that require users to update their configurations and setups.

The announcement must be publicized in the project's official communication channels (e.g., X,
LinkedIn, etc.);

Release Manager
---------------

For each release cycle one of the repo's maintainers (ideally always the same), should be elected
the **release manager**, which will be responsible for:

* deciding when the stabilization stage begins and ends;
* coordinating other maintainers during the stabilization phase;
* tagging and pushing the version to the repo;
* writing and publishing the release announcement;

Submodule Management
--------------------

Upon a release tagging, each submodule in the repo should be pointing to a specific release of the
submodule's repo. This may require that a repository's release cycle to be somewhat synchronized to
the release cycle of its submodule dependencies.
