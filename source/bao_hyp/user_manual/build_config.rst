Build Configuration
===================

Overview
--------
Bao is configured at two levels. The build configuration, described in this page, decides what the
hypervisor binary contains: which features are compiled in, the target platform and its hardware
facts, and build-time tunables. The :doc:`configuration file <config>` then parameterizes what is
there: the VMs, their images, memory regions and devices.

The build configuration uses `Kconfig <https://docs.kernel.org/kbuild/kconfig-language.html>`_, the
configuration language of the Linux kernel. Each build has its own resolved configuration, stored
in a ``.config`` file in its build directory, so that different builds never share one.

.. note::
    Configuring a build requires ``python3`` with version 14.1.0 of the
    `kconfiglib <https://pypi.org/project/kconfiglib/14.1.0/>`_ package
    (``pip install kconfiglib==14.1.0``).

Building
--------
The usual build command needs nothing else:

.. code-block:: shell

    make PLATFORM=target-platform CONFIG=config-name CROSS_COMPILE=toolchain-prefix-

This is the *classic* build. Both ``PLATFORM`` and ``CONFIG`` are required, and ``CONFIG_REPO`` can
be added to look the configuration up in an external repository. The first build creates the
``.config`` in ``build/target-platform/config-name``, which is called *seeding*. Later builds reuse
it, and when it changes only what depends on it is built again.

Configuration Options
---------------------
The symbols of the build configuration fall into three kinds:

+------------------------+----------------------------------------------+-------------------------+
| Kind                   | Examples                                     | Editable                |
+========================+==============================================+=========================+
| User options           | ``IPI_MAX_EVENTS``,                          | Yes                     |
|                        | ``MMIO_SLAVE_SIDE_PROT``, the GIC version on |                         |
|                        | platforms that offer more than one, the      |                         |
|                        | interrupt controller on the QEMU RISC-V      |                         |
|                        | platforms                                    |                         |
+------------------------+----------------------------------------------+-------------------------+
| Platform facts         | ``ARCH``, ``CPU``, the memory protection     | No, they follow the     |
|                        | model, ``GIC_VERSION`` on platforms with a   | platform selection      |
|                        | single GIC version                           |                         |
+------------------------+----------------------------------------------+-------------------------+
| Platform capabilities  | ``PLAT_HAS_*`` symbols                       | No, they decide which   |
|                        |                                              | user options are        |
|                        |                                              | offered                 |
+------------------------+----------------------------------------------+-------------------------+

Options are only changed through the mechanisms described in this page. The build rejects:

* ``CONFIG_*`` options and platform facts (``ARCH``, ``GIC_VERSION``, ``IRQC``, and so on) set on
  the make command line.
* Unknown symbols in a defconfig or in a fragment, such as a misspelled or renamed option.
* A defconfig or a fragment that sets a platform fact or selects another platform.

Inspecting and Changing Options
-------------------------------
Three targets operate on the configuration of a build without building it:

.. code-block:: shell

    make PLATFORM=target-platform CONFIG=config-name listconfig
    make PLATFORM=target-platform CONFIG=config-name menuconfig
    make PLATFORM=target-platform CONFIG=config-name defconfig

``listconfig``
    Prints every option with its value, its default, and where the value came from (``default``,
    ``platform``, ``config``, ``fragment`` or ``modified``), followed by the platform facts.
``menuconfig``
    Opens an interactive editor on the ``.config`` of the build. Platform facts are shown as
    read-only lines.
``defconfig``
    Seeds the ``.config`` of the build without building.

A classic build directory is pinned to its platform and VM configuration. ``menuconfig`` cannot
switch them there, and a manual edit of either in the ``.config`` is rejected by the next build.

Configuration Layers
--------------------
When a ``.config`` is seeded, the following layers are applied in order, each one overriding the
previous ones:

