Code Documentation
==================

Code documentation is essential to ease code readability, maintenance and thus,
scalability. This becomes even more crucial in an open-source project, given
the number of diverse contributors that must be able clearly to understand
every aspect of code even when contributing without direct contact with each
other or the code owners and maintainers.

All code should be thoroughly commented not with obvious, explicit descriptions
of the code (e.g. ``x++; // increment x``), but provide:

* Detailed, high-level semantics descriptions;
* Clarifications on why a particular approach, technique, or algorithm was
  used;
* Any trade-offs or constraints that have been detected;
* Any other useful information.

Besides "traditional" code description and clarification comments that should
be applied to all code, regardless of used language, Doxygen comments are also
mandatory for all interfaces in C code and optional for private/static items.
Doxygen is a documentation generator tool used to document API's. This tool
extracts information from specially-formatted comments called tags. The
remaining sections of this tutorial will define guidelines and requirements on
how to use Doxygen within Bao Project's repository.

.. _generic:

Doxygen Generic Guidelines
--------------------------

Although this tutorial is focused on defining guidelines to apply the doxygen
tags to Bao's functions and data structures, there are some elemental rules
that must be followed for all doxygen comments:

* Block comments shall **start** with ``/**`` (slash-asterisk-asterisk)
  in a single line.
* Block comments shall **end** with ``*/`` (space-asterisk-slash) in a
  single line.
* Every other line inside the comment block shall start with ``*``
  (space-asterisk).
* Each different group tag (``@brief``, ``@param``, ...) shall be in at least
  one line. In other words, it is not possible to have two tags on the same
  line.
* All doxygen comments must be indented to the same level as the item they are
  describing.

On the beginning of every file there must be the mandatory license (SPDX
license identifier) before the file Doxygen block comment.

Example for the generic guidelines:

.. code-block:: c

 /**
  *  @brief Brief description of the function, struct, enum,...
  *  @param Paremeter_1 parameter_1 description
  *  @param Parameter_2 parameter_2 description
  *  @return return description
  */


.. _c:

C Code
------

Doxygen must be the tool used to document C code. The following sections
explain in what specific code items doxygen comments must be employed, and how
they must be structured, i.e., what tags must be detailed.

.. _functions:

Functions
*********

Functions are documented by three mandatory tags, following the mandatory
order: *brief*, *param*, *return*.
For a more complete description, optional tags can also be used (*pre*, *post*,
*invariant*, *warning*, *note*, *see*).

**Brief**

This first tag is used to describe the purpose of the function. Use
descriptive-style sentences for ``@brief`` descriptions, for example:
"Creates a task.", "Sends the events to the task.", or "Obtains the
semaphore.".

Do not use descriptions like "Returns this and that.". Leave the function
returns descriptions to the ``@return`` tag description.

**Parameters**

All function parameters must be documented in the order they appear on the
function arguments. Each function parameter should have its own ``@param`` tag.
After the tag, the user must write the parameter name, followed by a brief
description of its purpose in the function.

Whenever non-const pointer parameters are used, the following tags must be
employed:

* ``@param[out]``, if the function writes under some conditions to memory
  locations referenced directly or indirectly by the non-const pointer
  parameter;

* or ``@param[in, out]``, if the function reads under some conditions from
  memory locations referenced directly or indirectly by the non-const pointer
  parameter and the function writes under some conditions to memory locations
  referenced directly or indirectly by the non-const pointer parameter.

**Return**

This tag should be followed by an explanation of what the function returns. If
nothing is returned, then it can be omitted.
If the function returns a boolean value, use the ``@return`` description with
a phrase like this: “Returns true, if some condition is satisfied,
otherwise false.”. However, if the function changes a global variable, leave
that description to the ``@post`` tag.

**Pre**

This tag is used to inform the user about pre conditions to execute a function.
A pre-condition is a condition that must be true before the function or method
is called, in order for the function or method to work correctly.
For example, if a bit in a register must be set to execute the function.

**Post**

Use this tag whenever a function has any side-effect on the system (changing a
global variable, or an output). Those effects **must** be documented/described
on the ``@post`` tag.

**Invariant**

Whenever there is an invariant it must be documented on this tag.
An invariant is a condition that must always be met by a field of a struct
or a parameter of the function.

**See**

This is an optional tag that can be used to provide a cross-reference to
related documentation, within the code documentation or some external source,
through an URL. This is useful when information to understand the code is based
on external sources of the function.

**Note**

This is an optional tag that is used to inform the user about any updates that
has to be made, as well as to highlight important information or even providing
additional context for the documentation.

Template and Examples
#####################

This is a generic (*template*) description of all tags available for the user
to describe a function.

The last five tags (*pre*, *post*, *invariant*, *see* and *note*) are optional.

.. code-block:: c

 /**
  *  @brief <description>
  *  @param[in/out] <variable name> <description>
  *  @return <variable type> <description>
  *
  *  @pre <description>
  *  @post <description>
  *  @invariant <description>
  *  @see <function_name/URL> <description>
  *  @note <description>
  */

Example of the ``@return`` tag usage:

.. code-block:: c

 /**
  *  @brief Get link registers from GICH
  *  @return Returns the number of link registers
  */
 size_t gich_num_lrs()
 {
    return ((MRS(ICH_VTR_EL2) & ICH_VTR_MSK) >> ICH_VTR_OFF) + 1;
 }

*Examples* from Bao hypervisor's code on functions with and without return
types as well with and without arguments.

.. code-block:: c

 /**
  *  @brief Handle the exceptions exceptions such as guest page-faults or
  *         hypercalls.
  */
 void aborts_sync_handler()

.. code-block:: c

 /**
  *  @brief Checks if GICR got any pending interrupts to attend.
  *  @param int_id Interrupt id.
  *  @param gicr_id GICR id.
  *  @return True if 'int_id' interrupt is pending for the 'gicr_id'
  *          redistributor.
  */
 bool gicr_get_pend(irqid_t int_id, cpuid_t gicr_id)


.. _types:

Type Definitions (``struct``, ``enum``, ``unions`` and ``typedefs``)
********************************************************************

Regarding data structures there are three types of mandatory tags:
*data type*, *brief* and *var*.

**Data Type**

The comment block must start with the tag identifying the type of data
structure (``@struct`` for structures, ``@enum`` for enumerations, ``@typedef``
for ``typedef``, and ``@union`` for unions) following the name of that data
structure.

**Brief**

Each type (``typedef``, ``struct``, ``enum``, ``union``) defined in a header
file shall be documented with a ``@brief`` description informing the developer
about the role and the impact of the data structure on the code. This field
should be a one-liner describing the purpose of the struct. However the
developer can, when necessary, feel free to give a more detailed, multi-line
description. Nonetheless, this multi-line comment mustn't be more than a couple
of lines, or a small paragraph.

For the ``@brief`` description of types use phrases like "This type
represents ...", "This structure represents ...", "This structure provides ..."
, or "This enumeration represents ...".

**Struct variables**

The third tag (``@var``) is used to describe the context/role of each variable
within the data structure. Note that the variable description must start with
a capital letter (see examples).

For the description of each type members you can use phrases like "This member
represents...", "The X lock protects...", "Used to...", "Contains...",
"Stores ..."

Template and Examples
#####################

Bellow we showcase a *template* of the available tags to describe a structure.

.. code-block:: c

  /**
  * @struct <struct_name>
  * @brief <Description>
  */

*Examples* for the *memory protection* struct and the two distinct
approaches to comment on this type of data.The variables can either be
commented on the header with the tag ``@var`` or within their declaration with
the comment starting with ``/**<``.

.. code-block:: c

  /**
  * @struct memory_protection
  * @brief This structure represents a memory region
  */
  struct memory_protection
  {
    bool assigned;         /**< Memory region assign flag */
    vaddr_t base_addr;     /**< Region base address */
    size_t size;           /**< This member contains the region size */
    cpumap_t shared_cpus;  /**< Bitmap used when sharing region w/other cores */
    mem_flags_t mem_flags; /**< Region memory attributes */
  };


.. _files:

Files
*****

All files must have a doxygen comment after the mandatory license header
(see :ref:`generic`), detailing the purpose and use for the file.
The two tags on the doxygen-style comments are *file* and *brief*.

**File**

The ``@file`` tag identifies the filename and its type (e.g., ``.h``, ``.c``).

**Brief**

The ``@brief`` is then used to describe the general purpose of the functions in
the file or/and to explain why a specific set of functions or data structures
are grouped together in the file.

On the ``@brief`` description it can have sentences like "This header file
provides ...", "This header file provides the API of ...", or "This file
provides interfaces and functions used to implement ...".

Template and Examples
#####################

*Template* of the license and available tags to describe a file.

.. code-block:: c

  /**
  * @file <filename.type>
  * @brief <Text>
  */

*Practical Example* on the *vm.h* file header, which provides VM structures
and functions.

.. code-block:: c

  /**
  * @file vm.h
  * @brief This header file provides VM structures and functions
  */


.. _macros:

Macros
******

To document macros, the tag ``@def`` must be used. Following the tag, the
macro, with the name and the parameters must be explicit. The other mandatory
tag is the ``@brief`` tag, that must briefly describe the objective of the
macro.

.. code-block:: c

  /**
  * @def MACRO(arg1, arg2)
  * @brief description of the macro.
  */
  #define MACRO(arg1, arg2) ((arg1) + (arg2))


.. _variables:

Variables
*********

For variables you must start the comment with ``/*!<`` and end it normally
with ``*/``. Describe the objective of the variable. For a boolean type use
a phrase like: “The variable X is true, if some condition is satisfied,
otherwise it is false.”. This should be used on global variables or on any
other variable (when appropriate).

.. code-block:: c

  int var; /*!< Detailed description after the variable */
