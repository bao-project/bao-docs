Bao Configuration File
======================

Overview
--------
The Bao hypervisor's configuration is managed through a dedicated configuration in the form of a C
source file. This section provides an in-depth description of the various configuration options
available.

The configuration file requires a global variable named ``config`` of the type ``struct config``,
which contains two distinct lists: (i) a list of shared memory regions (``shmemlist``) and (ii) a
list of VMs (``vmlist``). While the list of shared memory regions is optional and may be omitted
from the configuration, the list of VMs is mandatory and must include at least 1 VM. Additionally,
for each list, it is necessary to specify the list size using the parameters ``shmemlist_size`` and
``vmlist_size``.

.. code-block:: c

    #include <config.h>

    // Load guests' image
    VM_IMAGE(img1_name, "/path/to/vm1/binary.bin");
    VM_IMAGE(img2_name, "/path/to/vm2/binary.bin");

    struct config config = {

        // Shared memory region configuration
        .shmemlist_size = N,
        .shmemlist = (struct shmem[]) {
            [0] = {/*shared memory config*/,},
            [1] = {/*shared memory config*/,},
            ...
            [N] = {/*shared memory config*/,}
        },

        // Guests Configuration
        .vmlist_size = NUM_VMs,
        .vmlist = {
            { /* VM 0 Config*/},
            { /* VM 1 Config*/},
            ...
            { /* VM N Config*/},
        }
    };

.. warning::
    Inconsistencies between the specified list sizes (``shmemlist_size`` and ``vmlist_size``) and
    the actual sizes of their respective lists, may result in unpredictable behavior. Ensure that
    any changes made to the configuration lists' number of elements is reflected in the respective
    list size.

Before the configuration itself, it is necessary to declare the VM images using the ``VM_IMAGE``
macro. This macro directly embeds the guest binary file into the hypervisor image. Here's an example
usage of the ``VM_IMAGE``:

.. code-block:: c

  VM_IMAGE(img_name, "/path/to/VM/binary.bin");

The ``VM_IMAGE`` macro has two parameters:

1. The ``img_name``, an unique identifier associated with the image that will later be used to
describe the image running on the VM (see `Guest Image`_);

2. A C string with the guest image's binary file path. It can be either an absolute path or a path
relative to the config source file.

VM Configuration
--------------------

Bao's configuration file allows you to partition the platforms' hardware resources, such as CPU
cores, memory, or devices, by assigning them one or more VMs. It also allows you to configure the
guest image to run on that VM. In Bao, resources are exclusively assigned to each VM, including
communication channels between two or more VMs, which may utilize shared memory or dedicated links.

.. figure:: img/guest-config.svg
    :align: center
    :name: guest-config-fig


Each entry in the ``vmlist`` mentioned earlier is a ``vm_config`` struct, defining the
configuration for different guests by populating the following struct called *vmconfig*:

.. code-block:: c

    struct vm_config {
        struct vm_image image;
        vaddr_t entry;
        cpumap_t cpu_affinity;
        colormap_t colors;
        struct vm_platform platform;
    };

Each entry in this list represents a unique VM configuration, defining its image, memory address,
CPU affinity, color mapping, and platform details. For each VM, the following parameters must be
specified:

- **image** [mandatory] - a structure containing information about guest image loading (see details
  in `Guest Image`_)  
- **entry** [mandatory] - defines the entry point address in VM's address space;  
- **platform description** [mandatory] - a description of the VM platform, defining its resource
  assignments and requirements (see details in `Virtual Machine Configuration`_);  
- **cpu_affinity** [optional] - defines the affinity of the VM's vCPUs to the physical CPUs
  assigned to the virtual platform (see details in `CPU Affinity`_);  
- **colors** [optional] - assignment of shared LLC cache colors (or partitions) to this VM (see
  details in `Coloring`_).  

Guest Image
***********
.. _Guest Image:

The guest ``image`` comprises a structure that describes the image configuration running on the
guest side. It encompasses the following options:

- **image** [mandatory] - definition of the ``image`` to run on a given VM. The ``image``
  corresponds to the following structure:

.. code-block:: c

    struct vm_image {
            vaddr_t base_addr;
            paddr_t load_addr;
            size_t size;
            bool separately_loaded;
            bool inplace;
    } image;

where:

- **base_addr** [mandatory] - corresponds to the ``image`` load address in the VM's address space;
- **load_addr** [mandatory] - corresponds to the ``image`` load address in the hypervisor address
  space. This value can be defined using the macro VM_IMAGE_OFFSET(img_name);
- **size** [mandatory] - corresponds to the image size. For builtin images declared using
  `VM_IMAGE`, this value can be defined using the macro VM_IMAGE_SIZE(img_name);