1. The default of each option, already specialized for the selected platform.
#. The platform defconfig, ``src/platform/target-platform/defconfig``, when it exists.
#. The configuration folder defconfig, a ``defconfig`` file next to the ``config.c`` of the VM
   configuration, when it exists. Configurations given as a single ``config-name.c`` file do not
   have this layer.
#. The fragments listed in ``KCONFIG_FRAGMENTS`` (see `Configuration Fragments`_).

A defconfig is a list of option assignments, in the same format as the ``.config``:

.. code-block:: none

    CONFIG_IPI_MAX_EVENTS=64
    # CONFIG_MMIO_SLAVE_SIDE_PROT is not set

The defconfig of a configuration folder is the place to state which options a ``config.c`` needs.
After seeding, the ``.config`` belongs to the build: changes made in ``menuconfig`` are stored
there, and ``listconfig`` reports them as ``modified``.

Output Directories
------------------
As an alternative to the classic build, an *output directory* keeps the platform and the VM
configuration in its ``.config``, as in the Linux kernel:

.. code-block:: shell

    make O=out target-platform_defconfig CONFIG=config-name
    make O=out menuconfig
    make O=out CROSS_COMPILE=toolchain-prefix-

1. The ``target-platform_defconfig`` target seeds ``out/.config`` for that platform. ``CONFIG``,
   and optionally ``CONFIG_REPO``, record the VM configuration and apply the defconfig of its
   folder.
#. Without ``CONFIG``, the VM configuration is set afterwards in ``menuconfig``, in the
   ``CONFIG_SRC`` option. It takes a name looked up in the configuration repository (the
   ``CONFIG_REPO`` option, which when empty means the ``configs`` folder of the hypervisor), a path
   to a configuration folder, or a path to a ``config.c`` file. A build without a VM configuration
   fails.
#. From then on, ``make O=out`` builds in that directory. ``O`` has to be passed on every
   invocation, or exported in the environment.

When neither ``O``, ``PLATFORM`` nor ``CONFIG`` are given, the output directory is ``build``, with
the binaries in ``bin``. The two kinds of build do not mix: ``PLATFORM`` and ``CONFIG`` are
rejected together with ``O`` on a build, and ``PLATFORM`` is rejected together with a
``target-platform_defconfig`` target.

An output directory is not pinned, so both the platform and the VM configuration can be changed in
``menuconfig``. On an empty directory ``menuconfig`` starts from the defaults, while ``listconfig``
needs a seeded ``.config``.

Changing the Platform or the VM Configuration
*********************************************
A copy of the seed is kept next to the ``.config``. When a build finds that the platform or the VM
configuration in the ``.config`` are no longer the ones it was seeded for, whether they were
changed in ``menuconfig``, by hand or by a fragment, it seeds the ``.config`` again for the new
pair:

* The options changed since the previous seed are applied on top of the new seed. The ones that no
  longer apply, such as a GIC version on a platform that has a single one, are dropped.
* The options that only the defconfig of the previous VM configuration had set go back to their
  defaults.
* The previous file is kept as ``.config.old``.

When neither VM configuration has a defconfig and the platform stays the same, the only difference
in the ``.config`` is therefore the VM configuration itself.

Configuration Fragments
-----------------------
Fragments are files in the defconfig format that are layered on top of the defconfigs, as with the
``merge_config.sh`` script of the Linux kernel. ``KCONFIG_FRAGMENTS`` takes a list of them, later
ones overriding earlier ones, in both kinds of build:

.. code-block:: shell

    make PLATFORM=target-platform CONFIG=config-name KCONFIG_FRAGMENTS="base.config debug.config"
    make O=out target-platform_defconfig CONFIG=config-name KCONFIG_FRAGMENTS=debug.config
    make O=out KCONFIG_FRAGMENTS=debug.config

At seeding, the fragments are the last layer. When the build already has a ``.config``, they are
merged into it on every invocation that passes them.

.. warning::
    An option set by a fragment is applied again whenever the fragment is passed, even if it was
    changed in ``menuconfig`` in between.

