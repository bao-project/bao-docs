:orphan:

.. _c_guidelines_decisions:

C Rules: Draft Versus Practice
==============================

This page lists every rule of the :doc:`C language draft <c_lanaguage_style>`
that disagrees with what the ``bao-hypervisor`` tree does, or with what
reviewers ask for in pull requests, plus the draft's open marks (``?``,
``???`` and ``TODO``) that current practice can already fill. Design rules
(allocation, layering, guest-visible behavior, locking policy) are out of
scope; only the C code rules are covered.

Each row is one decision for the maintainers. The decisions are tracked in the
pull request that adds this page and are folded into the draft once taken,
after which this page is removed.

The "practice" column was measured on a ``bao-hypervisor`` checkout of
2026-10-23 (``main`` at ``612b1623`` plus the pending ``rh850`` fixes).
Counts come from ``grep`` and are approximate. Review quotes cite the pull
request they were made in.

Language and compiler
---------------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C1
     - "The C99 version shall be used."
     - The tree builds with ``-std=c11`` and uses ``_Static_assert`` in nine
       places (``core/cpu.c``, ``core/inc/config.h``, ``armv8/vgicv3.c``,
       ``tricore/ir.c``, ``rh850`` headers).
     - Update the draft to C11.
   * - C2
     - "No language extensions shall be allowed."
     - The build adds ``-pedantic -Wall -Wextra -Werror``, so the compiler
       flags any extension it knows about. ``__asm__`` and
       ``__attribute__`` are used throughout, which strictly are extensions.
     - Name the allowed set (inline assembly, attributes) and make
       ``-pedantic`` the checker for everything else.
   * - C3
     - "Compiler Options and Configuration: TODO"
     - ``bao-docs`` pull request #63 ("Add C compiler base options
       guidelines") has been open since 2023. The tree uses
       ``-ffreestanding -std=c11 -fno-pic -fno-pie -Wall -Wextra -Werror``
       and links with ``-nostdlib --fatal-warnings``.
     - Rebase #63 on this draft and merge it as the section, or close it
       and write the section from the current flags.
   * - C4
     - "Libraries and Headers: TODO"
     - Freestanding build, no C library. ``src/lib`` provides ``printk``,
       ``string``, ``bitmap``, ``bit``, ``list``, ``circular_queue`` and
       ``util``. Only the freestanding headers (``stdint.h``, ``stddef.h``,
       ``stdbool.h``) are included from the compiler.
     - Write the section as "no C library; use ``src/lib``; add a helper there
       instead of open-coding it".

Pre-processor and macros
------------------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C5
     - "``#include`` should preferentially follow the following order"
       (same module, library, core, arch, platform).
     - The module's own header comes first; the rest is unordered.
       ``clang-format`` is configured with ``IncludeBlocks: Preserve``, so
       no tool enforces an order.
     - Keep as "should" and accept that only reviewers check it, or drop the
       order and keep only "own header first".
   * - C6
     - "Conditional compilation using pre-processor directives should be
       used only as last resort."
     - Agreed in principle (#52, #293: replace rather than keep a second
       implementation behind a macro; #116: a few macros preferred over
       duplicated ``rv32``/``rv64`` directories). Feature flags use the
       ``DEFINED()`` idiom. The tolerance threshold for ``#ifdef`` has never
       been written down.
     - Add the order of preference the draft already states, name
       ``DEFINED()`` as the feature-flag form, and say when a whole-file
       build-system selection is required instead.
   * - C7
     - "Function-like macros shall be avoided as much as possible in favor
       of global ``const`` variables or enum variants."
     - Constants are object-like macros almost everywhere. ``clang-tidy``
       ``readability-magic-numbers`` accepts both. Six ``const`` globals in
       the tree are uppercase, seven are lowercase (see C27).
     - Keep macros as the default for hardware constants; use ``enum`` types for
       variant sets closed with a ``_NUM`` terminator; drop the preference
       for ``const`` globals.
   * - C8
     - No rule on when to introduce a function-like macro.
     - #242 settled, case by case, that a function-like macro is wanted
       when it names a concept reused across files (``VMID_TO_HWVM()``)
       and not wanted for ordinary register field parsing ("would
       obfuscate this"). Object-like macros that name a constant (mask,
       offset, length, limit) are always welcome, even when used once,
       since the alternative is a magic number. One constant has one
       name.
     - Add the rule as a "should" with those two examples, stating that
       it applies to function-like macros only.
   * - C9
     - No rule on boolean arguments.
     - Shared APIs take named macro pairs (``MEM_BROADCAST`` /
       ``MEM_DONT_BROADCAST``, ``MEM_ALIGN_REQ`` / ``MEM_ALIGN_NOT_REQ``);
       #223 only argued about the length of the names.
     - Add the rule for ``bool`` parameters of widely called functions.

