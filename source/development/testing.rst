Testing
=======

*Introductory paragraph* (testing Framework on bao projects -> unit testing)
In order to tackle the challenge of testing new functionalities on the Bao hypervisor, we are actively working on the development of a comprehensive testing framework. The primary objective of this framework is to enable developers to conduct unit tests on various system components (such as the hypervisor, virtual machine (VM), and virtual machine monitor (VMM)), as well as assess interactions between different components/layers.

Test Framework
---------------

Overview
***********
Detail the workflow (both for class and new bao). Use the images made by 
Cristiano

Concepts
*********
Test vs Suite 

Explain the configs (dts). What to change/add, if anything. 

Nix recipes


Test Definition
***************

.. code-block:: c

    BAO_TEST(TEST_NAME, SUITE_NAME)


Asserts.

Directory Structure
*******************
Explain the directoy structure. Where the bao-tests repo should be, where the 
tests should be.

**SUGGESTION ON THE ORGANIZATION OF THE TESTS DIRECTORY**


How to use
***********
0- Requirements
sudo apt install .....

1- Repository

2- Modify makefiles

3- Codegen

4- Make command


Test Implementation
-------------------
Follow Contributing Guides and the testing guidelines:
-
-
-