Changing a Defconfig or a Fragment
----------------------------------
An existing ``.config`` is only modified by what is explicitly done to it:

+--------------------------------------------+----------------------------------------------------+
| What changed                               | Effect on an existing ``.config``                  |
+============================================+====================================================+
| A defconfig (platform or configuration     | None. Seed again to adopt it (see below)           |
| folder)                                    |                                                    |
+--------------------------------------------+----------------------------------------------------+
| A fragment that is not passed in           | None                                               |
| ``KCONFIG_FRAGMENTS``                      |                                                    |
+--------------------------------------------+----------------------------------------------------+
| A fragment passed in ``KCONFIG_FRAGMENTS`` | Its current contents are merged in, as on every    |
|                                            | invocation that passes it                          |
+--------------------------------------------+----------------------------------------------------+
| The platform or the VM configuration       | Seeded again for the new pair, keeping the options |
|                                            | changed since the previous seed                    |
+--------------------------------------------+----------------------------------------------------+

To adopt a changed defconfig, seed the configuration again. In a classic build, remove the
``.config`` from the build directory and build. In an output directory, run the
``target-platform_defconfig`` target again.

.. warning::
    Seeding again from scratch discards the options changed in that build directory.

Cleaning
--------

+-----------------+----------------------------------+--------------------------------------------+
| Target          | Classic build                    | Output directory                           |
+=================+==================================+============================================+
| ``clean``       | Removes the build products and   | With an explicit ``O=``, empties the       |
|                 | the binaries, keeps the          | directory and keeps the ``.config``. With  |
|                 | ``.config``                      | the default ``build`` directory, removes   |
|                 |                                  | ``build`` and ``bin`` entirely,            |
|                 |                                  | ``.config`` included                       |
+-----------------+----------------------------------+--------------------------------------------+
| ``distclean``   | Removes the build directory,     | Also removes the ``.config`` and the files |
|                 | ``.config`` included             | kept next to it                            |
+-----------------+----------------------------------+--------------------------------------------+

Build Directory Files
---------------------
The configuration of a build is kept in the following files of its build directory:

+-----------------------+-------------------------------------------------------------------------+
| File                  | Description                                                             |
+=======================+=========================================================================+
| ``.config``           | The working configuration of the build                                  |
+-----------------------+-------------------------------------------------------------------------+
| ``.config.old``       | The previous ``.config``, kept every time it is rewritten               |
+-----------------------+-------------------------------------------------------------------------+
| ``.seed``             | Copy of the configuration as it was seeded, used to detect a platform   |
|                       | or VM configuration change and to tell which options were changed since |
+-----------------------+-------------------------------------------------------------------------+
| ``.pin``              | Classic build directories only: fixes the platform and the VM           |
|                       | configuration of the directory                                          |
+-----------------------+-------------------------------------------------------------------------+
| ``config/auto.conf``  | The options as make variables, included by the Makefile                 |
+-----------------------+-------------------------------------------------------------------------+
| ``config/autoconf.h`` | The options as ``CONFIG_*`` macros, included in every source file       |
+-----------------------+-------------------------------------------------------------------------+

Adding Options and Platforms
----------------------------
The ``CONFIG_*`` macros are visible in every source file without an include, and the same names
are available as make variables to select which objects are built:

.. code-block:: make

    core-objs-$(CONFIG_FEATURE)+=feature.o

A new option is declared in the ``Kconfig`` file of the component it belongs to
(``src/core/Kconfig`` for core features, ``src/arch/target-arch/Kconfig`` for architecture ones)
and is added together with the code that depends on it.

A new platform adds two files to its folder, which are found automatically:

* ``Kconfig.plat``, with its entry in the platform choice and the capabilities it selects.
* ``Kconfig``, with the values of its platform facts and, where the hardware offers alternatives,
  the corresponding choices.

.. spelling:word-list::

    Kconfig defconfig Defconfig defconfigs tunables parameterizes
