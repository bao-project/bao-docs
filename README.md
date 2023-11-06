# Bao Documentation

This repository aims at centralizing the artifacts related to the full
documentation of the [Bao Project](http://www.bao-project.org/). The documents
are fully written in American English, following the
[reStructureText](https://docutils.sourceforge.io/rst.html) (reST) format, and
hosted in the [ReadTheDocs](https://bao-project.readthedocs.io/) web service.
We also use the [Sphinx](https://www.sphinx-doc.org/) tool to generate the
documentation in the html format.

## Overview
The bao-docs repository follows the basic directory layout defined by Sphinx
, with two top-level directories:

- ``build``: contains the resulting rendered documentation after running the
Sphinx build
- ``source``: holds each reST document following the structure as explained
  [below](#organization)

The organization of documentation under the ``source`` directory is structured
into 4 top-level folders. The following table specifies the meaning of each
folder:

<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky">Folder</th>
    <th class="tg-0pky">Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">introduction</td>
    <td class="tg-0pky">Holds all documentation that is supposed to be the
    first contact to the project, presenting an overview of the project and
    a <span style="font-style:italic">*getting started*</span> guide to help
    new users.</td>
  </tr>
  <tr>
    <td class="tg-0pky">user_manual</td>
    <td class="tg-0pky">Holds all documentation that intend to assist users
    during the utilization of the Bao framework.</td>
  </tr>
  <tr>
    <td class="tg-0pky">internals</td>
    <td class="tg-0pky"></td>Holds all documentation that describes in detail
    each internal component of Bao.
  </tr>
  <tr>
    <td class="tg-0pky">development<br></td>
    <td class="tg-0pky">Holds all documentation that specifies the guidelines
    to take into consideration during the development activities, namely,
    coding and documentation style, contributing workflow, the CI
    pipeline, testing framework, among others.</td>
  </tr>
</tbody>
</table>

## Generating the Documentation
### Prerequisites
To generate the documentation locally, developers need to install a set of
prerequisites, depending on the host machine. Follow the steps described below
for your specific machine.

For **Linux** users, start by installing dependencies and each tool package and
extension (i.e., Sphinx, the spell checker extension
[sphinxcontrib.spelling](https://sphinxcontrib-spelling.readthedocs.io/), the
[sphinx tabs](https://sphinx-tabs.readthedocs.io/en/latest/) extension and the
format checker [doc8](https://github.com/PyCQA/doc8)).

```bash
sudo apt-get install enchant
pip install sphinx sphinxcontrib-spelling sphinx-tabs pyenchant doc8
```

### Building and Checking
If you wish to contribute to the documentation you should first take a close
look at the [contribution](source/development/contributing.rst) and follow the
[documentation](source/development/doc_guidelines.rst) guidelines. The
documentation sources' spelling and formatting are automatically verified with
the help of the [bao CI](https://github.com/bao-project/bao-ci) documentation
checkers.

For **Linux** users, start by checking the documentation for spell and format
errors. To check for spelling typos, you need to run the following command:

```bash
make spelling
```

To check for format issues, you need to run the following command:

```bash
make rst-format
```

After correcting all outputted errors, you can build the documentation and
generate the html files:

```bash
make html
```

The html files are under the `build` folder and you can visualize them by
opening the `html/index.html` file on your browser.
