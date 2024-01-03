Porting
=======

The Bao Hypervisor only contains architecture-specific drivers (e.g., interrupt controllers or
IOMMUS). Therefore porting the hypervisor essentially resumes to two simple operation: creating a
platform description folder containing a platform definition source and header files which
indicates, among others, the number of CPUs or the memory available. The exception is an UART driver
used fore logging, so if a driver is not available for a UART on the target platform this might
require writing such a driver. Finally, given for some platforms provide a custom mechanism to
define DMA device Master IDs required for configuring IOMMUs, one might require to configure
firmware to set these IDs. In sum, porting Bao to a platform requires:

1) Create a platform directory containing a platform description [mandatory];
2) Writing an UART driver [if the driver for the target UART is not available];
3) Setting up firmware to define DMA device Master IDs used by the platform IOMMU [platform dependent];

Platform Description
--------------------

Creating a new platform description for the Bao Hypervisor starts by creating a new directory under
*src/platform*. For example, for port to a *foo* platform, create the directory *src/platform/foo*.
This directory includes ??? four files:

1) A source file (e.g., *src/platform/foo/foo_desc.c*) containing the platform description structure, `struct platform platform`
defininition;
2) A *plat.h* header file under *src/platform/foo/inc/plat/*  with platform-specific includes and definitions;
3) A *platform.mk* makefile containing definitions required by the build system (e.g., the target architecture);
4) A *objects.mk* containing the platform's target object files. In principle this should only contain the 
object for the source description file, but you may add others if you have any other platform specific sources.

Platform Description Structure
******************************

A global structure of type `struct platform` named `platform` must be defined when porting Bao to a new platform.
This structure is defined as follows:


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

- **cpu_num** [mandatory] - defines the number of CPUs available on the platform;
- **cpu_master_fixed** [optional] - is set if the user wants to define a specific core;
- **cpu_master** [mandatory if **cpu_master_fixed** is set] - contains the linearized CPU ID for the define CPU master;
- **region_num** [mandatory] - defines the number of non-contigous memory regions available on the platform;
- **regions** [mandatory] - an array defining the available memory regions;
- **console.base** [mandatory] - defines the physical address of UART reserved for the hypervisor for logging purposes;
- **cache** [optional] - a description of the cache hierarchy for the platform;
- **arch** [mandatory] - defines an arch-specific description of the platform, including information about interrupt controllers and others.

Next, you will find a more in-depth description for the fields that require it.

CPU Description
###############

Besides the number of CPUs (**cpu_num**), a platform port might optionally define a fixed CPU master. For many platforms, at first only
one CPU starts executing and later this CPU is reponsible for waking up others through arch- and/or platform-specific means. In this case,
there is no concurrency issues during initialization. However, for platforms where all CPUs start executing simultaneously, concurrency 
issues might arise (e.g., this happens for Arm processors because atomic instructions cannot be used before MMU is enable). Here we require
the port to specificy which CPU is the CPU master, responsible for the initializaiton procedure, by setting **cpu_master_fixed** and **cpu_master**.


Memory Regions
##############

Platforms might provide a number of non-contigous memory regions. The port must describe the available memory regions by filling in the **region_num**
and **regions** fields. The former is the number of available regions while the latter defines an array of `struct mem_region` with the following fields:

.. code-block:: c

    struct mem_region {
        paddr_t base;
        size_t size;
        ...
    };

Where:

- **base** [mandatory] - Is the base physical address of that memory region. Must be aligned to the minimum architecture's page size;
- **size** [mandatory] - The size of the memory region. Must be aligned to the minimum architecture's page size;

Note that, by convention, we do not add on-chip/scratcpad SRAMs as a platform memory region as the hypervisor as an uniform view of memory.
This regions should be assigned to guests in the form of devices.


Cache Description
#################

TODO


Architcture-Specific Platform Description
#########################################

The architecture-specific field of the platform description includes fields that describe interrupt controllers or others. 

.. tabs::
    .. tab:: Arm

    For the Arm architecure, it includes the following fields:

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

    Where, for the GIC interrupt controller `struct gic_dscrp` description:

    - **gic.gicc_addr** [mandatory for GICv2 platforms] - base address for the GIC's CPU Interface;
    - **gic.gich_addr** [mandatory for GICv2 platforms] - base address for the GIC's Virtual Interface Control Registers;
    - **gic.gicv_addr** [mandatory for GICv2 platforms] - base address for the GIC's Virtual CPU Interface;
    - **gic.gicd_addr** [mandatory] - base address for the GIC's Distributor;
    - **gic.gicr_addr** [mandatory for GICv3/4 platforms] - base address for the GIC's Redistributor;
    - **gic.maintenance_id** [mandatory] - The interrupt ID for the GIC's maintenance interrupt;

    For the SMMU `struct smmu_dscrp`:

    - **smmu.base** [mandatory] - is the base address for the SMMU;
    - **smmu.global_mask** [optional; only valid for SMMUv2] - a mask to be applied to all SMMUv2's Stream Match Registers;


    Finally, when CPUs are organized in clusters, in the Arm architecture their IDs are assigned using an hierarchical schema.
    To be able to calculate the linearized ID for each core, we require the port to provide the number of CPUs of cluster in
    ascending order of AFF1.

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
                } aia;

            } irqc;

            struct {
                paddr_t base;      // Base address of the IOMMU mmapped IF
                irqid_t fq_irq_id; 
            } iommu;

            struct {
                paddr_t base;
            } aclint_sswi;
        };

    In case the available interrupt controller is the legacy PLIC:

    - **irqc.plic.base** [mandatory if PLIC is available] - is the base address for the PLIC;


    In case the available interrupt controller is an AIA contaning an APLIC:

    - **irqc.aia.aplic.base** [mandatory if APLIC is available] - is the base address for the APLIC;


    When an IOMMU is available:

    - **iommu.base** [mandatory if IOMMU is available] - is the base address for the IOMMU;
    - **iommu.fq_irq_id** [mandatory if IOMMU is available] - the Fault Queue interrupt ID (the current implementatio assumes this is a wired interrupt);


Platform Header
****************

The platform header contains any includes and definitions required for the target platform.
At a minimum it includes the header for the target UART driver.

For the RISC-V architecture it should define the following macros:

- `CPU_EXT_SSTC` if the target platform CPUs implement the SSTC extension.


Platform Make Defintions
************************

The *platform.mk* file defines the following make variables:

- `ARCH` [mandatory] - Indicates the target architecture. Options: `armv8` or `riscv`;
- `platform_description` [mandatory] - the C source file containing the platform description (in our example *foo_desc.c*);
- `drivers` [mandatory] - a space-separated list of the drivers to be included, following the names of the *src/drivers/* directory. This usually just the target UART driver.
- `platform-cppflags` [optional] - any platform-specific flags to be passed to the pre-processor;
- `platform-cflags` [optional] - any platform-specific flags to be passed to the C compiler;
- `platform-asflags` [optional] - any platform-specific flags to be passed to the assembler;
- `platform-ldflags` [optional] - any platform-specific flags to be passed to the linker;

Depending on the architecture other variables must also be defined:

.. tabs::
    .. tab:: Arm

    - `GIC_VERSION` [mandatory] - indicates the GIC's version present on the platform. Option: `GICV2`, or `GICV3`.

    .. tab:: RISC-V

    - `IRQC` [mandatory] - indicates the interrupt controller available on the platform. Options: `PLIC`, `APLIC`, or `AIA`.


Platform Object List
********************


UART Driver
-----------

TODO


Platform's Master ID Setup
--------------------------

TODO


Boot Requirements
-----------------

TODO


.. TODO:
.. - explain cpu master and CPU id linearization
.. - architecture page size
