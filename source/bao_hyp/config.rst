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
    VM_IMAGE(img1_name, "/path/to/vm1/binary.bin");
    VM_IMAGE(img2_name, "/path/to/vm2/binary.bin");

    struct config config;

The configuration is represented by a structure named config, which must be
named accordingly to ensure proper functionality.
Before defining the ``config`` struct, it is necessary to declare the VM images.
In this regard, the configuration file expects to receive a compiled image of
each guest (``.bin`` file) which will further be assigned to each VM. For instance,
the number of VM images declared can vary between 1 and the number of CPU cores
available in the target platform (as Bao hypervisor follows a 1-1 CPU
partitioning policy).

Regarding the ``config`` struct, the configuration requires a macro to initialize 
configuration-independent fields, as shown below:

.. code-block:: c

    struct config config = {

    CONFIG_HEADER
    ...

Afterward, the configuration allows the definition of two distinct lists: (i) a
list of shared memories (``shmemlist``) and (ii) a list of VMs (or guests) (``vmlist``).
While the list of shared memories is optional and may be omitted from the
configuration, the list of VMs is mandatory and must include at least 1 VM. 
Additionally, for each list, it is necessary to specify the list size using the
parameters ``shmemlist_size`` and ``vmlist_size``.

.. code-block:: c

    struct config config = {

    CONFIG_HEADER

        .shmemlist_size = N,
        .shmemlist = (struct shmem[]) {
            [0] = {/*shared memory config*/,},
            [1] = {/*shared memory config*/,},
            ...
            [N] = {/*shared memory config*/,}
        },

        .vmlist_size = NUM_VMs,
        .vmlist = {
            { /* VM 1 Config*/},
            { /* VM 2 Config*/},
            ...
            { /* VM N Config*/},
        }

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
