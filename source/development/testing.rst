Testing
=======
The primary goal of the Bao Test Framework is to provide the infrastructure for the testing process
of Bao Project components. It encompasses three core components: (i) a C library designed for
real-time test handling, (ii) a build system based on Nix, and (iii) a Python Tool for
comprehensive test management.

1. **C Library** - This library that streamlines testing by providing macros, pre-processed logging
   prompts, and an entry-point-based system, aiming to facilitating the integration of developer
   tests in the software stack, such as the hypervisor or guest components.

2. **Nix Build System** - The Nix Build System introduces an abstraction layer for system builds,
   facilitating a modular construction of the software stack for comprehensive testing. It
   encompasses a series of nix recipes that allow the compilation and build of three distinct
   layers: (i) the hypervisor, (ii) multiple guests (e.g., baremetal, freeRTOS, etc.), and (iii)
   the firmware.

3. **Python Tool** - A command line tool that drives the framework by managing both the Nix Build
   System and the C code library components to build testing artifacts, automating their deployment
   in the target platform, and gathering, analyzing and outputting the final results.

Test Framework Overview
-----------------------

Practical Guide
---------------

Directory Structure
*******************

Test Configuration File
***********************

Tests Definition
****************

How to Use
**********


For Advanced Users
------------------


Extending Framework Tests
-------------------------

Contribute to Tests Repository
******************************


Examples
--------
