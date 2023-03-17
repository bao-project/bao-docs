.. _coding_guidelines:

Coding Guidelines and Style
===========================

C Language Guidelines
---------------------

The coding style and guidelines for C development are heavily influenced and
constrained by the MISRA C:2012 guidelines, which should take precedence above
all others in this document or elsewhere. The rules described within this file
are subject to the following definitions:

Subsystem
  TODO
Module
  TODO
Private
  TODO
Exported
  TODO
Constant
  TODO
Compound types
  TODO
Function Definition vs declaration
  TODO
Source files vs header files
  TODO
Identifier
  TODO
Side-effect
  TODO

The C11 version shall be used.

No language extensions shall be allowed.

Directory and file Structure
****************************

- Header files shall be placed in sub-folders of the include directories which
  identify the current module (except for the core module).
- File names shall be lower-case snake case and use only ASCII alphabet and
  numeric characters.
- Header files shall have the ``.h`` extension.
- Source files shall have the ``.c`` extension.

Pre-processor directives and macros
***********************************
- All ``#include`` statement shall be at the top of the file.
- ``#include`` should preferentially follow the following order, each group
  separated by a empty line:

    1. Same module headers
    2. Library/Utility headers
    3. Core module's header
    4. Arch-specific headers
    5. Platform-specific headers
- Include statements shall only use the ``#include <...h>`` variant (as opposed
  to ``#include "...h"``).
- An header file shall not be included multiple times in the same source file.
- Conditional compilation using pre-processor directives should be used only as
  last resort. One should favor the use of:

    - direct conditional statements to be optimized by the compiler;
    - linking mechanisms (e.g. weak symbols);
    - or selection of different sources through the build system.
- Function-like macros shall be avoided as much as possible in favor of
  ``static`` ``inline`` functions.
- The macro definition shall be enclosed in parentheses unless it is a single
  value.
- All identifiers used within a function-like macro shall must be passed as
  parameters with the exception of other macros.
- Function-like macros shall be avoided as much as possible in favor of global
  const variables or enum variants.
- Parentheses shall be used to enclose every macro parameter.
- A macro shall not redefine a keyword or a global item.
- Multi-statement macros shall be enclosed in a ``do { ... } while (0);``
  statement.
- Include statements shall be at the top of files and only preceded by other
  includes or comments.
- Include statements shall only encode header files.
- Include statements shall be of the for ``#include <tag/file.h>``
- Function-like macros shall not have hidden side-effects on its arguments.


Types and Type Conversion (casting)
***********************************
- A typedef shall only be used alias arithmetic, enum of function types.
- Struct types shall not be aliased using ``typedef``.
- Pointer types shall not be aliased using ``typedef``.
- All type conversions should be explicit.
- Casts shall not be performed on a function pointer.
- The ``const`` type qualifier shall not be discarded in any kind of type
  conversion.
- A pointer shall only be cast to and from ``uintptr_t`` or from ``void*``.
- Casts shall be performed on operands rather than expressions.
- ``long`` or ``unsigned long`` shall be used a the machine-word width type.
- Fixed-width integer types defined in ``stdint.h`` (e.g. ``uint8_t``,
  ``int64_t``) shall be used only when when the need to express the exact width
  of a type arises (e.g. when defined MMIO region layout in struct types).
- The ``uint8_t`` type shall be use to represent bytes.
- The ``size_t`` type or its aliases should be used for sizes, ranges, offsets
  or indexes.
- The ``uintptr_t`` type or its aliases should be used for pointer or address
  arithmetic.
- Struct fields should be declared from the largest to the smallest size to
  avoid unnecessary padding due to alignment.
- Struct bit field shall be grouped with clear indication (e.g. using comments)
  of the association.
- Each grouped struct bit field shall be of the same type.
- Struct bit field padding shall be explicit to occupy the maximum available
  bits in the group's type.
- Floating-point types should not be used.
- Casts shall not discard any type qualifiers of the original value.

Header Files
************

- A header file shall be self-sufficient. That is, the correctness of its
  inclusion inn another header or source  must not depend on other ``#include``
  statements or their relative order.
- Every header file shall have header guards of the form ``HEADERNAME_H``. If
  the header is part of arch or platform specific directories add the prefix
  ``ARCH_`` or ``PLAT_``.
- All function definitions in header files shall have ``static`` and ``inline``
  specifiers.
- Declarations, definitions or pre-processor directives on an header should
  preferentially be done in the following order: 1. Include directives 2.
  Macros definitions 3. Constants 4. Type definitions 5. Exported global
  variables 6. Function declarations and definitions
- Include directives should be ordered in the following manner:
    1. Module header;
    2. Arch-specific includes
    3. TODO


