Documentation Guidelines
========================

The Bao hypervisor and tool documentation is written in `reStructuredText
<https://docutils.sourceforge.io/rst.html>`_ markup language and enhanced with `Sphinx
<https://www.sphinx-doc.org/en/master/>`_ extensions. This documentation can be built into HTML
content by the running ``make html`` in the documentation repo's top level directory. Developers
can open the ``index.html`` file created in the build folder in a web browser to inspect the final
output and how it is rendered.

.. note::
    In order to maintain consistency throughout Bao's documentation, for
    each reST syntax element, we have defined a set of guidelines specifying
    where, when and how each element should be applied. The guidelines are
    highlighted in a **Note** box like this one.

reST Syntax
-----------

.. _headings:

Headings
********

.. code-block:: rest

   Document Title heading
   ======================

   Section 1 heading
   -----------------

   Section 2 heading
   -----------------

   Section 2.1 heading
   *******************

   Section 2.1.1 heading
   #####################

   Section 2.2 heading
   *******************

   Section 3 heading
   -----------------

.. note::
    - Headings **must** be used to mark sections of a document.
    - Headings **must** be used in a consistent manner by following this defined order:

        - ``=`` underlining characters for the Document Title
        - ``-`` underlining characters for the First section level
        - ``*`` underlining characters for the Second sub-section level
        - ``#`` underlining characters for the Third sub-section level

.. _text_formatting:

Text Formatting
***************
reST uses some few special characters to format text. The following table resumes the inline markup
samples used throughout our documentation.

+-------------+------------------------+----------------------+
|    format   |         syntax         | rendering            |
+=============+========================+======================+
|    italic   |      ``*italic*``      | *italic*             |
+-------------+------------------------+----------------------+
|     bold    |      ``**bold**``      | **bold**             |
+-------------+------------------------+----------------------+
| inline code |   ````inline code````  | ``inline code``      |
+-------------+------------------------+----------------------+
| link        | ```Bao <http://www.bao | `Bao <http://www.bao |
|             | -                      | -                    |
|             | project.org/>`_``      | project.org/>`_      |
+-------------+------------------------+----------------------+

The use of backslash (``\``) is a work around to eliminate inline markup delimiters. Use before the
character.

.. note::
    - Bold format **should** be used to strongly emphasize information.
    - Italic format **should** be used to lightly emphasize information.
    - Inline code format **must** be used when small code samples are used in
      the text (i.e., file paths, file names, shell commands, programming
      language directives/keywords/identifiers, syntax characters).
    - Link format **must** be used when referencing any external link.

.. _tables:

Tables
******
Throughout our documentation there are a few tables to systematically present relevant information.
We use `Grid tables
<http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables>`_ to create
tables, which have provides a lot of flexibility to merge rows and columns. There are plenty of
other tools online to help generate compatible grid tables, such as `TablesGenerator
<https://www.tablesgenerator.com/>`_.

.. code-block:: rest

   +------------+---------------------------+-----------+-----------+
   |  header-c1 |         mheader-c2        | header-c3 | header-c4 |
   +============+=============+=============+===========+===========+
   |    r1_c1   |   r1_mc2-1  | r1_mc2-2    | r1_c3     | r1_c4     |
   +------------+-------------+-------------+-----------+-----------+
   |   mr2_c1   | mr2-1_mc2-1 | mr2-1_mc2-2 | mr2-1_c3  | mr2-1_c4  |
   |            +-------------+-------------+-----------+-----------+
   |            | mr2-2_mc2-1 | mr2-2_mc2-2 | mr2-2_c3  | mr2-2_c4  |
   +------------+-------------+-------------+-----------+-----------+

Rendered, the table looks like this:

