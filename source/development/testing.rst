Testing
=======

*Introductory paragraph* (testing Framework on bao projects -> unit testing)
In order to tackle the challenge of testing new functionalities on the Bao hypervisor, we are actively working on the development of a comprehensive testing framework. The primary objective of this framework is to enable developers to conduct unit tests on various system components (such as the hypervisor, virtual machine (VM), and virtual machine monitor (VMM)), as well as assess interactions between different components/layers.

Test Framework
---------------

Overview
***********

The test framework API is a Python tool that acts as the control center for the testing process. It performs the following tasks:

1. **Calling the build system**: The API interacts with the build system to compile and build the different components required to perform tests. It triggers the build process, which may involve compiling source code, linking libraries, and generating the necessary artifacts for testing.

2. **Generating the test setup**: Once the build process is complete, the API generates the necessary setup for running the tests. This includes setting up the test environment, configuring test data, and preparing any required dependencies.

3. **Calling the runner**: After the test setup is prepared, the API invokes the test runner. The test runner is responsible for executing the test cases and reporting the results.

4. **Logging the results**: As the tests are executed, the API captures and logs the test results. This typically includes information such as the test status (pass/fail) and any error messages.

.. image:: source\development\img\framework-overview.png

Overall, the test framework API serves as an intermediary between the build system, the test setup generation process, and the test runner. 
   
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

