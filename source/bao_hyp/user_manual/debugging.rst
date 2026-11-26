Debugging
=========

Backtraces
----------

When a CPU stops on a fatal error, Bao can print the chain of calls that led to it. Build the
hypervisor with ``BACKTRACE=y`` to enable it:

.. code-block:: bash

    make PLATFORM=<platform> CONFIG=<config> BACKTRACE=y

The build then keeps frame pointers, and each CPU that stops prints one line per frame with the
return address of that call, starting at the innermost one:

.. code-block:: none

    BAO ERROR: <message>
    BAO BACKTRACE cpu0 #0: [<fd80000094d8>]
    BAO BACKTRACE cpu0 #1: [<fd80000094ec>]
    BAO BACKTRACE cpu0 #2: [<fd8000009524>]

Each line carries the CPU, since several CPUs can stop at the same time. The walk prints at most
``BACKTRACE_MAX_DEPTH`` frames (32 by default), which can be set on the command line as well.

``BACKTRACE`` does not depend on ``DEBUG`` and is supported on AArch64 and RISC-V. On any other
architecture a build with ``BACKTRACE=y`` stops with an error.

Resolving the addresses
***********************

Pass each address minus one to the ``addr2line`` of the toolchain used for the build, with the ELF
of the same build that printed the backtrace. A build without ``DEBUG=y`` strips ``bao.elf``, so
build with ``BACKTRACE=y DEBUG=y`` to resolve the addresses this way:

.. code-block:: bash

    aarch64-none-elf-addr2line -f -p -e bin/<platform>/<config>/bao.elf fd80000094d7 fd80000094eb

Minus one, because each address is a return address. A call that never returns, such as the one
that stops the CPU, can be the last instruction of its function, and its return address then
belongs to the next function.

.. note::

    On RISC-V every trap restarts at the top of the CPU stack. After a fault in the hypervisor
    itself, the frames of the code that faulted can be overwritten and the backtrace may end at
    the trap vector. ``sepc`` and ``ra`` in the register dump still point at the faulting function
    and its caller.