- **separately_loaded** [optional] - informs the hypervisor if the VM image is to be loaded
  separately by a bootloader; By default, separately_loaded is set as false;
- **inplace** [optional]- use the image inplace and don’t copy the image. By default, inplace is
  set as false;

.. figure:: img/vm-image.svg
    :align: center
    :name: vm-image-fig

To ease the process of configuring the image running on each VM, the configuration of Bao allows
the use of two different macros:

1. **VM_IMAGE_BUILTIN** - This macro simplifies image configuration by requiring only the
   ``img_name`` and the image ``base_addr``. This macro specifies both the base address and image
   size.

2. **VM_IMAGE_LOADED** - This macro requires additional configurations. It requires the definition
   of image ``base_addr``, the image ``load_addr``, and the image ``size``.

Virtual Machine Configuration
*****************************

The VM configuration enables users to define the characteristics of each virtualized platform. It
encompasses critical details that define the VM's run-time environment, performance, and overall
capabilities. The virtual machine configuration is performed by populating the structure `struct
vm_platform`, outlined below:

.. code-block:: c

    struct vm_platform {
        size_t cpu_num;
        size_t region_num;
        struct vm_mem_region* regions;
        size_t ipc_num;
        struct ipc* ipcs;
        size_t dev_num;
        struct vm_dev_region* devs;
        bool mmu;
        struct arch_vm_platform arch;
    }

By customizing this configuration, users can tailor the virtual platform to suit specific workload
requirements and application needs for their virtual machines. The configuration encompasses the
definition of:
    
