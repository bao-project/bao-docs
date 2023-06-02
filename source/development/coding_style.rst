.. _coding_guidelines:

Coding Guidelines
=================

This document specifies a set of coding guidelines, including code style,
formatting, file structuring and organization that shall be applied when
contributing code to the Bao project. We strive to ensure that most of the
guidelines can be automatically checked or even enforced by the CI pipeline and
minimize guidelines that can not be automatically addressed. In cases where it
is not feasible to automatically enforce certain guidelines, the responsibility
lies with the code reviewers and maintainers to ensure that these guidelines
are adhered to as closely as possible.

C Language
----------

The coding style and guidelines for C development are heavily influenced and
constrained by the MISRA C:2012 guidelines, which should take precedence above
all others in this document or elsewhere.

All C projects should support either the GCC compiler, the Clang compiler or
both. If one compiler is supported for given project, it must be so for all
supported target architectures.

For reach guideline we try to provide a set of compiler options which enforce
the rule, a mapping to a MISRA C:2012 and tools available in the :ref:`CI
infrastructure <ci>` that can check if this guideline is being adhered to.

Compiler Configuration
**********************

- The C11 version shall be used.

Compiler options: `-std=c11`.
MISRA C:2012 : R1.1

- No language extensions shall be allowed.

Compiler options: `-pedantic -pedantic-errors`.
MISRA C:2012 : R1.1

- Treat all warnings as errors so no warnings can be ignored.

Compiler options: `-Werrors`.

- Enable all recommended warnings.

Compiler options: `-Wall -Wextra`.

Directory and file Structure
****************************

Pre-processor directives and macros
***********************************

Header Files
************

Variable Declarations, Qualifiers and Initializations
*****************************************************

Functions
*********

Statements
**********

Expressions
***********

Literals
********

Identifiers and Naming
**********************

Inline Assembly
***************

Compiler Directives, Intrinsic and Attributes
**********************************************

Assertion, Error Handling and Sanity checking
*********************************************

Comments, Documentation and License
***********************************

Coding Style and Formatting
***************************

Keyword Usage
*************

Libraries and Headers
*********************