Variable Declarations, Qualifiers and Initializations
*****************************************************
- A declaration shall declare a single variable.
- struct initializations shall explicitly name the initialized members.
- struct initializations should initialize all its members members. ?
- Array sizes shall be specified explicitly.
- An array shall not be partially initialized.
- Local arrays of variable size are shall not be allowed inside a function.
- Items private to a given module shall be declared with the ``static``
  specifier.
- A local variable shall not overshadow a global variable or function
  parameter.
- A variable shall be declared ``volatile`` type qualifier only if it
  represents an hardware MMIO region or is used for thread
  communication/synchronization.
- Global variables shall be declared/initialized at the top of a source file.
- If exported, a global variable shall be declared with the ``extern``
  specifier in the module's header file.
- Global variables and functions, which are private to a module, shall be
  declared with the ``static`` specifier.
- Local variable declaration shall be at the top of lowest scope where it is
  used. Read-only variables created for the sole purpose of helping readability
  can be excepted.
- Initializing global variables should be avoided, especially with zero values.
- There shall be no unused declarations.
- Variable initializations at declarations shall be simple and resigned to the
  attribution of default values. Complex initializations such function calls
  shall not be allowed.
- The ``const`` type qualifier shall be used for read-only global-variables.
- The ``const`` type qualifier should be used for local variables not supposed
  to be modified after initialization.
- Variable length arrays shall not be used.

Functions
*********
- Every function should have a single return statement. ?
- All code within a function shall be reachable.
- All reachable code shall have some effect.
- Every possible code path leading to the use of a variable it shall be
  initialized.
- All functions with the ``inline``  specifier shall also have the ``static``
  specifier.
- There shall be no standalone declaration of ``inline`` functions (i.e. an
  inlined function declaration shall be also the definition).
- The ``const`` qualifier shall be used on all function pointer parameters
  which are not output parameters.
- Module private functions shall be specified as ``static``.
- A non-static function shall be declared in a header file.
- Every declaration and definition parameters shall be named.
- Every declaration and definition of the same function shall have identical
  types and names across all return values and parameters.
- There shall be no function declaration without a definition.
- A function shall not be recursive, neither directly or indirectly.
- A parameter passed by value to a function shall not be modified directly.
- A function parameter must be used or explicitly discarded by casting it to
  void. The latter shall only be allowed for functions that must match a given
  signature such as in previously defined module or system interface function.
- The return value of a function shall be either used or explicitly discarded
  by casting it to void.
- By value function parameters shall not be of a compound type.
- Function parameters shall be no more than ???
- A function's return type shall not be compound.
- All function parameters shall be used or explicitly discarded by casting to
  void.
- There shall be no unreachable or dead code.
- A function should have a maximum cyclomatic complexity of ???.
- A function's maximum static program path count should be of ???.

Statements
**********
- Multiple assignments in a single line shall not be allowed.
- Chained assignments shall not be allowed.
- The comma operator shall not be allowed.
- The body of every loop or conditional statement shall be enclosed in
  brackets, even if empty.
- ``for`` loops shall not omit the init clause, conditional expression or
  iteration expression.
- A ``switch`` statement shall have the default case.
- Every switch clause shall be terminated with a ``break`` statement or
  explicitly annotate the fallthrough intention.
- ``goto`` statements shall not be used. ?
- The expressions used in if, while, for statements shall be boolean
  expressions, i.e., the result of a logical or comparison operator.
- The result of the conditional expression of a ``for`` statement shall only be
  affected by its iteration expression, not from operations on its body.
- The boolean expression in conditional or loop statements shall be simple. If
  needed auxiliary boolean variables shall be defined before the loop clearly
  describing the meaning of the condition.
- The expression in conditional or loop statements shall not have side-effects
  (e.g. assignments, increments, calling functions with side-effects).
- Non-empty Infinite loops shall not be allowed.
- An assignment statement shall not be used in an expression.

Expressions
***********
- Parentheses should be used to clarify the operator precedence explicitly
  where it it might be ambiguous.
- Magic numbers shall be hidden behind macros unless its meaning is
  straightforward, unambiguous and clarified in surrounding comments.
- Pointer arithmetic is only allowed on ``void*`` variables. Otherwise,
  pointers shall be converted to a ``uintpr_t`` and incremented explicitly
  using ``sizeof(type)``.
- A string literal shall be used only as a ``const`` object
- Array indexing shall be performed only on array variables (as opposed to
  pointers).
- enum variants shall not be used as an arithmetic operand.
- A NULL or zero value for pointers or others type representing an address,
  respectively, shall always be considered invalid.
- Increment/decrement operators shall be used only as an isolated expression
  statement.
