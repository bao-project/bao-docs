Getting Started
===============

For getting started with the `Bao Hypervisor <https://github.com/bao-project>`_ we recommend
following the "Hello World" interactive tutorial.

The `bao-helloworld <https://github.com/bao-project/bao-helloworld>`_ repository provides a minimal
tutorial designed to guide beginners through the process of setting up and running the Bao
Hypervisor on QEMU platforms. It serves as a practical starting point for new users to understand
Bao’s workflow and development, including the configuration and deployment of different :term:`VM`
(i.e., Linux OS, FreeRTOS, and baremetal applications).

This guide walks through the steps required to reproduce the "Hello World" demo. It begins with
setting up a development environment, including the installation of all necessary dependencies and
cross-compile toolchain. The tutorial then covers building Bao and necessary platform-specific
firmware, i.e., Arm’s Trusted Firmware-A (TF-A) for ``aarch64`` targets and RISC-V’s OpenSBI for
``riscv64`` targets. Finally, you will configure and run different setups, such as single-guest and
dual-guest configurations, on QEMU platforms for both architectures.

Whether you are evaluating Bao for the first time or seeking a minimal, reproducible reference
environment for further development, this example offers a solid foundation.

You can find the complete tutorial and source code in the official repository at `bao-helloworld
<https://github.com/bao-project/bao-helloworld>`_. We also recommend watching the following video,
which provides a step-by-step walk-through of the tutorial:

.. raw:: html

    <div style="position: relative; width: 100%; height: 0; padding-bottom: 56.25%; margin: 20px 0;">
        <iframe
            style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
            src="https://www.youtube.com/embed/6c8_MG-OHYo?si=-jT3a9-2NkxxdnIT"
            title="YouTube video player"
            frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
            referrerpolicy="strict-origin-when-cross-origin"
            allowfullscreen>
        </iframe>
    </div>
