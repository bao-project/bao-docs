.. _glossary:

Glossary
========

.. glossary::
    :sorted:

    PR
        Pull-Request: changes to be pushed into a branch of a repository. More
        information :ref:`here <contributing>`.

    CI
        Continuous Integration: process that automates the integration of
        new changes to the repositories. More information
        :ref:`here <ci>`.

    MISRA
        Set of software development guidelines for the C programming language
        developed by The MISRA Consortium and followed by the Bao project. More
        information :ref:`here <misra>`

    maintainer
        Top-level role in the administration of a repository. More information
        :ref:`here <contrib_roles>`.

    developer
    contributor
        Internal or external developer that in any way contributes to the
        project. More information :ref:`here <contrib_roles>`.

    code owner
        High-level role in the administration of a repository, marked and
        invited by a maintainer to oversee the development of one or multiple
        subsystems in a repository. More information
        :ref:`here <contrib_roles>`.

    IOMMU
        Input-Output Memory Management Unit. This hardware component performs
        address translation and access control for other bus masters external
        to the CPU.

    MMU
        Memory Management Unit. This hardware component performs two primary
        functions: it translates virtual addresses into physical addresses, and
        it controls memory access permissions.

    SPrvI
        Same Privilege Isolation. This software technique enables to isolated
        software entities running on the same execution privilege by
        deprovisioning the entity's image binaries from instructions that
        modify the hardware isolation mechanisms accessed only on that
        execution level.

    VMM
        Virtual Machine Monitor. This software component leverages
        virtualization technology to share a system with many virtual
        environments. It emulates the hardware of a host platform to provision
        higher-level software with a virtual environment, called Virtual
        Machine, with its own hardware resources (e.g., CPU, memory, network
        interface).

    VM
        Virtual Machine. This software component is a virtualized environment
        created by a VMM to host guest OSes.