Types and conversions
---------------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C10
     - "Struct types shall not be aliased using ``typedef``."
     - 14 ``typedef struct``; 13 of them are the ``bao_uart_t`` alias that
       every UART driver provides as the console interface
       (``typedef struct lpuart bao_uart_t;``). ``core/console.c`` uses the
       alias.
     - Keep the rule and list ``bao_uart_t`` as the one accepted exception,
       or replace the alias in a dedicated ``ref:`` pull request.
   * - C11
     - "Function pointer ``typedef`` shall be suffixed with ``_fn``."
     - All seven function-pointer typedefs end in ``_t``
       (``irq_handler_t``, ``emul_handler_t``, ``cpu_msg_handler_t``,
       ``sync_handler_t``, ``abort_handler_t``, ``node_cmp_t``) except
       ``hypercall_handler``, which has no suffix.
     - Drop the ``_fn`` rule; every ``typedef`` ends in ``_t``. Rename
       ``hypercall_handler``.
   * - C12
     - "Casts shall be performed on operands rather than expressions."
     - Reviewers ask for the cast on the result, to the destination width:
       ``(uint8_t)(1U << cpu()->id)``. The ``-Wconversion`` fixes in #315
       landed in that form.
     - Allow casting the result of an expression to the destination type.
   * - C13
     - "All type conversions should be explicit."
     - #171 and #315 disagree on when a cast is needed: "if the most recent
       compiler does not issue any error you should not include those
       casts... the MISRA analyzer will spot them" (#171), yet the
       ``-Wconversion`` casts of #315 were merged.
     - Decide one of: casts only where the reference compiler or the MISRA
       checker asks for them (no casts ahead of time), or explicit casts
       on every narrowing conversion.

Headers
-------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C14
     - "Every header file shall have header guards of the form
       ``HEADERNAME_H``" with ``ARCH_`` or ``PLAT_`` prefixes.
     - 178 headers use ``__NAME_H__``, 44 use ``NAME_H``, three use other
       spellings (``__UART_ZYNQ_H``, ``__STRING_H_``). ``clang-tidy``
       ``bugprone-reserved-identifier`` flags the leading underscores.
     - Keep the rule; convert the old guards in one ``style:`` pull request
       so new files have a single pattern to copy.
   * - C15
     - "All function definitions in header files shall have ``static`` and
       ``inline`` specifiers" and "All functions with the ``inline``
       specifier shall also have the ``static`` specifier."
     - Five non-static ``inline`` definitions remain, all
       ``interrupts_arch_*`` in the ``interrupts.c`` of ``armv8``,
       ``riscv``, ``tricore`` and ``rh850``.
     - Keep both rules; fix the five definitions.

Variables
---------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C16
     - "Initializing global variables should be avoided, especially with
       zero values."
     - Reviewers require ``spinlock_t lock = SPINLOCK_INITVAL;`` and flag
       any lock without it. ``static bool console_ready = false;``,
       ``static bool ipir_ready = false;`` and ``static uint32_t
       timer_freq = 0;`` are in the tree.
     - Exempt locks and synchronization state; otherwise rely on ``.bss``.
       Or drop the rule, since the compiler places zero initializers in
       ``.bss`` anyway.
   * - C17
     - "Variable initializations at declarations shall be simple... Complex
       initializations such function calls shall not be allowed."
     - About 300 local declarations are initialized with a function call
       (``emul_handler_t handler = vm_emul_get_mem(vm, addr);``). Reviewers
       only object to calls with side effects in an initializer.
     - Restrict the rule to calls with side effects; allow calls that only
       read state.
   * - C18
     - "struct initializations should initialize all its members members.
       ?"
     - Platform descriptions and VM configurations use designated
       initializers and leave most members out, relying on them being zero
       (``zcu102_desc.c`` sets ``.base`` and ``.size`` only).
     - Resolve the ``?`` as: members shall be named; omitted members are
       zero by design and need no explicit initializer.

