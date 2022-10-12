.. _requirement_framework:

Bao Requirements Framework
==========================

.. _Bao Design: https://www.github.com/bao-project

Introduction
------------

This document specifies the strategy of requirement specification followed in
by the Bao project. Requirements are specified at various abstraction levels
and follow a hierarchical structure. The starting point is the overall design
and definition of Bao. Bao's definition will directly inform the specification
of Bao's :ref:`Utilitarian Objectives<objectives>`. Additionally, Bao's design
will inform the security threat model and the safety and security assumptions.
Because it is impossible to predict every single environment Bao will be
deployed in, a set of assumptions are made regarding the security and safety
environment. Additionally a Security Threat model is established that outlines
the expected security threats Bao might face. The Security Assumptions and
Security Threat Model are used to derive :ref:`Security
Objectives<Objectives>`. The Safety Assumptions, in their turn, are used to
derive :ref:`Safety Objectives<Objectives>`. The objectives give rise to
:ref:`HLR`, which are used to derive :ref:`DLR`. The :ref:`DLRs<DLRs>` are the
basis to define :ref:`DELR` and :ref:`ILR`.


The following diagram depicts how the concepts explained in this document
relate to each other:

    .. figure:: ./img/BaoReq.png
        :width: 340px
        :align: center
        :name: bao-req-fig

        Bao Requirement Concepts and their relation to each other.



.. _T_A:

Threats and Assumptions
-----------------------

Threats and assumptions define the expected security and safety problems.
These include security and safety threats to be mitigated by the either the
system or the operating environment.

The system's overall design is the leading input in creating the security and
safety threat models. An overall description of the system can be found in `Bao
Design`_. With this high-level view of the system, it's possible to create
security and safety threat models and establish security and safety assumptions
regarding the environment in which the system will operate. Assumptions
describe aspects of the system's operations that are assumed to be true or are
imposed by external factors. If assumptions are not met by the environment, the
system will not provide the necessary security and safety functionality. The
threat models specify the countered security and safety threats. Some threats
are addressed directly by meeting the security and safety Objectives_. Others
are expected to taken care of by the environment in which the system is
deployed.

.. _objectives:

Objectives
----------

Our framework establishes three categories of objectives: utilitarian,
security, and safety. Utilitarian objectives establish what is the
functionality of Bao that is not directly related to security or safety. They
establish the high-level features that Bao must meet in order to provide
desirable functionality not related to security or safety. Security objectives
address security concerns brought to light by the threat model and assumptions.
The same is true for safety objectives, regarding safety threats.


Requirements
------------

.. _HLR:

High-Level Requirements (HLR)
*****************************

High-Level Requirements (HLR) establish a more detailed description of the
functionality and restrictions first established in the objectives. These
descriptions are written from the system's point of view without relating to
the actual architectural components that implement them. As such, these
requirements specify the system's behavior as a whole. These requirements are
not very detailed, as they still serve as an overall guideline for a feature,
not the exact details of what must be accomplished. HLRs are not
platform-specific, so they use generic terms applicable across the various
supported platforms


.. Note::
   One way to make sense of HLRs is to take the point of view of a system
   integrator which is consolidating multiple software stacks in system
   partitions, and making certain assumptions about its execution environment.

.. _DLR:

Design-Level Requirements (DLR)
*******************************

Design-Level Requirements (DLR) map the high-level functionality established in
HLR_ to the actual architectural components of the system (e.g., Tool, VMM,
Partitioner). They detail even further the functionality and restrictions that
may apply. For example, by detailing that access control must be performed
using certain mechanisms without explicitly describing how they are
implemented. DLRs may also enumerate requirements obtained from expanding the
ideas in a single HLR. Another aspect of DLRs is that they are still
platform-agnostic, and their specifications refer to multiple platforms.


.. TODO: add example of requirement mapping between HLR and DLR

.. _DELR:

Design-Level Error Requirements (DELR)
**************************************

Design-Level Error Requirements (DELR) map to some DLR_ with the goal of
detailing the expected error conditions during the operation of Bao. DELR
should establish the error conditions that must be detected by the system and
the correct way to handle the detected errors depending on the current context.

.. _ILR:

Implementation-Level Requirements (ILR)
***************************************

Implementation-Level Requirements (ILR) map to DLR_ to further refine the
requirements. At this level, platform aspects are taken into account. For
example, specific interrupt control (e.g., GIC 400), or IOMMU (e.g., SMMU 400)
support. Additionally, ILR also specifies which data formats are to be used at
an interface level. For example, a device tree format for configuration of the
system partitions.

