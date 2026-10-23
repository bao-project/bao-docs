.. _design_guidelines:

Design Guidelines
=================

This page states the design principles that Bao maintainers enforce in code
review and that per-statement C coding rules leave out:
what the hypervisor is and is not, where a piece of code belongs, how a
feature is designed so that it costs nothing when it is off, what counts as a
critical path, and how allocation, concurrency, guest input and errors are
handled. The rules were distilled from merged and open pull requests, review
threads and the current tree of ``bao-hypervisor``. Where maintainers have
repeatedly asked for the same change in review, that change is a rule here.

Most rules are uncontested. A few have a recorded disagreement between
maintainers; those are stated with one side's position and collected in
:ref:`design_decisions` at the end, which the pull request that adds this page
tracks as a checklist. Pull request numbers refer to ``bao-hypervisor`` unless
marked.

What Bao is
-----------

Bao is a static partitioning hypervisor. Every design rule below follows from
a short list of invariants, and reviewers reject changes that erode them.

Static partitioning
  Resources are assigned to VMs at configuration time. Sizes come from the
  configuration and the platform description. There is no run-time discovery
  of guest resources and no allocation after initialization.

Self-sufficient
  Bao boots right after the firmware and has no privileged guest: no root
  cell, no Linux in the loop. No feature may depend on a management VM.
  Device sharing is done by forwarding to a backend VM over statically
  configured shared memory and interrupts (Remote I/O), never by putting a
  device driver in the hypervisor.

No scheduler, one vCPU per physical CPU
  CPU sharing is being added as an opt-in, per-core module. Per-CPU state
  lives in ``struct cpu`` and is reached through ``cpu()``. Cores configured
  without sharing keep exactly today's isolation and latency guarantees.
  Run-time core reallocation and vCPU hot-plug are non-goals.

Non-preemptible
  The hypervisor runs with interrupts masked and never takes an interrupt
  while executing. There is no "native hypervisor interrupt" path. Boot code
  enforces its own entry requirements (masked interrupts, cache state)
  instead of trusting the firmware.

Freestanding
  No C library and no compiler run-time library. ``src/lib`` is all there is.
  Code shared with 32-bit targets uses no 64-bit division and no ``long
  long`` arithmetic, because the helper would be an unresolved symbol at
  link time. Image size matters: a few hundred bytes saved by a ``sizeof``
  guard is worth a line.

