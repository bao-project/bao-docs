.. _misra:

MISRA Compliance
================

The project aims to comply with the MISRA C:2012 coding guidelines in all C
code across all repositories. All submitted code will be checked for MISRA
violations following the :ref:`Guideline Enforcement Plan <misra_gep>` and the
:ref:`Guideline Requalification Plan <misra_gep>` using automated checker tools
in the :ref:`CI pipeline <ci>`. Developers should continuously check for MISRA
violations by :ref:`running the checker tools locally<misra_check_locally>` at
each commit. Any violation identified in the submitted code must be justifiable and
duly :ref:`deviated<deviations>`. These processes must be properly documented,
peer-reviewed, and authorized according to the project's :ref:`contribution
process <contributing>` and the guidance provided by the official `MISRA
Compliance:2020 document
<https://www.misra.org.uk/app/uploads/2021/06/MISRA-Compliance-2020.pdf>`_.

Every developer, reviewer, or maintainer should familiarize themselves with,
first and foremost, the guidelines themselves, and secondly, the processes
described in this document.

Each repository in the project might abide by the guidelines with varying
degrees of fidelity. Each will have its independent :ref:`MISRA
artefacts<misra_artefacts>`, although these might derive from the same base and
be easily migrated from one repository to another. The processes and artefacts
described in this document shall be overseen and enforced by the appointed
repository's :ref:`MISRA manager`.

The guidelines' text document is under strict licensing restrictions
and, therefore, the project cannot provide it to outside contributors. The
document can be licensed on a per-person basis at the official's `MISRA website
shop <https://www.misra.org.uk/shop/>`_.

.. _misra_gep:

Guideline Enforcement Plan (GEP) and Checker Tool
--------------------------------------------------

The Guideline Enforcement Plan (GEP) describes, for each MISRA guideline, what
are the checker tools or processes that are being used to enforce it. For each
tool, a specific version and configuration information must be specified. Each
process, such as manual review, shall provide instructions and
checklists to aid reviewers. Ideally, the GEP should also prescribe measures on
how to detect and deal with each :ref:`undecidable
guidelines<misra_undecidable_false_positive>`. :ref:`Each
repository<misra_artefacts>` must provide a GEP in a CSV format. The base GEP
is provided in the :ref:`CI repository <ci_repo>`.


The main tool used by the project to check for MISRA guideline violations is
`cppcheck <https://cppcheck.sourceforge.io/>`_. cppcheck is a completely free
and open-source static analysis tool that provides a python-based add-on
implementing the MISRA checks. The project's core team may use proprietary
tools to periodically scan the code for cppcheck false positives or negatives,
as well as providing an overall higher degree of confidence that the guidelines
are being followed. However, the use of these tools will not be available to
external contributors, and the output of such tools will not be openly
published.


.. _misra_grp:

Rule Categories and Guideline Requalification Plan (GRP)
------------------------------------------------------------

MISRA rules can be categorized as mandatory, required, or advisory. This
categorization defines whether or not a :ref:`deviation<deviations>` is allowed
and, in case it is, if a :ref:`deviation record or permit<deviation_records>`
is required:

* **Mandatory**: a deviation is never allowed;

* **Required**: deviations are allowed, and a deviation record is required;

* **Advisory**: violations do not require a deviation record but must be at
  least identified.

Despite the `official guideline compliance document
<https://www.misra.org.uk/app/uploads/2021/06/MISRA-Compliance-2020.pdf>`_ not
requiring a deviation record for advisory guidelines, the project will require
that the identified violation points at least to a deviation permit. If a
deviation permit that covers the violation use case does not exist, a deviation
record must be supplied. Even when a permit for the violation use case exists,
the code reviewers, maintainers or :ref:`MISRA managers<_misra_manager>` might
choose to require a deviation record for a more intricate or convoluted
violation.

A project's Guideline Requalification Plan (GRP) might reclassify the rules in
the following manner:

    * mandatory rules cannot be recategorized;

    * required guidelines can be promoted to mandatory;

    * advisory guidelines might be promoted to required, mandatory, or, on
      the contrary, completely misapplied.

A project's GRP must start with the original category for every rule. Every
recategorization must:

    * provide a well-founded and discussed rationale, especially if it is
      misapplying a guideline;

    * review and update all previously existing deviations for the rule being
      recategorized:

        - if a rule is promoted to mandatory, all existing violations must be
          removed;

        - if a rule is promoted to required, a deviation record must be
          produced for all deviations;

        - if a rule is misapplied, all deviations as well as records or permits
          concerning the rule can be removed.

    * be approved by all the repository's MISRA managers, which must
      reconfigure the tools accordingly.