- **Number of CPUs** - see details in `Number of vCPUs`_;
- **Memory regions** - see details in `Memory Regions`_;`
- **Inter-Process Comunication (IPC)** - see details in `Inter-Process Communication (IPC)`_;
- **Devices** - see details in `Devices`_;
- **Memory Management** - see details in `Memory Management`_;
- **Architectural-Specific Configurations** - see details in `Architectural-Specific
  Configurations`_;

1. Number of vCPUs
##################
.. _Number of vCPUs:

- **cpu_num** [mandatory] - defines the number of CPUs assigned to the VM;

.. warning::
  Ensure that the cumulative count of CPUs allocated across all VMs listed in the `vmlist` does not
  exceed the total number of available CPUs on the platform. Failing to adhere to this requirement
  might result in the guest failing to boot without any warning.

2. Memory Regions
#################
.. _Memory Regions:

Bao employs a two-stage translation mechanism to manage VM memory. Each VM memory region is
delineated by its virtual address in the second stage. Generally, Bao manages the allocation of
physical memory for these regions. However, there is an option to define the physical memory region
where the specific region will be mapped.

For each VM, users can define multiple memory regions. To facilitate this, users first define the
total number of memory regions via the `region_num` parameter:

- **region_num** [mandatory] - defines the number of memory regions in the VM, specifically, the
  number of `vm_mem_region` entries in the `vm_platform`'s `regions` list.

Then, each memory region is described by populating the `struct vm_mem_region`:

.. code-block:: c

    struct vm_mem_region {
        paddr_t base;
        size_t size;
        bool place_phys;
        paddr_t phys;
    };

where:

- **base** [mandatory] - corresponds to the base virtual address of the memory region;
- **size**  [mandatory] -  corresponds to the size of the memory region;
- **place_phys** [optional] - the memory region is mapped into the virtual memory, and it's
  important to note that the virtual address (VA) might not necessarily be the same as the physical
  address (PA). When "place_phys" is set to true, the virtual address corresponds to the physical
  address. If ``place_phys`` equals to true, it allows to specify the physical address of the
  memory region. By default, ``place_phys`` equals to false;
- **phys** [mandatory if ``place_phys`` is true] - it corresponds to the physical address where the
  memory region should be mapped;

3. Inter-Process Communication (IPC)
####################################
.. _Inter-Process Communication (IPC):

- **ipc_num** [optional] - defines the number of IPCs assigned to the VM. By default, ``ipc_num``
  equals to zero;
- **ipcs** [mandatory if ``ipc_num`` > 0] - corresponds to the specification of the IPC and is
  configured through the following structure:

.. code-block:: c

    struct ipc {
        paddr_t base;
        size_t size;
        size_t shmem_id;
        size_t interrupt_num;
        irqid_t *interrupts;
    };


where:

- **base**  [mandatory] - corresponds to the virtual base address of the IPC memory region;
- **size** [mandatory] - corresponds to the size of the IPC memory region;
- **shmem_id** [mandatory] - corresponds to the ID of the shared memory associated with the IPC;
- **interrupt_num** [mandatory] - defines the number of interrupts assigned to the IPC;
- **interrupts** [mandatory if *interrupt_num* > 0] - defines a list of interrupt IDs assigned to
  the IPC - ``(irqid_t[]) {irq_1, ..., irq_n}``;

.. warning::
  Specifying a number of interrupts in the ``interrupts`` buffer that differs from the
  ``interrupt_num`` may result in unforeseen behavior.

4. Devices
##########
.. _Devices:

- **dev_num** [mandatory] - corresponds to the number of devices assigned to the VM;
- **devs** [mandatory if *dev_num* > 0] - corresponds to the specification of the VM's devices and
  is configured through the following structure:

.. code-block:: c

    struct vm_dev_region {
        paddr_t pa;
        vaddr_t va;
        size_t size;
        size_t interrupt_num;
        irqid_t *interrupts;
        streamid_t id; /* bus master id for iommu effects */
    };

where:

- **pa** [mandatory] - corresponds to the base physical address of the device;
- **va** [mandatory] - corresponds to the base virtual address of the device;
- **size** [mandatory] - corresponds to the size of the device memory region;
- **interrupt_num** [optional] - corresponds to the number of interrupts generated by the device to
  the VM. By default, ``interrupt_num`` equals to 0;
- **interrupts** [mandatory if *interrupt_num*>0] - defines a list of interrupt IDs generated by
  the device - ``(irqid_t[]) {irq_1, ..., irq_n};``
- **id** [optional] - corresponds to the bus master id for iommu effects:

.. warning::
  Specifying a number of interrupts in the ``interrupts`` buffer that differs from the
  ``interrupt_num`` may result in unforeseen behavior.

5. Memory Management
####################
.. _Memory Management:

 **mmu** [optional] - In MPU-based platforms which might also support virtual memory (i.e. aarch64
 cortex-r) the hypervisor sets up the VM using an MPU by default. If the user wants this VM to use
 the MMU they must set the config ``mmu`` parameter to true;

6. Architectural-Specific Configurations
########################################
.. _Architectural-Specific Configurations:

- **arch** [mandatory] - allows the definition of architecture dependent configurations and is
  configured through the following structure:

.. code-block:: c

    struct arch_vm_platform {

        // Configuration of the Generic Interrupt Controller (GIC)
        struct vgic_dscrp {
            paddr_t gicd_addr;
            paddr_t gicc_addr;
            paddr_t gicr_addr;
            size_t interrupt_num;
        } gic;

        // Configuration of the System Memory Management Unit (SMMU)
        struct {
            streamid_t global_mask;
            size_t group_num;
            struct smmu_group {
                streamid_t mask;
                streamid_t id;
            } *groups;
        } smmu;
    };


where:

- **vgic_dscrp** [mandatory] - corresponds to the configuration of the Generic Interrupt Controller
  (GIC);
- **vgic_dscrp** [optional] - corresponds to the configuration of the System Memory Management Unit
  (SMMU);


CPU Affinity
************

The configuration file of the Bao hypervisor also enables the definition of core affinity, which
involves selecting the physical core where the guest should run.

.. figure:: img/cpu-affinity.svg
    :align: center
    :name: cpu-affinity-fig

This functionality is achieved through the following configuration parameter:

- **cpu_affinity** [optional] - corresponds to a bitmap signaling the preferred physical CPUs
  assigned to the VM. If this value is mutually exclusive for all the VMs, the physical CPUs
  assigned to each VM follow the bitmap. Otherwise (in case of bit overlap or lack of affinity
  definition), the CPU assignment is defined by the hypervisor;

Coloring
********

- **colors** [optional] - corresponds to a bitmap for the assigned cache colors of the VM. This
  value is truncated depending on the number of available colors calculated at run-time, i.e., its
  platform-dependent. By default, the coloring mechanism is not active. For instance, the following
  picture depicts a hypothetical setup with a 50/50 coloring scheme;

.. figure:: img/llc-colors.svg
    :align: center
    :name: llc-colors-fig

Shared Memory Configuration
---------------------------

Configuration File Location
---------------------------

The configuration files for the Bao hypervisor are stored in a designated folder known as the
configuration repository , identified by the make variable ``CONFIG_REPO``. By default, the
``CONFIG_REPO`` is set to the ``configs`` folder located in the top-level directory of the Bao
hypervisor. However, users have the flexibility to specify a different folder by setting the
``CONFIG_REPO`` option in the make command during the hypervisor building process. For instance, a
typical build command for Bao would be:

.. code-block:: console

    make PLATFORM=target-platform\
         CONFIG_REPO=/path/to/config\
         CONFIG=config-name\

Considering a configuration named ``config-name``, the configuration source file can be located in
the ``CONFIG_REPO`` directory in two formats:

**1. Single C Source File**: a C source file with the name ``config-name.c``.

**2. Directory Format**: a directory named ``config-name``  with a single ``config.c`` file within
it.