+------------+---------------------------+-----------+-----------+
|  header-c1 |         mheader-c2        | header-c3 | header-c4 |
+============+=============+=============+===========+===========+
|    r1_c1   |   r1_mc2-1  | r1_mc2-2    | r1_c3     | r1_c4     |
+------------+-------------+-------------+-----------+-----------+
|   mr2_c1   | mr2-1_mc2-1 | mr2-1_mc2-2 | mr2-1_c3  | mr2-1_c4  |
|            +-------------+-------------+-----------+-----------+
|            | mr2-2_mc2-1 | mr2-2_mc2-2 | mr2-2_c3  | mr2-2_c4  |
+------------+-------------+-------------+-----------+-----------+

.. note::
    - Tables **can** be used to represent well-defined tabular information.
    - Tables **must** be wider than a two-row structure (including the header)

Lists
*****
There are three types of possible lists: bullet lists, numbered lists, and definition lists. Bullet
and numbered lists should be indented at the same level as the preceding paragraph (and not
indented itself). Additional lines are indented to the first character of the text of the bullet
list.

**Bullet List**

For bullet lists you can use the asterisk ``*`` or hyphen ``-`` characters at the start of the
item. Continuation of an item can be achieve with two spaces limitation below the item.

.. code-block:: rest

    * This is a bulleted list.
    * This is a big item break between two or more lines. This is a big item break between two or
      more lines. This is a big item break between two or more lines. This is a big item break
      between two or more lines.
        * Second-level bulleted list. This is a big item break between two or more lines.


Rendered, the bullet list looks like this:

* This is a bulleted list.
* This is a big item break between two or more lines. This is a big item break between two or more
  lines. This is a big item break between two or more lines. This is a big item break between two
  or more lines.

    * Second-level bulleted list. This is a big item break between two or more lines.

**Numbered List**

For numbered lists you can start the list with a ``1.`` or ``a)``. To continue the auto-numbering,
use the character ``#`` followed with ``.`` or ``)`` as used in the first list item.

.. code-block:: rest

    1. item 1
        1. sub-item 1.1
        #. sub-item 1.2
        #. sub-item 1.3

    #. item 2
        a) sub-item 2a
        #) sub-item 2b

    #. item 3
        #) sub-item 3.1
        #) sub-item 3.2

Rendered, the numbered list looks like this:

1. item 1
    1. sub-item 1.1
    #. sub-item 1.2
    #. sub-item 1.3

#. item 2
    a) sub-item 2a
    #) sub-item 2b

#. item 3
    #) sub-item 3.1
    #) sub-item 3.2

**Definition List**

This a convenient type of list to list one or more terms and their definition.

.. code-block:: rest

    Term1
        This statement gives a definition for the Term1.
    Term2
        This statement gives a definition for the Term2.

Rendered, the definition list looks like this:

Term1
    This statement gives a definition for the Term1.
Term2
    This statement gives a definition for the Term2.

.. note::
    - Bullet lists **should** be used to display a list of itemized
      terms/sentences without a certain order.
    - Bullet lists **should** be used with at least two items.
    - Numbered lists **must** be used to display an ordered/sequential list of
      itemized conclusions or steps.
    - Numbered lists **should** be used with more than two items.
    - Definition lists **must** be used when a term definition is in place.

Code Blocks
***********
The reST format uses the ``code-block`` directive to create a highlight block to showcase formatted
code or console commands. You can choose the programming language as exemplified in the example
below for the C language and shell syntaxes. Please beware of the intentional blank line following
the code-block syntax. You also need to indent the code segment.

.. code-block:: rest

    .. code-block:: c

        uint64_t smc_fid = cpu.vcpu->regs->x[0];
        uint64_t x1 = cpu.vcpu->regs->x[1];
        uint64_t x2 = cpu.vcpu->regs->x[2];
        uint64_t x3 = cpu.vcpu->regs->x[3];

.. code-block:: rest

    .. code-block:: shell

        cd ~

Rendered, the code blocks look like this:

.. code-block:: c

    uint64_t smc_fid = cpu.vcpu->regs->x[0];
    uint64_t x1 = cpu.vcpu->regs->x[1];
    uint64_t x2 = cpu.vcpu->regs->x[2];
    uint64_t x3 = cpu.vcpu->regs->x[3];

