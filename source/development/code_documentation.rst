Code Documentation
==================

Code documentation is essential to ease code readability, maintenance, and scalability. This
becomes even more crucial in open-source projects, where a diverse group of contributors must
understand the codebase without direct contact with each other, the code owners, or the
maintainers.

All code should be thoroughly commented not with obvious, explicit descriptions of the code (e.g.
``x++; // increment x``), but provide:

* Detailed, high-level semantic descriptions of the code functionality, purpose, and expected
  behavior;
* Clarifications on why a particular approach, technique, or algorithm was used;
* Any trade-offs or constraints that have been detected;
* Any other useful information that can help readers understand and maintain the code.

In addition to the "traditional" code description and clarification comments that are essential for
all code, we use the Doxygen documentation generator tool to comment all Application Programming
Interfaces (APIs). Doxygen extracts information from specially-formatted comments, known as
**tags**, and produces documentation in various formats. The remaining sections of this tutorial
will outline the guidelines and requirements for using Doxygen within the project repositories.

.. _generic:

Doxygen Generic Guidelines
--------------------------

While this tutorial primarily provides guidelines for applying Doxygen tags to code functions and
data structures, there are some fundamental rules that **must** apply to all Doxygen comments:

* Block comments **must** start with ``/**`` (slash-asterisk-asterisk) in a single line.
* Block comments **must** end with ``*/`` (space-asterisk-slash) in a single line.
* Every other line inside the comment block **must** start with ``<whitespace>*`` (space-asterisk).
* Each different tag  (``@brief``, ``@param``, ...) **must** be in a a separate line.
* All doxygen comments **must** be indented to the same level as the item they are describing.
* All APIS **must** be commented with doxygen tags, except for private/static functions, which is
  optional.

As stated in the :ref:`licensing guidelines <licensing>`, every file must start with a header
comment including an SPDX license identifier and copyright statement. All doxygen block comments,
including the **file** brief, must be placed after this header.Example for the generic guidelines:

.. code-block:: c

 /**
  *  @brief Brief description of the function, struct, enum,...
  *  @param Parameter_1 parameter_1 description
  *  @param Parameter_2 parameter_2 description
  *  @return return description
  */


.. _c:

C Code
------

Doxygen must be the tool used to document C code. The following sections explain in what specific
code items doxygen comments must be employed, and how they must be structured, i.e., what tags must
be detailed.

.. _functions:

Functions
*********

Functions **must** be documented by three mandatory tags that follow a specific order: *brief*,
*parameters*, and *return*. For a more complete description, optional tags **should** also be used,
namely, *pre*, *post*, *invariant*, *warning*, *note*, and *see*.

**Brief**

The tag ``@brief`` **must** be used to describe the purpose of the function. The tag should provide
a useful description of the function, such as: *Creates a task*, *Sends the events to the task*, or
*Obtains the semaphore*. Do not use flat, code-oriented descriptions like *Returns the buffer x* or
*Increments variable a with b*. Beware that function return descriptions **must** use the
``@return`` tag description.

**Parameters**

The tag ``@param`` **must** be used to describe each function parameter in the order they appear on
the function arguments. Each function parameter **must** have its own tag. After the tag, the user
must write the parameter name, followed by a brief description of its purpose in the function.

Whenever non-const pointer parameters are used, the following tags **must** be employed:

* ``@param[out]``, if the function writes under some conditions to memory locations referenced
  directly or indirectly by the non-const pointer parameter;

* or ``@param[in, out]``, if the function reads under some conditions from memory locations
  referenced directly or indirectly by the non-const pointer parameter and the function writes
  under some conditions to memory locations referenced directly or indirectly by the non-const
  pointer parameter.

**Return**

The tag ``@return`` **must** be used to provide an description on the function return. Only if
nothing is returned, then the tag can be omitted. If the function returns a boolean value, use the
tag with a condition-oriented description such as: *Returns true, if some condition is satisfied,
otherwise false.*. However, if the function changes a global variable, leave that description to
the ``@post`` tag.

**Pre**

The tag ``@pre`` **should** be used to inform the user about pre conditions to execute a function.
A pre-condition is a condition that must be true before the function or method is called, in order
for the function or method to work correctly. For example, if a bit in a register must be set to
execute the function.

**Post**

The tag ``@post`` **should** be used whenever a function has any side-effect on the system
(changing a global variable, or an output).

**Invariant**

The tag ``@invariant`` **should**  be used whenever there is an invariant that must be documented.
An invariant is a condition that must always be met by a field of a struct or a parameter of the
function.

**See**

The ``@see`` tag **should**  be used to provide a cross-reference to related documentation, within
the code documentation or some external source, through an URL. This is useful when information to
understand the code is based on external sources of the function.

**Note**

The tag ``@note`` **should**  be used to inform the user about any updates that has to be made, as
well as to highlight important information or even providing additional context for the
documentation.

Template/Examples
#################

Template:

.. code-block:: c

 /**
  *  @brief <description>
  *  @param[in/out] <variable_name> <description>
  *  @return <variable_type> <description>
  *
  *  @pre <description>
  *  @post <description>
  *  @invariant <description>
  *  @see <function_name/URL> <description>
  *  @note <description>
  */

Several examples:

.. code-block:: c

  /**
   *  @brief Get link registers from GICH
   *  @return Returns the number of link registers
   */
  size_t gich_num_lrs() {
    return ((MRS(ICH_VTR_EL2) & ICH_VTR_MSK) >> ICH_VTR_OFF) + 1;
  }

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

Type Definitions
****************

Type definitions (``struct``, ``enum``, ``unions`` and ``typedefs``) **must** be documented by
three mandatory types of tags that follow a specific order: the *data type*, *brief*, and
*variables*.

**Data Type**

This tag **must** be used to identify the type of data structure (``@struct`` for structures,
``@enum`` for enumerations, ``@typedef`` for ``typedef``, and ``@union`` for unions) following the
name of that data structure.

**Brief**

The tag ``@brief`` **must**  be used to inform the developer about the role and the impact of the
data structure on the code. This field should be a one-line description of the purpose of the data
structure. However the developer can, when necessary, feel free to give a more detailed, multi-line
description, but keep it short. Use concise and clear descriptions like *This type represents...*,
*This structure represents...*, *This structure provides ...*, or *This enumeration represents...*.

**Struct Variables**

Members in a structure **must** be documented with a comment within their declaration that starts
with ``/**<`` and closes with ``*/``. This is used to describe the context/role of each variable
within the data structure. Note that the variable description **must** start with a capital letter
(see examples). For the description of each type members you can use concise and clear descriptions
such as *This member represents...*, *The X lock protects...*, *Used to...*, *Contains...*, *Stores
...*.

Template/Examples
#################

Bellow we showcase a *template* of the available tags to describe a structure.

.. code-block:: c

  /**
   * @struct <struct_name>
   * @brief <Description>
   */
  struct <struct_name> {
    <type> <variable_name>; /**< <Description> */
  };

Examples:

.. code-block:: c

  /**
   * @struct memory_protection
   * @brief This structure represents a memory region
   */
  struct memory_protection {
    bool assigned;         /**< Memory region assign flag */ vaddr_t base_addr;     /**< Region
    base address */ size_t size;           /**< This member contains the region size */ cpumap_t
    shared_cpus;  /**< Bitmap used when sharing region w/other cores */ mem_flags_t mem_flags; /**<
    Region memory attributes */
  };

.. code-block:: c

  /**
   * @enum wakeup_reason
   * @brief PSCI wakeup reason for CPUs.
   */
  enum wakeup_reason {
    PSCI_WAKEUP_CPU_OFF,    /**< Wakeup reason CPU off */ PSCI_WAKEUP_POWERDOWN,  /**< Wakeup
    reason CPU powerdown */ PSCI_WAKEUP_IDLE,       /**< Wakeup reason CPU idle */ PSCI_WAKEUP_NUM
    /**< Wakeup reason number of variants */
  };

.. _files:

Files
*****

All files must have a doxygen comment after the mandatory license header (see :ref:`generic`),
detailing the purpose and use for the file. The two mandatory tags on the doxygen-style comments
are *file* and *brief*.

**File**

The ``@file`` tag **must** be used to identify the filename and its type (e.g., ``.h``, ``.c``).

**Brief**

The ``@brief`` tag **must** be used to describe the general purpose of the functions in the file
or/and to explain why a specific set of functions or data structures are grouped together in the
file. Use concise and clear descriptions such as *This header file provides...*, *This header file
provides the API of...*, or *This file provides interfaces and functions used to implement...*.

Template/Examples
#################

Template:

.. code-block:: c

  /**
   * @file <filename.type>
   * @brief <Text>
   */

Example:

.. code-block:: c

  /**
   * @file vm.h
   * @brief This header file provides VM structures and functions
   */


.. _macros:

Macros
******

Macros **must** be documented by two mandatory tags that follow a specific order: *definition* and
*brief*.

**Definition**

The ``@def`` tag **must** be used to explicitly describe the macro name and parameters.

**Brief**

The ``@brief`` tag **must** be used to describe the macro purpose.

Template/Examples
#################

Template:

.. code-block:: c

  /** * @def MACRO(arg1, arg2) * @brief description of the macro. */ #define MACRO(arg1, arg2)
  ((arg1) + (arg2))

Example:

.. code-block:: c

  /** * @def BIT(x) * @brief Returns a bit mask with the bit at position x set. */ #define BIT(x)
  (1UL << (x))

.. _variables:

Variables
*********

For variables you **must** start the comment with ``/**<`` and end it normally with ``*/``.
Describe concisely and clearly the objective of the variable. For a boolean type use a phrase like:
*The variable X is true, if some condition is satisfied, otherwise it is false.*. This should be
used on global variables or on any other variables (when appropriate).

Template/Examples
#################

Template:

.. code-block:: c

  int var; /**< Detailed description after the variable */

Example:

.. code-block:: c

  uint64_t start_addr; /**< Start address of the memory region */
