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