- Complex expressions should be broke up using temporary variables to hold the
  values of sub-expressions, with a descriptive identifier.
- Sub-expressions behind logical operators (||, &&) shall not have
  side-effects.
- Bitwise and shift operators shall only be used with unsigned operands.
- Boolean values shall not be used in arithmetic expressions.

Literals
********
- Literal suffixes shall be used to indicate unsigned or wider literals.
- Literal suffixes shall be uppercase.

Identifiers and Naming
**********************
- Only ASCII alphabet and numeric characters, and ``_`` shall be allowed in
  identifiers.
- An identifier shall start with either an alphabet character or ``_``.
- Global item identifiers shall be unique.
- All variable, function and type identifiers shall be lower snake case, except
  for ``const`` qualified variables which might be upper case.
- enum variants shall be upper snake case.
- enum variants shall have a prefix identifying the enum type, module or
  generic context.
- Macros identifiers shall always be upper and snake case.
- Global ``const`` variables shall be upper and snake case.
- Every exported global type, global variable or function identifier shall have
  the module's prefix.
- Exported subsystem APIs shall by prefixed with the subsystem's prefix. ?
- All ``typedef`` identifiers shall be suffixed with ``_t``.
- Function pointer ``typedef`` shall be suffixed with ``_fn``.
- Structures representing hardware register layouts shall have the suffix
  ``_hw``.
- Function and variables names should be descriptive and loosely follow the
  form **subject_verb_object** for most functions (plus other suffices and
  prefixes). All three fields may be compounded and enriched in a snake case
  manner. E.g.: **subject** and **objective** may be enriched by adjectives;
  **verb** may be enriched by prepositions.  For functions only **verb** is
  mandatory. For variables only **object** is mandatory.
- An identifier should be as concise as possible, without sacrificing
  descriptiveness.
- All identifiers visible from a given scope shall be clearly discernible.

Inline Assembly
***************
- Inline assembly shall only be used when the same functionality can not be
  expressed directly in C, or it incurs a significant performance loss.
- Every ``asm`` statement shall be wrapped in a C function with the simplest
  possible semantics.
- Every ``asm`` statement shall be in source files within the arch-specific
  directory.

Compiler Directives, Intrinsic and Attributes
**********************************************
TODO

Assertion, Error Handling and Sanity checking
*********************************************
TODO

.. see ATF and composite

Comments, Documentation and License
***********************************
- Doxygen comments shall be used for documenting all files, types, global
  variables, exported functions, and possibly others according to ??.
- Single line comments shall be of the form ``/* ... */`` not ``// ...``
- Multiple line comments shall be of the form ``/**\n *.....\n*/``
- Comments shall not hide code.

Coding Style and Formatting
***************************
The C coding style must abide by the rules defined in the file hierarchy
innermost *.clang-format* file which documents the style in an unambiguous
manner. Use of ``clang-format on/off`` comments to disable formatting shall be
justified in enclosed comments and approved by code reviewers.

Where clang-format rules lack, the following should be applied:

- Every source or header file shall end with a newline.
- The maximum allowed indentation level should be ???. Break up code in helper
  functions when not achievable.
- Empty lines should be used only to logically separate blocks of code, serving
  a similar function to paragraphs.
- To define multi-line strings string literal concatenation shall be used
  instead of breaking the string using ``\``.
- Every array, struct or other compound type initialization shall have a
  trailing comma.

Keyword Usage
*************
TODO

.. - register
.. - restrict

Compiler Options and Configuration
**********************************
TODO

Libraries and Headers
*********************
TODO

References
----------

Besides MISRA C:2012, the previous guidelines have heavily drawn from the
following sources:

  - `SEI CERT-C Coding Standard
    <https://wiki.sei.cmu.edu/confluence/display/c/SEI+CERT+C+Coding+Standard>`_
  - `ACRN Coding Guidelines
    <https://projectacrn.github.io/latest/developer-guides/c_coding_guidelines.html>`_
  - `Linux kernel coding style
    <https://www.kernel.org/doc/html/v4.10/process/coding-style.html>`_
  - `Composite Coding Style
    <https://github.com/gwsystems/composite/blob/ppos/doc/style_guide/composite_coding_style.pdf>`_
  - `TF-A Coding Style & Guidelines
    <https://trustedfirmware-a.readthedocs.io/en/v2.2/process/coding-guidelines.html>`_
  - `RTEMS Coding Standards
    <https://docs.rtems.org/branches/master/eng/coding.html>`_
  - `Perforce High Integrity C++ Coding Standard
    <https://www.perforce.com/resources/qac/high-integrity-cpp-coding-standard#declarations>`_