As described in :ref:`Repository MISRA Artefacts`, each repository must provide
a GEP in a CSV format, for which a baseline is provided in the :ref:`CI repository
<ci_repo>`.

.. _deviations:

Deviations
----------

All new :ref:`code submissions via a GitHub pull-requests <contributing>`, will
be subject to the automatic checking of MISRA compliance by the :ref:`CI
pipeline <ci>`. Ideally, the pull-request should not introduce any new MISRA
violations. Developers should always strive to follow the MISRA coding
guidelines. However, they may conclude that a violation is
unavoidable and justifiable according to at least one of the :ref:`deviation
reasons <deviation_reasons>`. If so, developers must document and request the
introduction of the violation in the code base, which will be subject to the
approval of a code reviewer. These approved violations are called deviations. To
introduce a deviation, a developer must follow the :ref:`deviation procedure
<deviation_procedure>` which include providing a :ref:`deviation record
<deviation_records>`, :ref:`annotate<deviation_annotations>` all violations,
and being explicitly approved by :ref:`MISRA managers<misra_manager>`.

.. _deviation_reasons:

Deviation Reasons
*****************

A deviation must not be just a convenience for the developer. Reasonable coding
alternatives that would avoid the deviation should always be considered. If
none is found, the developer may come to the conclusion that introducing a
violation is justifiable mainly due to the following reasons:

* **Code quality**. Not introducing the violation would impact code quality
  metrics such as the ones defined by Section 4.5 of ISO/IEC 25010. For
  example:

    - functionality suitability
    - security property guarantees (e.g. confidentiality, integrity)
    - reliability (e.g. robustness to input and fault tolerance)
    - readability (ease of understand and learning)
    - usability (ease of use, modification and extension)
    - maintainability (e.g. modularity, testability)
    - portability (e.g. across different architectures and platforms)
    - reusability (e.g. across different system configurations)

* **Performance and latency**. Not introducing the violation would result in a
  significant performance hit or latency/jitter increase, especially when it
  constitutes a bottleneck on a critical path.

* **Access to hardware**, i.e., using ISA or MMIO facilities. Not introducing
  the violation would inhibit the developer to perform an operation, to
  implement a given functionality or important bottleneck optimization as
  mentioned above.

* **Interface with external code or interfaces**. For example, when calling
  external library functions, using externally defined types or function
  prototypes. Note that, nevertheless, the adoption of any external code must
  be subject to the practices detailed in `MISRA Compliance:2020 documentation
  <https://www.misra.org.uk/app/uploads/2021/06/MISRA-Compliance-2020.pdf>`_
  and to the reviewing and approval process by maintainers and the :ref:`MISRA
  manager<_misra_manager>`.

* **Implementation or compliance of standards**. If it would preclude the
  developer from implementing, using, or following a standard or externally
  defined API.

.. _deviation_procedure:

Deviation Procedure
*******************

A developer should take the following steps when introducing a new MISRA
deviation:

    1. Check if the deviation falls under the scope of any of the existing
       :ref:`deviation permits<deviation_records>`;

    2. Create a new :ref:`deviation record<deviation_records>` in the
       :ref:`repository's misra deviation's directory<misra_artefacts>` named
       with next available ID. If matching deviation permits are found and the
       rule is `advisory<misra_grp>`, this step can be skipped. If the rule is
       `required<misra_grp>`, however, the record should point to the
       identified permits;

    3. Annotate all code locations related to the deviation using the formats
       described in :ref:`deviation_annotation`;

    4. :ref:`Re-run the MISRA checker tools<misra_check_locally>` to make sure
       the violations are not flagged anymore;

    5. Identify in the commit message that the deviation is being introduced.

When a pull-request introduces new violations, the reviewers must:

    * make sure the justification and rationale for the deviation provided by
      the record is indeed well-founded;

    * if any permits are used, if the violation meets all the permit's
      requirements;

    * possibly propose alternatives for the deviation, especially when these
      are required;

    * verify that all introduced deviations annotations are correctly tagged
      with the rule and record/permit;

    * notify at least one of the :ref:`MISRA managers<_misra_manager>` and wait
      for their final approval.

.. _deviation_annotation:

Deviation annotations
*********************

