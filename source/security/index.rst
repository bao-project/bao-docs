Security Threat Model and Assumptions
=====================================

Threats
-------

T.DISCLOSURE
    An attacker reads an asset of which the property confidentiality shall be
    preserved.

T.MODIFICATION
    An attacker writes an asset of which the property integrity shall be
    maintained.

T.ADMIN_ERROR
    An administrator may incorrectly install or configure the TOE (including
    the misapplication of the protections afforded by the PIFP), or install a
    corrupted TOE resulting in ineffective security mechanisms.

T.CONFIGURATION_INTEGRITY
    The TOE may be placed in a configuration that is not consistent with that
    of the configuration vector due to the improper loading of the
    configuration vector or incorrect use of the configuration vector during
    TOE initialization.

T.COVERT_CHANNEL_EXPLOIT
    An unauthorized information flow may occur between partitions as a result
    of covert channel exploitation.

T.DENIAL_OF_SERVICE
    A malicious subject may block others from system resources (e.g., system
    memory, persistent storage, and processing time) via a resource exhaustion
    attack.

T.INCORRECT_CONFIG
    The configuration vectors are not an accurate and complete description of
    the operational configuration of the TOE as used by an organization.

T.INSECURE_STATE
    The TOE may be placed in an insecure state as a result of an erroneous
    initialization, halt, reconfiguration or restart, transition to maintenance
    mode, or as a result of an unsuccessful recovery from a system failure or
    discontinuity.

T.POOR_DESIGN
    Unintentional or intentional errors in requirements specification or design
    of the TOE may occur, leading to flaws that may be exploited by a malicious
    subject.

T.UNAUTHORIZED_ACCESS
    A subject may gain access to resources or TOE security management functions
    for which it is not authorized according to the TOE security policy.


Assumptions
-----------

A.PHYSICAL
    It is assumed that the non-IT environment provides the TOE with appropriate
    physical security commensurate with the value of the IT assets protected by
    the TOE.

A.SUBJECT_ALLOCATION
    It is assumed that a properly trained trusted individual will create
    configuration vectors such that, for those partitions to which subjects are
    allocated, each partition is allocated one or more subjects (i.e., subjects
    with homogeneous access requirements, or subjects with heterogeneous access
    requirements) that are appropriate for the policy abstraction supported by
    the TOE.

A.TRUSTED_INDIVIDUAL
    It is assumed that any individual allowed to perform procedures upon which
    the security of the TOE may depend is trusted with assurance commensurate
    with the value of the IT assets.

A.HARDWARE
    The underlying hardware, firmware and bootloader needed by BAO hypervisor
    to guarantee secure operation provide the necessary properties, are working
    correctly and have no undocumented or unintended security critical side
    effect on the functions of the TOE.