.. code-block:: shell

        cd ~

Moreover, you can also highlight a text segment using a code block. To achieve this, you just need
to selected ``none`` as the "programming language".

.. code-block:: rest

    ..code-block:: none

        Takeaway 1: This is a highlighted text with a code block background and box.

Rendered, the code block looks like this:

.. code-block:: none

    Takeaway 1: This is a highlighted text with a code block background and box.

.. note::
    - Code blocks **must** be used to display large code segments.
    - Code blocks **must** be used with the appropriate programming language
      attribute (use the **none** attribute when the language is not supported
      by `Pygments <https://pygments.org/languages/>`_).
    - Code blocks **can** be used to lightly highlight a large text segment.


Referencing Links
*****************
To create a implicit link to a section title, you should know that all headings automatically
generate hyperlink targets. This is the syntax:

.. code-block:: rest

    this is a link to the `Code Blocks`_ section in this page this is a link to the Lists_ section
    in this page

Rendered, the implicit link looks like this:

* this is a link to the `Code Blocks`_ section in this page
* this is a link to the Lists_ section in this page

To create a explicit link within the reST files, you need first to create a target location by
following this syntax:

.. code-block:: rest

    .. _label_name:

To reference a target location, you should use this notation:

.. code-block:: rest

    :ref:`label_name` :ref:`Text<label_name>`

If we reference a target located on the first three headings of this document, you should be able
to navigate to all three spots:

- :ref:`headings`

- :ref:`text_formatting`

- :ref:`Tables are here<tables>`

.. note::
    - Implicit referencing links **should** be used to reference section titles
      within the respective reST file that they are used.
    - Explicit referencing links **should** be used to reference an arbitrary
      location within or outside of a document.

Images
******
To include images in the reST files, the following directive must be use:

.. code-block:: rest

    .. figure:: img/bao-logo.png
        :width: 200px
        :align: center
        :name: bao-logo-fig

        Caption for the Bao logo picture.

Rendered, the image should look like this:

.. figure:: img/bao-logo.png
    :width: 200px
    :align: center
    :name: bao-logo-fig

    Caption for the Bao logo picture.

The image :numref:`bao-logo-fig` can be later referenced by using the notation
``:numref:`bao-logo-fig```, specifying the image name field.

.. note::
    - Image files **must** be stored in the current directory ``img`` folder
      (e.g., ``development/img/``).
    - Images **must** contain a description in the caption.
    - Images **should** be in a ``.png`` file format.

Tabbed Content
**************
For certain situations, instead of creating multiple documents describing similar content, you can
use the ``tabs`` feature to merge all information in one document in an organized fashion.

.. code-block:: rest

    .. tabs::

    .. tab:: Platform-A

        Platform A instructions.

    .. tab:: Platform-B

        Platform B instructions.

    .. tab:: Platform-C

        Platform C instructions.

Rendered, the tabbed content looks like this:

.. tabs::

    .. tab:: Platform-A

        Platform A instructions.

    .. tab:: Platform-B

        Platform B instructions.

    .. tab:: Platform-C

        Platform C instructions.

.. note::
    - Tabs **should** be used to organize similar information that differ in a "configuration option" (e.g., build instructions across different platforms).

Boxes
*****
To highlight text within a colored box, you can use three different directives depending on your
goal.

.. code-block:: rest

    .. seealso:: This is a **seealso** box.

    .. note:: This is a **note** box.

    .. warning:: This is a **warning** box.

Rendered, the different boxes look like this:

.. seealso:: This is a **seealso** box.

.. note:: This is a **note** box.

.. warning:: This is a **warning** box.

.. note::
    - See also boxes **should** be used to highlight (beginning with a preliminary description) additional text information referenced externally.
    - Note boxes **should** be used for information that you want the user to pay particular attention to.
    - Warning boxes **should** be used for information the user must understand to avoid negative consequences.