Deviation annotations are placed in comments preceding the code
incurring the violation. Their main role is to identify the code locations
related to a given deviation record or permit, as well as suppress violation
diagnostics issued by the checker tools. A deviation annotation follows a
single-line pre-defined format that contains the identifier of MISRA rule that
is being broken as well the deviation record/permit identifier. It follows the
base format :code:`HEADER:GUIDELINE:RECORD/PERMIT`. In its simplest format, it
will flag a deviation in the next line. For example, :code:`MISRADEV:R2.5:MDR2`
signals a violation of rule 2.5 in the following line, backed by deviation
record MDR2. However, to allow more flexible ranges of code, there are three
classes of deviation annotations, depending on the used header:

    * **single-line**: as described before, its the header is simply
      :code:`MISRADEV`. It should be placed in a line by itself to flag a
      violation in the following line;

      .. code-block:: C

        /* MISRADEV:R2.5:MDR2 */

    * **range**: allows to flag a range of code for a violation. It encompasses
      two annotations: an annotation  before the ranged being flagged using the
      :code:`MISRADEVSTART` header, and another at the end of the target range
      with the header :code:`MISRADEVEND`. The :code:`GUIDELINE:RECORD/PEMIT`
      tag in both annotations must match. Beware using these annotation might
      result in :ref:`stale deviations<stale_deviations>`. Also, they might
      introduce new violations for the same rule that might not fall under the
      same record/permit scope.

      .. code-block:: C

        /* MISRADEVSTART:R2.5:MDR2 */ ... /* MISRADEVEND:R2.5:MDR2 */

    * **file-wide**: flag a violation in a file, where the violation can be in
      any line of the line. It uses the header :code:`MISRADEVFILE`. These
      should be used sparingly.

      .. code-block:: c

        /* MISRADEVFILE:R2.5:MDR2 */


.. _stale_deviations:

Managing Stale Deviations
*************************

It is important to ensure the deviation records, and more specifically,
annotations are up-to-date, that is, truly flagging an existing annotation and
not an old, already gone one. Otherwise, the code might become infested with
stale annotations, making it difficult to discern what annotations are flagging
an active violation. More importantly, a stale annotation must not be hiding
a new violation for which a record or permit does not exist.

Although some checker tools might be able to flag when a stale
annotation appears, code developers, reviewers, and maintainers must always be
attentive. If a modification changes or removes code that is under the effect
of a deviation annotation, the same code submission should remove the
deviation's annotations, and if no other mentions of the deviation exist, the
associated deviation records.

:ref:`Cppcheck<misra_gep>` does have the capability of detecting stale
deviations. However, it only allows us to suppress violations on either a
single-line or file-wide basis. The aforementioned :ref:`range
annotations<deviation_annotation>` are translated to multiple single-line
suppressions, and must be paired with a suppression for the "unmatched
suppression" warning itself. Therefore, these type of annotations might more
easily result in stale deviations.

.. _deviation_records:

Deviation Records and Permits
*****************************

A deviation record is a document that describes a deviation and justifies why
it is being taken. It should mainly address why the deviation is needed and
cannot be avoided by citing at least one valid :ref:`deviation reason
<deviation_reasons>`. It should also explain why the deviation is still safe in
light of the violated guideline's rationale. It must be written in a yaml file
following the format:

.. code-block:: yaml

    # MISRA deviation record template

    ---

    # The tag should always be the same name of the file, start with MDR
    followed # by the record ID. tag: MDR1

    # Optionally, list a deviation permits used as a base for the deviation.
    permits:
      - "MDP1"
      - "MPD2"

    # List the guidelines that are being violated. guidelines:
      - "R2.5"
      - "D4.4"

    # Summarize the violation and its context. Optional if a permit is
    selected. use_case: >
        This describes the records use case.

    # List one or more of the allowed justification items. Optional if a permit
    is # selected. reasons:
      - Code quality (usability).
      - ....

    # Detail the use cases and reasons listed above. description: >
        Provide a detailed description of the record.

    # Assess how the risks described in the guideline's rationale affect this
    violation # and describe how they are managed or mitigated in this
    violation. In case a # permit is selected, detail point by point how the
    deviation fulfils the # permit's requirements. risk: >
        The violation is safe because... It fulfilled the permits requirements
        since...

Deviation permits main purpose is to speed-up and reduce the effort of the
deviation procedure, by avoiding the duplication of deviation records for
frequently occurred deviation classes with similar rationales, and,
consequently, save time during the review process. Therefore, a deviation
permit provides a baseline for deviation records by describing a justification
for a class of deviations. A deviation permit must enumerate the use case and
requirements that must be met for a violation and described by a deviation record
to be supported by the permit. Permits must follow this ``yaml`` template:

.. code-block:: yaml

    # MISRA deviation permit template ---

    # The tag should always be the same name of the file, start with MDP
    followed # by the permit ID. tag: MDP1

    # List the guidelines that are being violated guidelines:
      - "R2.5"
      - "R11.4"

    # Summarize the use case(s) under which the permit may be used to support #
    a violation. use_case: >
        Describe the permit's use cases.

    # List one or more of the allowed justification items. reasons:
      - Code quality (usability).
      - ....

    # Detail the use cases and reasons listed above. background: >
        Provide a detailed description of the guideline,

    # Explicitly list the requirements a violation/deviation must fulfill to #
    properly assess and manage all the possible risks raised by the violation #
    that are described in the guideline's rationale. If multiple guidelines are
    # encompassed by the permit, specify which requirements need to be meet
    when # violation each guideline. requirements:
        - The deviation must...
        - ...

