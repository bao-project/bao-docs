Security Threat Model and Assumptions
=====================================

This document presents the security threats the system addresses and the assumptions made about the operational and development environment. We followed several publicly available Common Criteria's Protection Profiles (PP) and Security Targets (ST) as a foundation to define the system's threats and assumptions. These include PPs and STs from SYSGO's `PikeOS<https://www.atsec.de/wp-content/uploads/2019/01/1041b_pdf.pdf>`_, `FINX RTOS<https://www.commoncriteriaportal.org/files/epfiles/tds_finx_rtos_se_v31_lite01.pdf>`_, QNX's `Neutrino RTOS<https://www.commoncriteriaportal.org/files/epfiles/qnx-neutrino-v640-sec-eng.pdf>`_, Huawei's `HongMengOS<https://www.tuv-nederland.nl/assets/files/cerfiticaten/2019/11/st-hongmeng-v2.8.pdf>`_, Green Hill's `Integrity hypervisor<https://www.commoncriteriaportal.org/files/epfiles/st_vid10362-st.pdf>`_, and Trustonic's `Kinibi Trusted Execution Environment<https://www.ssi.gouv.fr/uploads/2017/02/anssi_cc-2017_03-cible-publique.pdf>`_.

Glossary
--------

.. glossary::
    :sorted:

    Attacker
        An eentity that leverages the privileges of a :term:`subject` to
        exploited to achieve malicious operations.

    Subject
        An entity of system that has control over system resources.

    Administrator
        Subject authorized to make modifications to the system images,
        including executable programs and system configuration data.

    Configuration vector
        Data that establishes the systems security policies`, resource
        distribution over system entities and initial system register and MMIO
        devices state, i.e., the collection of the :term:`PACV` and
        :term:`PIV`.

    PACV
        Partition Access Control Vector, which establishes the access control
        policy over system resources.

    PIV
        Platform Initialization Vector, which establishes the initial
        configuration of systems registers, and relevant memory mapped IO.

    Partition
        Collection of system resources (e.g., CPUs, memory regions, etc) and
        the programs which can access them.

    Operational configuration
        Configuration vector which is used in a running system.


Threats
-------

T.DISCLOSURE
    An attacker reads an asset of which the property confidentiality shall be
    preserved.

T.MODIFICATION
    An attacker modifies an asset of which the property integrity shall be
    maintained.

T.UNAUTHORIZED_ACCESS
    A subject may gain access to resources or system security management
    functions for which it is not authorized according to the :term:`PACV`.

T.ADMIN_ERROR
    An administrator may incorrectly install or configure the system (including
    the misapplication of the protections afforded by the :term:`PACV`) or
    install a corrupted system resulting in ineffective security mechanisms.

T.CONFIGURATION_INTEGRITY
    The system may be placed in a configuration not consistent with the
    configuration vector due to improper loading or incorrect use of the
    configuration vector during the system initialization.

T.COVERT_CHANNEL_EXPLOIT
    An unauthorized information flow may occur between partitions as a result
    of covert channel exploitation.

T.DENIAL_OF_SERVICE
    A attacker may block others from system resources (e.g., system
    memory, persistent storage, and processing time) via a resource exhaustion
    attack.

T.INCORRECT_CONFIG
    The configuration vectors are not an accurate and complete description of
    the operational configuration of the system as used by an organization.

T.INSECURE_STATE
    The system may be placed in an insecure state due to an erroneous
    initialization, halt, reconfiguration or restart, transition to maintenance
    mode, or an unsuccessful recovery from a system failure or discontinuity.

T.POOR_DESIGN
    Unintentional or intentional errors in requirements specification, design,
    or implementation of the system may occur, leading to flaws that may be
    exploited by an attacker.


Assumptions
-----------

A.PHYSICAL
    It is assumed that the non-IT environment provides the system with
    appropriate physical security commensurate with the value of the IT assets
    protected by the system.

A.RESOURCE_ALLOCATION
    It is assumed that a properly trained trusted individual will create
    configuration vectors that allocate resources to partitions such that it
    is possible to establish an access control policy over these resources
    (i.e., :term:`PACV`).

A.TRUSTED_INDIVIDUAL
    It is assumed that any individual allowed to perform procedures upon which
    the security of the system may depend is trusted with assurance
    commensurate with the value of the IT assets.

A.HARDWARE
    The underlying hardware, firmware and bootloader needed by the system
    to guarantee secure operation provide the necessary properties, are working
    correctly and have no undocumented or unintended security critical side
    effect on the system functions.