TODO, FIXME and DEPRECATED Tags
*******************************

While writing Bao documentation, the TODO and FIXME tags can be used as typical inline comments
(``.. This is a comment.``) to tag content that is missing, needs refactoring or optimization, or
is broken (in the sense that the output is not what is expected). See below the meaning of each tag
and use it accordingly.

**TODO** tags can be used to mark documentation content that (i) is missing or should be added in
the future or (ii) needs any refactoring or optimization.

.. code-block:: rest

    .. TODO: This is a TODO tag.

**FIXME** tags can be used to mark documentation content that is broken, in the sense that the
output after building is not showing what is expected. Identified misuse of the markdown syntax can
be marked with this tag.

.. code-block:: rest

    .. FIXME: This is a FIXME tag.

**DEPRECATED** tags can be used to mark documentation content that is deprecated and must be
updated.

.. code-block:: rest

    .. DEPRECATED: This is a DEPRECATED tag.

Spelling and Format Checkers
----------------------------
To keep the consistency of the documentation, the :ref:`CI pipeline <ci>` runs two checkers to find
misspelled words and invalid reST format styles. The checkers can be run locally by just running
the following Make rules:

To run the `sphinxcontrib.spelling <https://sphinxcontrib-spelling.readthedocs.io/en/latest/>`_
spell checker:

.. code-block:: shell

    make spelling

To run the `doc8 <https://github.com/PyCQA/doc8>`_ format checker:

.. code-block:: shell

    make rst-format

Besides checking for invalid reST format styles (D000 rule), the ``rst-format`` also checks
for:

.. note::
    - lines longer than 99 characters - D001
    - no trailing whitespace - D002
    - no tabulation for indentation - D003
    - no carriage returns (use unix newlines) - D004
    - no newline at end of file - D005

**Spelling Dictionaries**

The spell checker uses standard enchant dictionaries to validate words. However, some specific
words are not recognized, and can be added into a internal dictionary to avoid the spelling error.
The ``source/spelling_wordlist.txt`` plain text file contains the extended dictionary words - one
word per line. Use this dictionary to add meaningful words (e.g., fallthrough, requalification) or
nouns that can be used throughout other documentation files, such as tool names (e.g., Doxygen,
Github), programming languages keywords (e.g., struct, typedef), or others.

Some words that don't have a particular meaning (e.g., the words ``mc``, ``mr``, etc used in this
document to represent rows and columns on the `tables`_ section) will only make sense on this
document, therefore the following directive should be used to create a list of words known to be
spelled correctly within a single file.

.. code-block:: rest

    .. spelling:word-list::

        mc mr mheader mc html

.. spelling:word-list::

    mc mr mheader mc html

Glossary of Terms
-----------------
Throughout Bao's documentation we try to maintain an updated and consolidated global glossary, that
references terms to their definitions. The :ref:`glossary` is located in the ``source`` top-level
directory, under the file ``glossary.rst``. Each glossary entry, must be written as a definition
list, with a capitalized term, followed by a single-line indented definition (see the code block
below to verify the format).

.. code-block:: rest

    .. glossary::
        :sorted:

        Term1
            Brief description

        Term2
            Brief description

To link terms with the glossary, the keyword ``:term:`term1``` must be used, which transforms
``term1`` in a hyperlink to its glossary entry.

.. note::
    - While writing the documentation, a best-effort **should** be in-place to
      guarantee that each new term (i.e., abbreviations, siglums, bao's
      architectural components/services/entities) are added to the glossary.
    - If a new term is added to the glossary, you **must** search for each
      reference in all other documents and mark it with the ``:term:`` keyword
      to created a link to the glossary entry. However, this should be
      avoided if the term has a dedicated file documenting it (e.g.,
      :ref:`CI <ci>`, :ref:`MISRA <misra>`). Use explicit referencing
      instead. Notwithstanding, add the term to the glossary.