Pass-through I/O, direct interrupt injection
  Devices are mapped, not emulated. The exceptions are the interrupt
  controller, a few architectural registers and explicitly virtualized
  devices (Remote I/O). Trap-and-emulate is a last resort: it is rejected
  when a hypercall or a hardware mechanism does the job ("the cost of
  trap-and-emulate is larger than the direct hypercall") and required when
  the hardware does not enforce isolation on its own, for example a register
  a guest could use to reach another VM's interrupts.

Minimal trusted computing base
  Small code, no external dependencies, no privileged helper VM, no feature
  that needs a large run time inside the hypervisor. "There is no reason to
  allow a mix of the two in our implementation, it will just add complexity
  unnecessarily": when the hypervisor only ever sees one configuration,
  hard-code it and remove the generality.

Real-time first
  Latency and jitter on the interrupt and trap paths beat code elegance. A
  design that adds a trap or a table walk on a hot path needs a strong
  justification. A check that is useful for bring-up is acceptable only
  outside the critical path; on the critical path it must become a
  compile-time decision.

Isolation first, fail closed
  A VM must not be able to affect the hypervisor or another VM even when it
  violates the hardware manual. Unbound resources (IOMMU streams,
  interrupts) abort rather than bypass.

Portable
  Arm-A, Arm-R, RISC-V, RH850 and TriCore; 32 and 64 bit; MMU and MPU.
  Shared interfaces keep one meaning on every architecture. A change in one
  sub-architecture (``aarch32``) is mirrored in its sibling (``aarch64``) in
  the same pull request.

MISRA C:2012 as the target
  ISO C11 with ``-pedantic -Wall -Wextra -Werror``. No compiler extensions,
  no new warnings, no ``-Wno-*`` flags; deviations go through the documented
  :ref:`process <misra>`.

Two consequences maintainers have spelled out in review: the hypervisor does
not inspect other VMs' configurations while setting up a VM, and it does not
manage devices beyond what initialization needs. Keep the logic in the
hypervisor minimal and push knowledge into the configuration.

Layering
--------

.. code-block:: text

   src/
     core/        architecture-independent logic (cpu, vm, mem, interrupts,
                  ipc, remio, ...)
       mmu/ mpu/  the two memory protection back ends; exactly one is built
       inc/       core headers: the public API between modules
     arch/<arch>/ architecture code (armv8, riscv, rh850, tricore)
       inc/arch/  the arch side of each core interface
       <profile>/ <subarch>/ irqc/<variant>/
     platform/<board>/           description (*_desc.c), platform.mk,
                                 inc/plat/*.h, platform.c
     platform/drivers/<device>/  console drivers, named after the device
     lib/         freestanding helpers (bit, bitmap, list, printk, string,
                  util, circular_queue)
   configs/       example VM configurations
   scripts/       build-time generators

Dependency direction
********************

- Core depends on arch, arch depends on platform, never the other way. Core
  headers include ``arch/<x>.h``; arch headers never include core headers.
  If an arch source file needs a core type, include the core header in the
  ``.c`` file, not in the arch header.
- Arch headers never hard-code a board constant. Board values come from
  ``plat/platform.h``, the platform description or generated ``PLAT_*``
  macros.
- ``lib`` depends on nothing but ``bao.h`` and ``types.h``.
- Generated headers are produced by ``scripts/`` and consumed through
  ``platform_defs.h`` and ``config_defs.h``. Anything a generator needs to
  see must live in a header, because the generator is a host program
  compiled with includes only.

Where a piece of code belongs
*****************************

.. list-table::
   :header-rows: 1
   :widths: 55 45

   * - It is
     - It goes in
   * - Policy, bookkeeping or a data structure shared by all architectures
       (standby versus power-down decision, vCPU lookup, interrupt
       reservation, page pools)
     - ``core/``
   * - The implementation of a core hook for one ISA (``cpu_arch_init``,
       ``interrupts_arch_enable``, ``vcpu_arch_inject_irq``)
     - ``arch/<arch>/``
   * - Common to all profiles and sub-architectures of one ISA
     - ``arch/<arch>/*.c``, not duplicated per profile
   * - A driver for an interrupt controller, IOMMU or timer
     - ``arch/<arch>/``, behind a ``static inline`` selection layer when
       several variants exist
   * - A fixed hardware fact about one board (memory regions, interrupt
       controller addresses, console base, CPU count)
     - ``platform/<board>/<board>_desc.c`` and ``inc/plat/platform.h``
   * - Board-specific run-time initialization that is not a hardware fact
       (clock gating, implementation-defined register setup)
     - ``platform/<board>/platform.c``
   * - A UART driver
     - ``platform/drivers/<device>_uart/``, named after the IP block, not
       the SoC or the architecture
   * - Something an integrator may legitimately want to change per
       deployment
     - The configuration (``struct config``), not a ``-D`` flag
   * - Build variant selection (interrupt controller version, sub-arch)
     - ``platform.mk`` chooses, ``arch.mk`` validates with ``$(error ...)``,
       the top-level ``Makefile`` stays agnostic

Core and arch hooks
*******************

- Core declares the hook in its header under a "must be implemented by
  architecture" block, named ``<module>_arch_<op>``. The arch side of a core
  struct is a nested ``struct <type>_arch``; an arch that needs no state
  uses ``EMPTY_STRUCT_FIELDS``, not a dummy field.
- Decisions belong in core; arch implements mechanism. ``vcpu_arch_run`` does
  not re-implement ``vcpu_run`` logic, and arch does not decide whether to
  standby or power down.
- A hook an arch does not need is implemented empty, never as a stub that
  prints "not implemented" and halts.
- Weak symbols only provide a default that most architectures share and a
  few override, with the reason in a comment next to the weak definition.
  Name a hook by the question it answers, not by the mechanism.
- Keep the arch interface small. Before adding a hook, check whether an
  existing one can carry the information.
- Do not split an arch into profiles or sub-architectures unless the
  difference justifies it. A handful of width macros and a register wrapper
  beat two directory trees.
- Policy that varies per VM (direct injection, pointer masking mode) is a
  field in the VM struct filled from the configuration, not a global macro.
  Per-platform capabilities follow the ``GIC_VERSION`` pattern:
  ``platform.mk`` defines the macro, ``arch.mk`` validates it, and the
  default preserves the behavior of every existing platform.
- When a new description field is needed by a few boards only, make it
  optional and fall back to the current algorithm; do not force every
  description to fill it in.

Several implementations of one role
***********************************

When an arch has interchangeable implementations of one role (PLIC versus
AIA, GICv2 versus GICv3):

- each driver keeps its own name and prefix;
- a thin header provides the generic API as ``static inline`` wrappers
  (``irqc_init()``, ``virqc_inject()``), selected by the build;
- generic logic is written once against the generic API, never copied into
  each driver directory;
- the selection macro is defined in ``platform.mk``, exported by ``arch.mk``
  and tested only at file scope, with the closing ``#endif`` labeled.

Platform descriptions are data
******************************

- ``struct platform`` holds fixed hardware facts only: CPU count, every
  physical memory region (including ones Bao may not use, so it can track
  them), MMIO regions when slave-side protection is used, console base,
  interrupt controller and timer addresses, and the cluster layout only when
  CPU identifiers are not linear.
- No ``#ifdef`` inside a description. Hypervisor placement is a
  configuration decision, not a description decision.
- Driver tables and register initialization sequences belong in
  ``platform.c`` or the driver, not in the description.
- Large register-layout structs pad unused ranges with byte arrays rather
  than listing hundreds of unused fields.
- Enumeration defaults that descriptions rely on are the zero value and say
  so in a comment.

Designing a feature
-------------------

Zero cost when off
******************

- A feature that is not enabled adds no code, data or instructions to any
  path. Reviewers compare generated code and count instructions on entry
  paths ("this went from 4 to 7 instructions on the guest entry path").
- Fields used by one memory protection back end or one arch do not appear
  in the other's structs.
- New machinery for a class of targets (per-CPU blocks in local memory for
  microcontrollers) goes behind a build flag, is allowed only where it makes
  sense, and keeps the current layout as the default.
- A feature needs an in-tree user, a platform or configuration that enables
  it, otherwise CI never compiles it and it rots. A helper with no caller
  ships with the pull request that uses it.
- Replace, do not fork. A better implementation of an existing mechanism
  replaces the old one; it is not kept beside it as a compile-time option
  (see :ref:`design_decisions`, D7).
- Rarely exercised optional features (hypervisor cache coloring, Remote
  I/O) get a test so a later memory layout change cannot silently break
  them.

Build-time selection
********************

- Test the feature you need, positively: ``#ifdef MEM_PROT_MPU``, not
  ``#ifndef MEM_PROT_MMU``. Put the positive case first.
- Inside a function, use ``if (DEFINED(MACRO))`` around a call to a private
  function. The compiler removes the dead branch and both branches stay
  compiled and type checked. Avoid ``#ifdef`` inside a function body.
- ``#if`` at file scope is acceptable for selecting whole functions or
  struct variants when it clearly improves clarity; always label the
  ``#endif``.
- Presence of optional hardware becomes a generated compile-time macro
  consumed through ``DEFINED()``, not a run-time test of a base address on a
  hot path.
- Never relax the compiler: no new ``-Wno-*``, no suppressed build error, no
  disabled check to make a pull request pass.

No speculative generality
*************************

- Implement what the current platforms need. Fields, helpers, pools or modes
  kept for a future feature are removed; a ``TODO`` says when the extension
  will be needed.
- Do not add a second mechanism next to an existing one: a second per-CPU
  access path, a second MMIO access API, a second error logging style. If
  the existing one is inadequate, change it in its own pull request.
- Do not add an API with one caller unless it is the abstraction point for
  future implementations of the same role.

Configuration, description or compile time
******************************************

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Question
     - Answer
   * - Can an integrator legitimately want a different value per deployment?
     - A configuration field, global or per VM.
   * - Is it a fixed property of the board?
     - The platform description or ``plat/platform.h``.
   * - Is it a property of the ISA or a hard architectural limit?
     - ``arch/<arch>/inc/arch/platform.h`` or ``arch/bao.h``, with a
       ``_Static_assert``.
   * - Is it an object count derivable from the configuration?
     - A generated ``CONFIG_*`` macro, used to size static arrays or object
       pools.
   * - Can it be derived from something already known?
     - Derive it; do not make it a knob ("this mode is implicit, not a
       configuration").

- Prefer a description field over a ``-D`` macro for per-platform values.
- Prefer explicit over implicit: placement is stated in the configuration,
  not inferred as a side effect of ``cpu_affinity`` (see
  :ref:`design_decisions`, D2).
- Correctness of the configuration is the integrator's responsibility; Bao
  isolates exactly what the configuration assigns. Validating the
  configuration against the platform at boot is welcome; silently accepting
  an impossible configuration is not.

Open a discussion first
***********************

Architecture ports, new subsystems and anything that touches the core
interfaces start as a GitHub issue or discussion describing the design and
its trade-offs. Maintainers prefer to argue "against actual code rather than
a design on paper", so a small prototype pull request attached to the
discussion helps. A pull request that implements a design nobody agreed to
is likely to be restructured heavily or closed, and a solution judged unclean
is closed and turned into an issue rather than patched up.

The critical path
-----------------

Every instruction and memory access added to the following paths needs a
reason:

- exception and trap entry and exit;
- physical interrupt handling and virtual interrupt routing and injection;
- inter-processor interrupt send and receive and CPU message handling;
- emulation handler dispatch;
- ``cpu()`` and ``cpu()->vcpu`` access;
- spinlock acquire and release.

Rules:

- Per-CPU state is ``cpu()->field``: one register plus an immediate offset on
  MPU targets, a constant address on MMU targets. No indirection through
  tables, identifiers or function calls.
- Cache values at setup time instead of looking them up on the path.
- Do not poll MMIO on every interrupt for a rare condition; use an interrupt
  or a flag set elsewhere. Claim an interrupt once per trap.
- Update the target CPU only; do not broadcast to every CPU to simplify a
  write.
- Inside arch files, do not pay for an abstraction call that exists only for
  core. Small hot helpers go ``static inline`` in the arch header.
- Prefer bitmaps and compact types over arrays of flags, and check what the
  compiler generates for bitmap searches in hot code.
- Let each CPU initialize its own state at boot rather than having the
  master loop over all CPUs, unless the hardware forces master-only access.
- Do not copy a struct you can reference. Do not scan all entries on every
  map when coalescing can be done incrementally.
- Never use floating point.

Memory and allocation
---------------------

- Everything countable from the configuration is sized at build time:
  object pools, static arrays, static bitmaps (see
  :ref:`design_decisions`, D1).
- Objects in a one-to-one relationship with an existing object live inside
  it (an event per vCPU goes in ``struct vcpu``), not in a pool.
- Do not mirror configuration fields in run-time structs; read them through
  ``vm->config``.
- Do not oversize for a theoretical maximum when memory is scarce. On
  microcontroller targets the number of MPU entries is a hard budget:
  allocate contiguously so entries merge, and never spend an entry per
  sibling CPU.
- Memory placed in local memories is still tracked by the page pool
  bookkeeping. Nothing is off the books.
- Check the result of every allocation. On failure undo partial work and
  return the failure to the caller.
- Alignment, and sizes in bytes versus pages versus bits, are explicit in
  names and asserted, not assumed.
- A few wasted bytes to keep code readable are fine; a wasted page per CPU
  or a scan on a hot path is not.

Concurrency
-----------

- Every lock is initialized. One lock and unlock pair per function, at the
  same nesting level; never return while holding a lock, never unlock in one
  branch only.
- Do not use state read under a lock after dropping the lock.
- Lock ordering is documented and canonical. When two locks must be held,
  take them in the same order everywhere; a walker that drops and retakes a
  lock revalidates its candidate afterwards.
- Read-modify-write on an MMIO register shared by cores needs a lock even if
  the manual says software "should not" race, because a misbehaving VM may
  make it race (see :ref:`design_decisions`, D5).
- Per-CPU private data needs no lock, and the comment at the data says why.
- Global variables are initialized once by the master CPU, not re-set by
  every CPU.
- State published late is guarded by a ready flag written last, with
  release and acquire fences; consumers check the flag, not a pointer.
- Cross-CPU configuration goes through CPU messages, not by poking another
  CPU's registers. If a target queue is full, warn and drop; never stall the
  sender on a stalled receiver.
- Barriers use the core fence API, not inline assembly. Choose the weakest
  barrier the manual requires and cite the section in a comment; put the
  barrier inside the function that changes the state, not at every call
  site; do not fence after reads or where nothing changed.
- Boot synchronization uses the existing rendezvous primitives; do not
  invent a new one.

Security and robustness
-----------------------

- Every value that originates in a VM is hostile, including values from a
  backend VM: hypercall arguments, register indices, VM, vCPU and device
  identifiers, MMIO addresses, access widths. "A guest shouldn't be able to
  make the hypervisor write out of bounds, no matter how badly it behaves."
  Bounds-check before indexing, check that the calling VM owns what it
  names, check access width and alignment per register as the manual
  specifies, and mask hypervisor-owned bits out of guest writes.
- Validation lives at the boundary (the hypercall handler, the emulation
  entry, the ``interrupts_arch_*`` hooks), so drivers can focus on hardware
  access.
- A guest touching an unimplemented or unassigned register sees reads as
  zero and writes ignored. No ``ERROR()``, and usually no ``WARNING()``
  either (see :ref:`design_decisions`, D4).
- Hypercalls, SBI, PSCI and SMCCC return the specification's error code; the
  hypervisor never halts on guest misbehavior.
- The hypervisor never spins waiting on something a guest controls. A
  hypercall that cannot proceed returns an error.
- Console and crash dump code never loops on unknown input.
- Isolation mechanisms fail closed: unbound IOMMU streams abort, an
  interrupt cannot be assigned to two VMs, a VM cannot route an interrupt to
  a CPU it does not own (see :ref:`design_decisions`, D6).
- Hard hardware requirements the hypervisor cannot work around are reported
  as an error at initialization rather than half supported.
- Arithmetic on guest-provided sizes and addresses checks for overflow.

Errors and diagnostics
----------------------

- Functions that can fail return ``bool`` or a typed sentinel; callers always
  check. Do not log and return success.
- ``ERROR()`` halts the CPU. It is for hypervisor-internal invariants and for
  configuration errors detected at boot that cannot be recovered. It is a
  hard error rather than a debug-only assert when a configuration can reach
  it in a release build.
- Initialization failures are loud. A placement or allocation that cannot
  be satisfied is a hard error at boot, never a silent fallback.
- ``WARNING()`` is for recoverable or unimplemented situations the
  integrator should know about; ``INFO()`` is for boot progress.
  Unimplemented paths warn once and continue; they neither return silently
  nor halt.
- ``_Static_assert`` guards what a user or platform can change (page size,
  stack size, CPU and VM counts, struct sizes used by assembly). Fixed
  register layouts validated once by running the code are not asserted.
- Run-time assertions guard conditions a release configuration can reach;
  debug-only assertions guard internal invariants.

.. _design_decisions:

Decisions pending
-----------------

The rules above state one side where maintainers have disagreed on record.
Each row is one decision, ranked by how much code it affects. Rows C6 and C36
of the C decisions page (``bao-docs`` pull request #90) are the C-level
counterparts of D7 and D4.

.. list-table::
   :header-rows: 1
   :widths: 4 30 38 28

   * - Id
     - Rule as written here
     - The disagreement
     - Status
   * - D1
     - Everything countable from the configuration is sized at build time;
       object pools for build-time counts.
     - #410. One side: "Since the hypervisor is built against a known
       configuration, at build time we know what VMs and VCPUs need to be
       allocated. Why should the hypervisor decide in runtime what can be
       decided at compile time?" The other: "bao is as minimal as possible
       without limiting itself in simply becoming a commit engine for
       build-time decisions"; the configuration allows static sizing, it
       does not mandate it, and ``vcpus[CONFIG_VCPU_PER_CPU_NUM]`` was
       rejected because the count "cannot be computed at build time".
     - Open; #410 not merged. Decides the shape of CPU sharing and
       microcontroller support.
   * - D2
     - ``cpu()`` is the only per-CPU access path; placement of per-CPU state
       in local memory is stated explicitly in the configuration.
     - #410. A second per-CPU mechanism beside ``cpu()`` was rejected, and
       placement "as a side effect of ``cpu_affinity``" was called "too
       implicit". Both sides agree per-CPU state in local memory is needed
       for microcontroller targets.
     - Open, same thread as D1. Needs an agreed configuration shape.
   * - D3
     - One vCPU per physical CPU, with CPU sharing opt-in per core.
     - New code is already asked not to assume ``cpu()->vcpu->vm`` is the
       only VM on the core (#256), while #410 keeps build-time sizing per
       CPU. The invariant and D1 are the same decision seen from two sides.
     - Open. Decide which paths may assume a single vCPU and how a core
       opts in.
   * - D4
     - Unimplemented or unassigned guest-visible registers read as zero and
       ignore writes; ``ERROR()`` is never reachable from guest behavior.
     - #246 (``vintc.c``). One side: "for debugging/bringup purposes I think
       there should be an error. We should eventually implement some sort
       of assert system to enable/disable these type of errors." The other:
       "We don't do this for other architectures... For the guest it should
       just look like that register is not implemented"; an immediate error
       on unimplemented registers would make people "just drop using the
       hypervisor".
     - Read-as-zero merged. The debug-build ``panic()`` and ``ASSERT()``
       series (#434 to #437) is the assert system and may reopen where a
       debug build should trap.
   * - D5
     - Read-modify-write on shared MMIO needs a lock even when the manual
       says software "should not" race.
     - #242 (``ir.c``): "I see no reason to synchronize access", locks
       removed from the TriCore interrupt router driver. #246 (``ipir.c``):
       "If the action of a misbehaving VM can affect the hypervisor or other
       VMs (even if in violation of manual recommendations) I think we do
       need to support that case."
     - Both merged in their own ports. Needs one principle: lock when a
       guest can cause the race, not only when well-behaved software would.
   * - D6
     - Isolation hardware fails closed; unbound IOMMU streams abort.
     - #382. A build or per-platform knob for bypass by default was proposed;
       the maintainers asked to "make abort the only behavior" and the author
       removed bypass. The newer IOMMU driver already faults unmatched
       streams.
     - Converged in the thread, pull request still open. Confirm "abort
       only, per-stream bypass only as explicit configuration" as the rule
       for every IOMMU.
   * - D7
     - Replace rather than keep an alternative implementation as a
       compile-time option; ``DEFINED()`` over ``#ifdef``.
     - #293: a circular queue kept as a compile-time option, maintainers
       asked to replace the list outright. #52: "I try to avoid this kind of
       conditional compilation as much as possible... we believe the code
       gains in clarity by keeping the original struct names." #116:
       separate ``rv32`` and ``rv64`` profile directories were proposed; a
       few macros were preferred to "avoid a lot of code duplication and
       indirection".
     - Settled towards fewer variants; the tolerance threshold for
       ``#ifdef`` is unwritten (C6).
