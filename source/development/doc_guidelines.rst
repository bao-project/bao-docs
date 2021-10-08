Documentation Guidelines
========================

TBD...

.. _headings:

Headings
--------

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

.. _text_formatting:

Text Formatting
---------------
reST uses some few special characters to format text. The following table resumes the inline markup samples used throughout our documentation.

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

The use of backslash (``\``) is a work around to eliminate inline markup delimiters. Use before the character. 

.. _tables:

Tables 
------
Throughout our documentation there are a few tables to systematically present relevant information. We use `Grid tables
<http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables>`_ to create tables, which have the most flexibility to merge rows and columns. There are plenty of tools online that help to generate compatible grid tables, such as `TablesGenerator
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

Lists
-----

**Bullet List**

For bullet lists you can use the asterisk ``*`` or hyphen ``-`` characters at the start of the item. Continuation of a item can be achieve with two spaces limitation below the item. 

.. code-block:: rest

    * This is a bulleted list.
    * This is a big item break between two or more lines. 
      This is a big item break between two or more lines. This is a big item break between two or more lines. This is a big item break between two or more lines.

Rendered, the bullet lists look like this:

* This is a bulleted list.
* This is a big item break between two or more lines. 
  This is a big item break between two or more lines. This is a big item break between two or more lines. This is a big item break between two or more lines.

**Numbered List**

For numbered lists you can start the list with a ``1.`` or ``a)``. To continue the autonumbering, use the character ``#`` followed with ``.`` or ``)`` as used in the first list item. 

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

Rendered, the numbered lists look like this:

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

Code Blocks
-----------
The reST format uses the ``code-block`` directive to create a highlight block to showcase formatted code or console commands. You can choose the programming language has you can notice on the below example (``c``). Plese beware of the intentional blank line following the code-block syntax. You need also to indent the code segment. 

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

Moreover, you can also create a highlight a text segment with a code block. To achieve this, you just need to selected ``none`` as the "programming language".

.. code-block:: rest

    ..code-block:: none

        Takeaway 1: This is a highlighted text with a code block background and box.

Rendered, the code block looks like this:

.. code-block:: none

    Takeaway 1: This is a highlighted text with a code block background and box.

Referencing Links
-----------------
To create a implicit link to a title, you should know that all headings are considered as Hyperlinks. This is the syntax

.. code-block:: rest

    this is a link to `headings`_ from this page

Rendered, the implicit link looks like this:

    this is a link to `headings`_ from this page

To create a explicit link within the reST files, you need first to create a target location by following this syntax:

.. code-block:: rest

    .. _label_name:

To reference a target location, you should use this notation:

.. code-block:: rest

    :ref:`label_name`

If we reference a target located on the first three headings of this document, you should be able to navigate to all three spots:

- :ref:`headings`

- :ref:`text_formatting`

- :ref:`tables`

Images
------
To include images in the reST files, the following directive must be use:

.. code-block:: rest

    .. figure:: ../images/bao-logo.png
        :width: 200px
        :align: center
        :name: bao-logo-fig

        Caption for the Bao logo picture.

Rendered, the image should look like this:

.. figure:: ../images/bao-logo.png
    :width: 200px
    :align: center
    :name: bao-logo-fig

    Caption for the Bao logo picture.

You can after reference the image :numref:`bao-logo-fig` by using the notation ``:numref:`bao-logo-fig```, specifying the image name field. 

Tabbed Content
--------------
For certain situations, instead of creating multipled documents describing similiar content, you can use the ``tabs`` feature to merge all information in one document in an organized fashion. 

.. code-block:: rest

    .. tabs::

    .. tab:: Platform-A

        Platform A instructions.

    .. tab:: Platform-B

        Platform B instructions.

    .. tab:: Platform-C

        Platform C instructions.

Rendered, the tabbed content looks like this:


Boxes
-----------------
To highlight within a colored box, you can use three different directives depending on your goal.

.. code-block:: rest
    
    .. seealso:: This is a **seealso** box.

    .. note:: This is a **note** box.

    .. warning:: This is a **warning** box.

Rendered, the different boxes look like this:

.. seealso:: This is a **seealso** box.

.. note:: This is a **note** box.

.. warning:: This is a **warning** box.
