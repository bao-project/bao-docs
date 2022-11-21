Writing Requirements
====================


The Bao Project uses the `doorstop <https://github.com/doorstop-dev/doorstop>`_
tool to help manage, track and maintain requirements in a consistent format.
Doorstop is a command line tool to manage requirements written in plain text,
which can then be managed by using VCS, such as git, and written using a text
editor.

Bao's requirements are maintained in their own repository `bao-project/bao-reqs
<https://github.com/bao-project/bao-reqs>`_.

Bao Requirement Hierarchy
-------------------------

The `bao-reqs <https://github.com/bao-project/bao-reqs>`_ repository stores all
requirements starting from :ref:`Objectives`. The following diagram illustrates
the portion of the requirement hierarchy managed through doorstop.


.. code-block:: none

   OBJ
    │
    └── HLR
        │
        └── DLR
            │
            ├── ILR
            │
            └── DLER


For an overview of each hierarchy level please refer to the
:ref:`requirement_framework`.

Doorstop terms and definitions
------------------------------

Item An item is a single requirement. Each item is stored in a single YAML file
following a well-defined schema.

Document A document is a directory containing a collection of items.

Standard Item Properties Doorstop Items have multiple properties. For a
description of these properties see `Doorstop Items
<https://doorstop.readthedocs.io/en/latest/reference/item/>`_.

Custom Item Properties Doorstop allows the creation of custom Item properties,
which we leverage to add meaningful attributes to requirements in the context
of Bao. Here we list them.

        type
            Can be either ``Functional`` or ``Non-Functional``

        priority
            Priority of this requirement in relation to other requirements. Can
            be ``High``, ``Medium``, ``Low``.

        observation
            A property to store additional information about the requirement
            that complements the description in the text.

Adding Requirements
---------------------

To add new requirements to a document you can run, for example:

.. code-block:: shell

    doorstop add HLR

This command will add a new requirement (Item) to the HLR document. However,
given that we use custom properties it is cumbersome to retrieve them every
time a new requirement is added. To help with this, there's a default item with
the custom attributes filled with blanks. This item is ``default.yml`` in
`bao-project/bao-reqs <https://github.com/bao-project/bao-reqs>`_. To leverage
it, run, for example:

.. code-block:: shell

    doorstop add -d default.yml HLR

This way the ``default.yml`` parameters will be used as a template for a new
item in HLR.

To streamline things even further there's a ``env_setup.sh`` file that creates
an alias for this command. To include the alias in your environment run the
following command:

.. code-block:: shell

    . env_setup.sh

The following alias is now available:

.. code-block:: shell

    alias dsadd="doorstop add -d default.yml"

Example usage:

.. code-block:: shell

    dsadd HLR

Finally you can either navigate to the created item, or you can edit your item
in the list of HLR by running the following command:

.. code-block:: shell

    doorstop edit HLR

The commands presented so far are appropriate for handling adding a small
number of requirements. However if adding large amounts of requirements an
alternative approach is to export a document to a ``.csv`` file. This can be
done by running, for example:

.. code-block:: shell

   doorstop export DLR DLR.csv

This command will take all requirements in the DLR document and write them unto
single lines in a ``.csv`` file that can be edited using a Spreadsheet editor.
When using this method you should be careful as to not replace the Items' UID
as it will break any links established between levels of the requirement
hierarchy.


.. Note::
   The CI workflows will automatically fail if there are any issues with the
   requirement documents including broken requirement links due to unreviewed
   changes.


Adding Objectives
-----------------

With the goal of making requirement UIDs more meaningful, we write the
:ref:`Objectives` UIDs in the form of: OBJ_<class>_XXX. OBJ signifies that the
item pertains Objectives. <class> is either UTIL for utilitarian objectives,
SAF for safety objectives, or SEC for security objectives. XXX is a number
starting from 000. The disadvantage of modifying the UID is that it must be
managed manually.

In this document we make use of the header property, see `Items
<https://doorstop.readthedocs.io/en/latest/reference/item/>`_ , to give a name
to each Objective.



Adding HLR
-----------------

In :ref:`HLR` we make use of linear UIDs, resulting in UIDs in the form of:
HLR_XXX. XXX is a number starting from 000.


Adding DLR
-----------------

In :ref:`DLR` we again use a modified UID. In DLR the UIDs take the form of:
DLR_<COMPONENT>_XXX. Where DLR identifies the DLR document. <COMPONENT>
identifies the system component which the requirement targets. Currently Bao
has DLR for the following components (component → Abbreviation used in UID):
Tool→ TOOL, Partitioner→ PART, VMM Static→ VMMSTATIC.


Managing Requirements
---------------------

There are two main activities apart from purely establishing requirements.
Linking requirements to the above hierarchical requirement layer, and reviewing
requirements.


Linking Requirements
********************

Linking requirements can be done through the command-line tool:

.. code-block:: shell

    doorstop link HLR_001 DLR_TOOL_020

By adding the following field to the Item in a text editor:

.. code-block:: shell

   links:
   - HLR_001:

Or by specifying the link in the export file (e.g., ``.csv``) the using the UID
column in the appropriate requirement row.

.. Note::
   Only after the requirements are reviewed will links be presented when
   published. This is because the link between requirements is tied not only to
   the item UID, but also to all its property values. This means that any
   change to a linked requirement will result in the link breaking. To fix the
   link the changed requirement should be marked as reviewed.

Reviewing Requirements
**********************

Once you have made the intended modifications to the requirements, run the
following command to mark all requirements as reviewed:

.. code-block:: shell

   doorstop review

To mark only a single requirement as reviewed run:

.. code-block:: shell

   doorstop review <requirement UID>

Generating the Requirements
---------------------------

To generate an HTML page which presents the requirements run:

.. code-block:: shell

    doorstop publish all ./publish

To make things easier, the ``Makefile`` creates a rule called ``dspub``.

.. code-block:: shell

    dspub:
            doorstop publish all ./publish

Simply run the following command to generate the HTML page:

.. code-block:: shell

    make dspub

Finally to take a look at the requirements in an HTML format open the
``index.html`` file in the publish folder by running, for example:

.. code-block:: shell

    sensible-browser ./publish/index.html

To make it simpler the ``Makefile`` provides the ``dsshow`` rule:


.. code-block:: shell

    dsshow:
            sensible-browser ./publish/index.html

Thus, to open the requirements HTML page simply run:

.. code-block:: shell

    make dsshow

Traceability
------------

The ``index.html`` in the output folder will show the Item traceability.
Additionally requirements can also be traceable to code.

Traceability to Code
********************

Doorstop provides the mechanisms to trace requirements to code by using the
``references`` property, see `here
<https://doorstop.readthedocs.io/en/latest/reference/item/#references-new-array-behavior>`_.

Checking for errors
-------------------

To make sure the current modifications to the requirements do not cause errors
run the Makefile rule ``ci``:

.. code-block:: shell

    make ci



