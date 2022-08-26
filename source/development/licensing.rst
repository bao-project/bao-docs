.. _licensing:

Licensing
=========

Our software is provided under the
`Apache 2.0 license <https://www.apache.org/licenses/LICENSE-2.0>`_, a
permissive open source license. As a developer, all you need to know regarding
your rights is described in this license. Before contributing, please read the
license to fully understand all the terms.

Apache 2.0 Summary
------------------

With Apache 2.0 license, a developer can do what they like with the software;
however, the required notices must be included in the code. In the following
list we describe succinctly some of the modalities regarding the license.
Beware that this is only a short summary of the license. You should read the
full text to fully capture it.

With Apache 2.0. a developer **can**...

* Use the software for commercial purposes
* Modify the software and create derivatives
* Distribute the original or modified software
* Use or modify the software freely without distributing it

With Apache 2.0. a developer **can't**...

* Hold liable the owner of this software for eventual charges derived from any
  damages
* Use any contributors' names, trademarks, or logos

With Apaches 2.0 a developer **must**...

* Include a copy of the license, copyright, and any NOTICE file notice with the
  software to be distributed
* Indicate that changes were made to the code



License and Copyright Notice
----------------------------

Any file contributed to this project must start with an header comment with the
following information:

* a copyright notice similar to the following:

.. code-block:: none

    Copyright (c)  <project-name> and contributors. All rights reserved.

* the SDPX identifier that tags the Apache 2.0 license, as shown below.

.. code-block:: none

    SPDX-License-Identifier: Apache-2.0

In the end, this header should be added as a comment on the top of each
individual file, according to the programming language the file is written.
In C language, the header would look like the example below.

.. code-block:: c

    /**
     * SPDX-License-Identifier: Apache-2.0
     * Copyright (c) Bao Project and Contributors. All rights reserved.
     */

.. _dco:

Developer Certification of Origin (DCO)
---------------------------------------

In the good faith of the open source spirit, we require that all contributors
agree to the DCO. The DCO should be link to each contributor commit message,
by simply adding a ``Signed-off-by`` statement that attests their agreement to
the DCO describe below.

.. code-block:: none

    Developer Certificate of Origin
    Version 1.1

    Copyright (C) 2004, 2006 The Linux Foundation and its contributors.

    Everyone is permitted to copy and distribute verbatim copies of this
    license document, but changing it is not allowed.


    Developer's Certificate of Origin 1.1

    By making a contribution to this project, I certify that:

    (a) The contribution was created in whole or in part by me and I
        have the right to submit it under the open source license
        indicated in the file; or

    (b) The contribution is based upon previous work that, to the best
        of my knowledge, is covered under an appropriate open source
        license and I have the right under that license to submit that
        work with modifications, whether created in whole or in part
        by me, under the same open source license (unless I am
        permitted to submit under a different license), as indicated
        in the file; or

    (c) The contribution was provided directly to me by some other
        person who certified (a), (b) or (c) and I have not modified
        it.

    (d) I understand and agree that this project and the contribution
        are public and that a record of the contribution (including all
        personal information I submit with it, including my sign-off) is
        maintained indefinitely and may be redistributed consistent with
        this project or the open source license(s) involved.

The process to sign-off the commit message is described step-by-step in the
commit :ref:`dco-sign-off` section of the :ref:`contributing` guides. Please
consult the full guide if you are planning to contribute to the project.
