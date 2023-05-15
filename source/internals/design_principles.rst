Design Principles
=================

The design of the overall system architecture is centered on four fundamental
principles: (i) principle of least privilege, (ii) principle of minimality,
(iii) principle of containment, and (iv) principle of staticity.

**Principle of Least Privilege**

To mitigate privilege escalation, the system follows the principle of least
privilege, where each partition entity (e.g., :term:`VMM`, :term:`VM`), and
privilege level within it, only has (at least, direct) access to what it
absolutely must. In other words, each platform resource (e.g., CPU, memory
pages, devices, interrupts) can only be accessed by the statically allocated
partition entity.

**Principle of Minimality**

To contain the system's attack surface, the system follows the principle of
minimality. The code base strives to be as minimal and simple as possible,
relying on hardware support as much as possible (e.g., virtualization
extensions).

**Principle of Containment**

To limit the extent of an attack, the system follows the principle of
containment, where each system component (i.e., partitioner, partitions, VMs,
VMMs) is well-defined and self-contained with clear boundaries. The system must
use software- (e.g., :term:`SPI`) and hardware-enforced mechanisms (e.g.,
:term:`MMU`, :term:`IOMMU`) and techniques to sandbox each system component to
its own resources (e.g., CPU, memory, devices). Despite the straightforward
logical isolation provided by static partitioning, system components can still
interfere each other through shared micro-architectural state. Well-know
techniques such as cache-coloring can be ingrained in each system component
physical page allocation by assigning a dedicated color.

**Principle of Staticity**

To reduce the system's TCB complexity and size, the system follows the
principle of staticity, where every element of dynamicity that does not
constitute a mandatory part of run-time functionality is transformed into a
compile-time configuration option. The the system retained run-time code is
purely static, where most operations (e.g., hardware initialization) are
already determined by previously generated and externally verifiable
configuration data.

**Principle of Intentionality**

To prevent no component from exercising privilege without explicitly trying to
do so, the system follows the principle of intentionality. This principle
argues that when a program has access to various permissions, the choice of
permissions employed to validate actions taken by the program should be made
explicitly, instead of being implicitly embedded within the software
architecture or any other layer of abstraction. This is a common principle to
many capability-based systems. As such, we strive to avoid the accidental or
unintended exercise of privileges that could lead to a violation of the
security policy.
