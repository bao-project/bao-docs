Porting Guide
=============

Porting the Bao Hypervisor to a new platform typically involves **two main steps**: (i) creating a
**platform description** directory containing the source and header files that define
platform-specific details, such as the number of CPUs, available memory regions, and interrupt
mappings; and (ii) integrating a **UART driver** to enable logging output. In some cases, a **third
step** is required: configuring the platform firmware to set DMA device Master IDs. This is
necessary on platforms that use a custom mechanism for defining these IDs, which are needed for
proper IOMMU configuration.

In sum, porting Bao to a platform requires:

1) [**mandatory**] Create a platform directory containing a platform description (see
   :ref:`Platform Description<plat_desc>`);
2) [**mandatory**] Implementing a UART driver if not already available in the drivers folder (see
   :ref:`UART Driver<uart_driver>`);
3) [**platform-dependent**] Setting up firmware to define DMA device Master IDs used by the
   platform IOMMU (see :ref:`IOMMU Master IDs<iommu_master_ids>`);

.. _plat_desc:

Platform Description
--------------------

Creating a new **platform description** for the Bao Hypervisor starts by creating a new directory
under ``src/platform``. For instance, when porting to a **foo** platform, you need to create the
directory ``src/platform/foo``.

This directory includes mandatorily **four files**:

1) A source file (e.g., ``src/platform/foo/foo_desc.c``) containing the platform description
   structure, i.e., the ``struct platform platform`` definition (see :ref:`Platform Description
   Structure<plat_desc_struct>`);
2) A ``platform.h`` header file under ``src/platform/foo/inc/plat/`` with platform-specific
   includes and definitions;
3) A ``platform.mk`` makefile containing definitions required by the build system (e.g., the target
   architecture);
4) A ``objects.mk`` containing the platform's target object files. In principle this should only
   contain the object for the source description file, but you may add others if you have any other
   platform specific sources.

Moreover, for Arm-based platforms with TrustedFirmware-A support we also need a **fifth file**:

5) A ``psci.h`` header file under ``src/platform/foo/inc/plat/`` defining the platform-specific
   PSCI power state values.

.. TODO: add explanation about MCU-based platforms that do not support firmware and require some
    kind of platform-specific initialization code that should be in directory.

.. _plat_desc_struct:

Platform Description Structure
******************************

A global structure of type ``struct platform`` named ``platform`` must be defined when porting Bao
to a new platform. This structure is defined as follows:


.. code-block:: c

    struct platform {
        size_t cpu_num;

        bool cpu_master_fixed;
        cpuid_t cpu_master;

        size_t region_num;
        struct mem_region* regions;

        struct {
            paddr_t base;
        } console;

        struct cache cache;

        struct arch_platform arch;
    };

Where:

- ``cpu_num`` [**mandatory**]: defines the number of CPUs available on the platform;
- ``cpu_master_fixed`` [**optional**]: is set if the user wants to define a specific core;
- ``cpu_master`` [**mandatory** if ``cpu_master_fixed`` is **set**]: contains the linearized CPU
  ID for the define CPU master;
- ``region_num`` [**mandatory**]: defines the number of non-contiguous memory regions available on
  the platform;
- ``regions`` [**mandatory**]: an array defining the available memory regions;
- ``console.base`` [**mandatory**]: defines the physical address of the UART reserved for the
  hypervisor for logging purposes;
- ``cache`` [**optional**]: a description of the cache hierarchy of the platform;
- ``arch`` [**mandatory**]: defines an architecture-specific description of the platform,
  including information about interrupt controllers and others.

In the next sections, you will find a more in-depth description of the ``platform`` fields.

CPU Description
###############

In addition to specifying the number of CPUs (``cpu_num``), a platform port may **optionally**
define a fixed CPU master (``cpu_master_fixed``). On many platforms, only a **single** CPU begins
execution at reset, and this CPU is responsible for bringing up the remaining CPUs through
architecture- and/or platform-specific mechanisms. In such cases, there are **no concurrency**
concerns during early initialization. However, on platforms where **all CPUs** start executing
simultaneously, **concurrency issues may arise** (e.g., on Arm processors, atomic instructions
cannot be used before the MMU is enabled). To handle this scenario, the port must specify which CPU
acts as the master, responsible for the initialization sequence, by setting both
``cpu_master_fixed`` and ``cpu_master``.


Memory Regions
##############

Platforms might provide a number of non-contiguous memory regions. The port must describe the
available memory regions by filling in the ``region_num`` and ``regions`` fields. The former is the
number of available regions while the latter defines an array of ``struct mem_region`` with the
following fields:

