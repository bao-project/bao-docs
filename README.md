# Bao Documentation

This repository aims at centralizing the artifacts related to the full
documentation of the [Bao Project](http://www.bao-project.org/). The documents
are fully written in the [reStructureText](https://docutils.sourceforge.io/rst.html)
(reST) format and are hosted in the [ReadTheDocs](https://bao-project.readthedocs.io/)
web service. We also use the [Sphinx](https://www.sphinx-doc.org/) tool to
generate the documentation in the html format.

## General Overview
The repository of bao-docs follows the basic directory layout defined by Sphinx
, having on the top-level two main directories:

- ``build``: folder to hold the resulted rendered documentation after running
the Sphinx build
- ``source``: folder to hold each reST document, which we explain the
organization structure [below](#organization)

### Organization
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
    <td class="tg-0pky">development<br></td>
    <td class="tg-0pky">Holds all documentation that specifies all guidelines
    to take into consideration during the development activities, namely,
    the coding and documentation style, contributing workflow, the CI
    pipeline, the testing suite, among others.</td>
  </tr>
  <tr>
    <td class="tg-0pky">internals</td>
    <td class="tg-0pky"></td>
  </tr>
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
</tbody>
</table>

## Generating the Documentation
To generate the documentation locally, developers need to install a set of
prerequisites, depending on the host machine. Follow the steps described below
for your specific machine.

### Linux Prerequisites


### Windows Prerequisites

### Building

#### Linux

#### Windows