When writing a deviation record that fits a pre-existing deviation permit, a
developer only needs to identify the deviation permit and justify why the
deviation meets the permit requirements. The reviewer's job is also verifying
the justifications for meeting the permit's requirements are valid, with no
need to make sure the justification itself is valid. When this is the case, the
deviation can be accepted without the explicit acknowledgement of the
:ref:`MISRA managers<_misra_manager>`.

Whenever reviewers or maintainers identify that a relatively significant group
of existing deviations have a common ground cause and justification, or if they
predict that a guideline will be frequently deviated for a given use-case, they
should submit the proposal for the introduction of a new MISRA permit to the
repository MISRA manager.

Dealing with Pre-existing Violations
------------------------------------

Pre-existing violations might be encountered in the existing code and not
necessarily be introduced by a new pull-request. This might happen, for
example, whenever the checker tools are updated or reconfigured.

When pre-existing violations are detected, the repository maintainer is
responsible for either modify the code to remove the violations or introduce
new deviations following the :ref:`deviation procedure<deviation_procedure>`.

False Positive Diagnostics
--------------------------

A checker tool may wrongly identify a rule violation. These are called false
positive diagnostics. If a contributor by itself, or during a discussion in the
reviewing process, concludes that one of the checker tools is issuing a false
positive, they should notify the :ref:`MISRA managers<_misra_manager>` who
shall issue a bug ticket with the checker provider or developers. Meanwhile,
the false positive can be tagged with a special deviation annotation with the
format :code:`MISRAFP:RULE:` while waiting for the issue to be solved by the
tool providers, and remove it as soon as the issue is fixed. For example:

    .. code-block:: c

      /* MISRAFP:R2.5: */

.. _misra_undecidable_false_positive:

Undecidable Guidelines and False Negative Diagnostics
-----------------------------------------------------

Developers, reviewers, and maintainers must be aware that the checker tools
might not flag violations. This might happen because the guideline is
undecidable or because the tool fails to detect the violation in a
specific scenario. When a violation is detected by manual inspection, it should
follow the normal :ref:`deviation procedure<deviation_procedure>`. If the
guideline is decidable, the issue should be communicated to the :ref:`MISRA
managers<_misra_manager>` who shall forward it to the tool's providers.

.. _misra_artefacts:

Repository MISRA Artefacts
--------------------------

Each repository subject to MISRA compliance check shall have a
dedicated ``misra`` directory at the top level. The ``misra`` directory shall contain:

    * the :ref:`GEP<misra_gep>` in CSV format
    * the :ref:`GRP<misra_grp>` in CSV format
    * a deviations sub-directory, containing a file for each :ref:`deviation
      records<deviations>` in yaml format
    * a permits sub-directory, containing a file for each :ref:`deviation
      permit<deviations>` in yaml format

Templates for all these documents are provided in the ``misra`` directory of the
:ref:`CI repository <ci_repo>`.

.. _misra_manager:

MISRA managers
--------------

On top of the roles described in :ref:`ci`, every repository shall be assigned
at least one MISRA manager responsible for enforcing the processes
described in this document and guaranteeing the `MISRA compliance best practices
<https://www.misra.org.uk/app/uploads/2021/06/MISRA-Compliance-2020.pdf>`_ are
being followed as best as possible. Therefore, they will have the ultimate say
in the decisions taken regarding the guidelines. Their responsibilities
include, but are not limited to:

    * enforce the processes described in this document;

    * making sure the GEP and GRP are being correctly applied;

    * modifications and updates to the GEP and/or GRP;

    * explicitly approving deviations, specifically records or permits;

    * verify the tools are correctly configured accordingly to the GEP;

    * report any errors detected in the checkers to the tool's providers.

.. _misra_check_locally:


Running the MISRA Checker Locally
---------------------------------

Every project shall instantiate the :ref:`CI<ci_repo>` :code:`misra-check` Make
rule that takes care of running all the necessary MISRA checks. For example,
for checking compliance for the *qemu-aarch64-virt* platform:

  .. code-block:: shell

    make PLATFORM=qemu-aarch64-virt misra-check

It is suggested to use the provided :ref:`Docker container image <docker>` for
running the checks; otherwise, you will first have to :ref:`setup all the
necessary tools locally<local_environment>`.