Functions
---------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C19
     - "Every function should have a single return statement. ?"
     - Asked for in review (#176 ``remio.c``, #246 ``vm.c`` "unless it
       becomes too unreadable", #297 ``mpu.c``), but early returns are also
       accepted (#238 ``mem.c``) and requested to avoid deep nesting (#176
       ``vm.c``: "invert the condition and return/error to avoid highly
       indented code").
     - Resolve the ``?`` as: single return in simple functions; early
       returns accepted to avoid nesting; a resource (lock, pool object) is
       released in exactly one place.
   * - C20
     - "By value function parameters shall not be of a compound type" and
       "A function's return type shall not be compound."
     - The RISC-V SBI layer returns ``struct sbiret`` (two words) from
       every call; ``plic_plat_id_to_cntxt`` returns a small struct.
       Reviewers asked for an output argument when a struct exceeds the
       return registers.
     - Allow structs that fit in the ABI return registers; require output
       arguments above that.
   * - C21
     - "Function parameters shall be no more than ???", "maximum
       cyclomatic complexity of ???", "maximum static program path count
       should be of ???", "maximum allowed indentation level should be
       ???".
     - No numbers are in use. Reviewers ask to split at roughly one screen
       of code or three levels of nesting, and emulation handlers are split
       into a ``switch`` dispatcher plus one function per register.
     - Replace the numbers with those heuristics, or pick numbers only if
       ``cppcheck`` or ``clang-tidy`` will enforce them.
   * - C22
     - "A function parameter must be used or explicitly discarded by
       casting it to void."
     - The tree uses ``UNUSED_ARG(x)`` from ``util.h`` (141 uses); three
       bare ``(void)x;`` remain.
     - Name the macro in the rule and require it over the bare cast.

Statements and expressions
--------------------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C23
     - "``goto`` statements shall not be used. ?"
     - No ``goto`` statement in the tree. ``clang-tidy`` runs
       ``cppcoreguidelines-avoid-goto``. #338: "our coding style does not
       allow for ``goto`` labels".
     - Resolve the ``?`` as "shall not".
   * - C24
     - "The expression in conditional or loop statements shall not have
       side-effects."
     - ``while (cpu_get_msg(&msg))`` and ``while (circular_queue_pop(...))``
       are the established consumer-loop idiom.
     - Allow a single consumer call as the loop condition; keep the rule
       for everything else.
   * - C25
     - "Non-empty Infinite loops shall not be allowed."
     - ``core/init.c`` has the empty ``while (1) { }`` the rule allows;
       ``core/mpu/mem.c`` (``mem_vmpu_coalesce_contiguous``) has a non-empty
       ``while (true)`` that exits with ``break``.
     - Keep the rule and rewrite that loop, or allow a loop whose only exit
       is a ``break`` on a computed condition.
   * - C26
     - "A NULL or zero value for pointers or others type representing an
       address, respectively, shall always be considered invalid."
     - Five platform descriptions have a memory region at base ``0x0``
       (``rh850-u2a16``, ``zcu102``, ``ultra96``, ``hikey960``, ``fvp-r``).
       Invalid addresses and IDs use the ``INVALID_*`` sentinels, which are
       ``~0UL``.
     - Restrict the rule to pointers; addresses and IDs use the
       ``INVALID_*`` sentinels.
   * - C27
     - "Magic numbers shall be hidden behind macros unless its meaning is
       straightforward."
     - ``clang-tidy`` ``readability-magic-numbers`` is the checker, with
       powers of two ignored. #418 left open whether a literal (``8``) or a
       macro expression (``(1UL << EIPSWH_GPID_LEN)``) belongs in a
       ``_Static_assert`` message.
     - Write the rule as the checker's configuration (``0``, ``1``, powers
       of two and ``sizeof`` arithmetic accepted) and decide the assert
       message case.

Identifiers and naming
----------------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C28
     - "Global ``const`` variables shall be upper and snake case" and
       "``const`` qualified variables which might be upper case".
     - Reviewers reject uppercase identifiers that are not macros ("upper
       case labels should be reserved for pre-processor macros"). The tree
       has six uppercase ``const`` globals (``SPINLOCK_INITVAL`` in four
       architectures, ``NUM_EXT``, ``ONE``) and seven lowercase ones.
     - Uppercase is reserved for macros and enum variants; ``const``
       globals are lower snake case. Rename the six.
   * - C29
     - "Exported subsystem APIs shall by prefixed with the subsystem's
       prefix. ?"
     - Every exported identifier carries its module prefix (``pp_alloc``,
       ``vgic_int_set_route``, ``remio_*``, ``emul_arch_*``). The draft's
       definitions of "subsystem" and "module" are still ``TODO``, so the
       two rules cannot be told apart.
     - Define "module" as a source file pair and its header, drop
       "subsystem", resolve the ``?`` as the module-prefix rule.
   * - C30
     - "``FIXME`` tag to indicate a bug clearly associated with a specific
       piece of code" (commented out in ``index.rst``).
     - Two ``FIXME`` and 58 ``TODO`` in the tree; ``TODO`` is used for both
       meanings. Reviewers require a ``TODO`` left at merge time to be
       agreed in the thread.
     - Either adopt ``FIXME`` for known bugs and point both tags at an
       issue, or drop ``FIXME`` and keep ``TODO`` only.

Inline assembly
---------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C31
     - "Every ``asm`` statement shall be in source files within the
       arch-specific directory."
     - Two uses outside ``arch``: ``core/inc/config.h`` embeds VM images
       with ``__asm__(".pushsection ...")`` and ``lib/inc/util.h`` emits
       the ``DEFINE_OFFSET`` / ``DEFINE_SIZE`` markers that generate
       ``asm_defs``. Both are build mechanisms, not instructions.
     - Exempt assembler directives used to emit data or build-time
       constants; keep the rule for instructions.
   * - C32
     - "Every ``asm`` statement shall be wrapped in a C function with the
       simplest possible semantics."
     - System register access goes through generated accessors
       (``SYSREG_GEN_ACCESSORS``, ``CSRS_GEN_ACCESSORS``,
       ``SRS_GEN_ACCESSORS``), which expand to such wrappers.
     - Keep the rule and name the generator macros as the required form
       for register accessors.

Comments and documentation
--------------------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C33
     - "Single line comments shall be of the form ``/* ... */`` not
       ``// ...``"
     - About 460 ``//`` comment lines in 29 files, mostly arch headers and
       a few platform files. No tool checks it.
     - Keep the rule; clean up in a ``style:`` pull request; consider a
       ``clang-tidy`` or script check.
   * - C34
     - "Multiple line comments shall be of the form ``/**\n *.....\n*/``"
     - Matches: about 650 multi-line ``/**`` blocks versus 20 ``/*``
       blocks. However 138 single-line ``/** ... */`` comments exist, which
       Doxygen treats as documentation, and review has rejected new ones.
     - Add: ``/**`` only opens a multi-line comment; a single-line comment
       is ``/* */`` even when it documents an item.
   * - C35
     - "Doxygen comments shall be used for documenting all files, types,
       global variables, exported functions, and possibly others according
       to ??."
     - The ``code_documentation`` page already states the Doxygen rules
       (``@brief``, one ``@param`` per parameter, ``@return``, ``@file``
       after the license header). Reviewers also reject Doxygen tags on a
       group of functions rather than one item.
     - Replace ``??`` with a reference to that page and add the "one item
       per tag" rule.

Assertions and error handling
-----------------------------

.. list-table::
   :header-rows: 1
   :widths: 4 28 36 32

   * - Id
     - Draft rule
     - Practice
     - Proposal
   * - C36
     - "Assertion, Error Handling and Sanity checking: TODO"
     - The tree has ``ERROR``, ``WARNING`` and ``INFO`` macros, nine
       ``_Static_assert`` sites and no run-time assert. The debug-build
       ``panic()`` and ``ASSERT()`` series (``bao-hypervisor`` #434 to
       #437) is open. Two review threads were deferred to "its own PR":
       whether messages carry ``__func__`` (#242, #147) and how far
       ``_Static_assert`` should reach (#418: "asserts don't really add
       anything once the implementation is done and validated").
     - Write the section once #434 to #437 are decided, and settle the
       two deferred questions in that pull request rather than in review.

Rules verified to match
-----------------------

These draft rules already describe the tree and need no decision, only
the removal of their ``?`` where present:

- ``long`` / ``unsigned long`` as the machine word, with the project
  typedefs in ``core/inc/types.h`` for IDs and addresses.
- Fixed-width types for hardware register fields; register-layout structs
  end in ``_hw``.
- Uppercase literal suffixes, enforced by ``clang-tidy``
  ``readability-uppercase-literal-suffix`` (about ten lowercase stragglers
  remain).
- No recursion (``misc-no-recursion``), braces on every body
  (``readability-braces-around-statements``), macro parentheses
  (``bugprone-macro-parentheses``), ``do { } while (0)`` for
  multi-statement macros (``bugprone-multiple-statement-macro``).
- Angle-bracket includes only: no ``#include "..."`` in the tree.
- Formatting owned by ``.clang-format`` at 100 columns; ``clang-format
  off`` only with a justifying comment.
