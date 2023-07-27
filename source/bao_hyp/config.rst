Bao Configuration File
======================

Overview
--------
The Bao hypervisor's configuration is managed through a dedicated configuration
file (denoted by the .c file). This section serves to provide an in-depth
exploration of the various configuration options available.

The configuration file follows a specific structure, as outlined below:

.. code-block:: c

    #include <config.h>

    // Load guests' image
    VM_IMAGE(img1_name, "/path/to/vm1/binary.bin");
    VM_IMAGE(img2_name, "/path/to/vm2/binary.bin");

    struct config config = { 

        // Shared memories configuration
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

Prior to defining the ``config`` struct, it is imperative to declare the VM
images. The declaration of VM images utilizes the VM_IMAGE macro, requiring an
identifier and the respective path to the image file. In this regard, the
configuration file expects to receive a compiled image of each guest
(``.bin`` file) that will be subsequently assigned to individual VMs using the
``VM_IMAGE`` macro. For instance, the number of VM images declared may vary 
between 1 and the count of CPU cores accessible in the target platform, given
that the Bao hypervisor adheres to a 1-1 CPU partitioning policy.

Afterward, the configuration allows the definition of two distinct lists: (i) a
list of shared memory regions (``shmemlist``) and (ii) a list of VMs (or
guests) (``vmlist``). While the list of shared memory regions is optional and
may be omitted from the configuration, the list of VMs is mandatory and must
include at least 1 VM. Additionally, for each list, it is necessary to specify
the list size using the parameters ``shmemlist_size`` and ``vmlist_size``.


Guests Configuration
--------------------

Guest Image
***********

Virtual Machine Configuration
*****************************

1. Number of vCPUs
##################

2. Memory Mapping
#################

3. Inter-Process Communication (IPC)
####################################

4. Devices
##########

5. Memory Management
####################

6. Architectural-Specific Configurations
########################################

CPU Affinity
************

Coloring
********

Shared Memory Configuration
---------------------------