.. code-block:: c

    struct mem_region {
        paddr_t base;
        size_t size;
        ...
    };

Where:

- ``base`` [**mandatory**]: defines the base physical address of that memory region;
- ``size`` [**mandatory**]: defines the size of the memory region.

.. warning::
    Ensure that the memory ``base`` and ``size`` are aligned to the minimum architecture's page
    size.

.. note::
   By convention, we do not add on-chip/scratchpad SRAMs as a platform memory region as the
   hypervisor as an uniform view of the memory. This regions should be assigned to guests in the
   form of devices.

.. TODO: update the note after the feat/non-unified branch is upstream


Cache Description
#################

Bao requires platform-specific cache geometry to enable the hypervisor to partition cache resources
between VMs, a feature that is called *cache coloring*. As such, the ``cache`` field of the
platform description must be filled in with the cache hierarchy of the platform. The cache
description is defined as follows:

.. code-block:: c

    struct cache {
        size_t lvls;
        size_t min_shared_lvl;
        enum { UNIFIED, SEPARATE, DATA, INSTRUCTION } type[CACHE_MAX_LVL];
        enum { PIPT, VIPT } indexed[CACHE_MAX_LVL][2];
        size_t line_size[CACHE_MAX_LVL][2];
        size_t assoc[CACHE_MAX_LVL][2];
        size_t numset[CACHE_MAX_LVL][2];
    };

Where:

- ``lvls`` [**mandatory**]: defines the number of cache levels available on the platform;
- ``min_shared_lvl`` [**optional**]: specifies the minimum cache level that is shared between CPUs
  (0 if all levels are private);
- ``type`` [**mandatory**]: defines the cache type for each level: ``UNIFIED`` (combined
  data/instruction), ``SEPARATE`` (split data/instruction), ``DATA`` (data only), or
  ``INSTRUCTION`` (instruction only);
- ``indexed`` [**mandatory**]: specifies the cache indexing scheme for each level: ``PIPT``
  (Physically Indexed, Physically Tagged) or ``VIPT`` (Virtually Indexed, Physically Tagged). The
  second dimension [2] accounts for separate data and instruction caches;
- ``line_size`` [**mandatory**]: defines the cache line size in bytes for each cache level. The
  second dimension [2] accounts for separate data and instruction caches;
- ``assoc`` [**mandatory**]: specifies the associativity (number of ways) for each cache level.
  The second dimension [2] accounts for separate data and instruction caches;
- ``numset`` [**mandatory**]: defines the number of cache sets for each cache level. The second
  dimension [2] accounts for separate data and instruction caches.

.. note::
   For unified caches, only index [0] of the second dimension is used. For separate caches, index
   [0] represents data cache and index [1] represents instruction cache.

Architecture-Specific Platform Description
##########################################

The architecture-specific field (``arch``) of the platform description includes fields that
describe interrupt controllers or others.

