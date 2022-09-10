.. _coding_guidelines:

Coding Guidelines and Style
===========================

The project uses essentially three different languages across its multiple
components: C, Rust and Assembly. Make and Python are used throughout the
build system and CI infrastructure. YAML is used for configuration files 
(with the exception of Rust projects which use TOML to interface with cargo).

One should first and foremost look at already existing and surrounding code and
match its style. We strive as much as possible for all the rules, guidelines
and style described in this document to be machine checkable. If no tool is
available to us to achieve this, the burden falls upon code reviewers (see
:ref:`contributing`) to enforce them as much as possible.

Safety (both as in avoiding undefined behavior and functional safety) and
security should be the main goals used when considering coding style. These are
closely followed by readability, maintainability and consistency. To a lesser
extend, portability and performance should also be at the back of one's mind.

English shall be the used language for all code: identifiers, comments or
others.

Copyright and License Notice
----------------------------

Every source file shall start with a multi-line comment which must include:

    1. Copyright notice
    2. License (using an `SPDX-License-Identifier
       <https://spdx.org/licenses/>`_)


Assembly (GNU)
--------------
TODO

.. - use lower case for registers
.. - use .func directives

Makefile
--------
TODO


Rust
----
TODO

Python
------

YAML
----

.. - Xen coding style
.. - Jailhouse coding style
.. - clean code book
.. - code complete book

.. NOTES, IDEAS AND TODO
..   - trim down ambiguous or bug indicating guidelines
..   - mark rules that i have issues with
..   - remove rules:
..       - describing bugs
..       - describing formatting
..   - verify and uniformize use of shall/should/may
..   - update formatting according to daniel guidelines
..   - use of `` around language constructs
..   - fill in ??? and TODO sections
..   - rules about base and size alignment (and associated performance
..     ramifications (eg cache line, false sharing, etc..))
..   - add tag naming scheme
..   - how to deal with conflicting rules
..   - write examples
..   - ASK feedback:
..       - mudanças de secção para certas regras?
..       - definitions missing?

.. Other possible rules:
..  - The operands of an assignment operator shall be the same type
..  - The operands of arithmetic operations shall be the same type
..  - A pointer shall only be cast to types representing addresses.
..  - A pointer shall not be cast from any types representing addresses.
..  - Variables shall not have the same name as types, functions

.. Preferred Idioms
.. ****************
.. TODO

.. - Comments can be tagged with:
..    1. ``TODO`` tag shall be used to point out non-essential features or
..    optimizations that could be implemented in the future and associated with
..    a specific function or module. It should be associated with a ticket for
..    feature request in ??.
..    2. ``FIXME`` tag to indicate a bug clearly associated with a specific
..    piece of code. It should be associated with a ticket for feature request
..    in ??.
