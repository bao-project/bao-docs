Overview
========

Bao (from Mandarin Chinese “bǎohù”, meaning “to protect”) is a lightweight,
open-source embedded hypervisor which aims at providing strong isolation and
real-time guarantees. Bao provides a minimal, from-scratch implementation of
the partitioning hypervisor architecture. Designed mainly for targeting
mixed-criticality systems, Bao strongly focuses on isolation for
fault-containment and real-time behavior. Its implementation comprises only a
minimal, thin-layer of privileged software leveraging ISA virtualization
support to implement the static partitioning hypervisor architecture: resources
are statically partitioned and assigned at VM instantiation time; memory is
statically assigned using 2-stage translation; IO is pass-through only; virtual
interrupts are directly mapped to physical ones; and it implements a 1-1
mapping of virtual to physical CPUs, with no need for a scheduler. Bao has no
external dependencies, such as on privileged VMs running untrustable, large
monolithic general-purpose operating systems (e.g., Linux), and, as such,
encompasses a much smaller TCB. Bao originally targets the Armv8-A
architecture, but there is experimental support for the RISC-V architecture.