.. tabs::
    .. tab:: Arm

        For the Arm architecture, it includes the following fields:

        .. code-block:: c

            struct arch_platform {
                struct gic_dscrp {
                    paddr_t gicc_addr;
                    paddr_t gich_addr;
                    paddr_t gicv_addr;
                    paddr_t gicd_addr;
                    paddr_t gicr_addr;

                    irqid_t maintenance_id;
                } gic;

                struct smmu_dscrp {
                    paddr_t base;
                    streamid_t global_mask;
                } smmu;

                struct clusters {
                    size_t num;
                    size_t* core_num;
                } clusters;
            };

        Where, for the GIC interrupt controller ``struct gic_dscrp`` description:

        For **all** platforms:

        - ``gic.maintenance_id`` [**mandatory**]: defines the interrupt ID for the maintenance
          interrupt.
        - ``gic.gicd_addr`` [**mandatory**]: defines the base address for the GIC distributor.

        For **GICv2** platforms:

        - ``gic.gicc_addr`` [**mandatory**]: defines the base address for the GIC CPU interface;
        - ``gic.gich_addr`` [**mandatory**]: defines the base address for the GIC hypervisor
          interface;
        - ``gic.gicv_addr`` [**mandatory**]: defines the base address for the GIC virtual CPU
          interface;

        For **GICv3/4** platforms:

        - ``gic.gicr_addr`` [**mandatory**]: defines the base address for the GIC redistributor;

        For the SMMU, the ``struct smmu_dscrp`` features:

        - ``smmu.base`` [**mandatory**]: defines the base address for the SMMU;
        - ``smmu.global_mask`` [**optional**; only valid for **SMMUv2**]: a mask to be applied to
          all SMMUv2's Stream Match Registers;

        Finally, when CPUs are organized in clusters, in the Arm architecture their IDs are
        assigned using an hierarchical schema. To be able to calculate the linearized ID for each
        core, we require the port to provide the number of CPUs of cluster in ascending order of
        AFF1.

    .. tab:: RISC-V

        For the RISC-V architecture, the architecture-specific description is as follows:

        .. code-block:: c

            struct arch_platform {
                union irqc_dscrp {
                    struct {
                        paddr_t base;
                    } plic;
                    struct {
                        struct {
                            paddr_t base;
                        } aplic;
                        struct {
                            paddr_t base;
                            size_t num_msis;
                        } imsic;
                    } aia;
                } irqc;

                struct {
                    paddr_t base;      // Base address of the IOMMU mmapped IF
                    unsigned mode;     // Overall IOMMU mode (Off, Bypass, DDT-lvl)
                    irqid_t fq_irq_id; // Fault Queue IRQ ID (wired)
                } iommu;

                struct {
                    paddr_t base; // Base address of the ACLINT supervisor software interrupts
                } aclint_sswi;
            };

        In case the available interrupt controller is the legacy PLIC:

        - ``irqc.plic.base`` [**mandatory** if PLIC is available]: defines the base address for
          the PLIC;

        In case the available interrupt controller is an AIA containing an APLIC and/or IMSIC:

        - ``irqc.aia.aplic.base`` [**mandatory** if APLIC is available]: defines the base address for
          the APLIC;
        - ``irqc.aia.imsic.base`` [**mandatory** if IMSIC is available]: defines the base address for
          the IMSIC;

        When an IOMMU is available:

        - ``iommu.base`` [**mandatory** if IOMMU is available]: defines the base address for the
          IOMMU;
        - ``iommu.fq_irq_id`` [**mandatory** if IOMMU is available]: defines the Fault Queue
          interrupt ID (the current implementation assumes this is a wired interrupt);


Platform Header
***************

The platform header file (``platform.h``) contains all includes and definitions specific to the
target platform. At a minimum, it must include the header file for the selected UART driver.

For the RISC-V architecture it should define the following macros:

- ``CPU_EXT_SSTC`` if the target platform CPUs implement the SSTC extension.

.. TODO: missing IPIC_SBI and IPIC_ACLINT ??

Platform Make Definitions
*************************

The ``platform.mk`` file defines the following make variables:

- ``ARCH`` [**mandatory**]: indicates the target architecture. Options: ``armv8`` or ``riscv``;
- ``CPU`` [**optional**]: indicates the target CPU;
- ``platform_description`` [**mandatory**]: the C source file containing the platform description
  (in our previous example ``foo_desc.c``);
- ``drivers`` [**mandatory**]: a space-separated list of the drivers to be included, following the
  names of the ``src/drivers/`` directory. This usually is just the target UART driver.
- ``platform-cppflags`` [**optional**]: any platform-specific flags to be passed to the
  pre-processor;
- ``platform-cflags`` [**optional**]: any platform-specific flags to be passed to the C compiler;
- ``platform-asflags`` [**optional**]: any platform-specific flags to be passed to the assembler;
- ``platform-ldflags`` [**optional**]: any platform-specific flags to be passed to the linker;

Depending on the architecture other variables must also be defined:

.. tabs::
    .. tab:: Arm

        - ``GIC_VERSION`` [**mandatory**]: indicates the GIC's version present on the platform.
          Options: ``GICV2`` or ``GICV3``.

    .. tab:: RISC-V

        - ``IRQC`` [**mandatory**]: indicates the interrupt controller available on the platform.
          Options: ``PLIC``, ``APLIC``, or ``AIA``.
        - ``IPIC`` [**mandatory**]: indicates the core's IPIs controller available on the platform.
          Options: ``IPIC_SBI`` or ``IPIC_ACLINT``.


Platform Object List
********************

The ``objects.mk`` is self-explanatory, and includes at minimum the source file describing the
platform. In our example, this would be ``foo_desc.c``; therefore, the file would contain:

.. code-block:: c

    boards-objs-y+=foo_desc.o


.. _uart_driver:

UART Driver
-----------

TODO

.. _iommu_master_ids:

Platform's Master ID Setup
--------------------------

TODO


Boot Requirements
-----------------

TODO


.. TODO:
.. - explain cpu master and CPU id linearization
.. - architecture page size
