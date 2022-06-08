.. _platform:

Platform Isolation Profiles
===========================


Platforms Overview
------------------

The platform specification currently identifies three main vectors aiming at 
guaranteeing strong temporal and spatial isolation among the existing system
components:

#. **Platform Hardware Isolation Primitives**: Hardware building blocks 
   available on the CPU and on the overall platform that can be leveraged to 
   guarantee isolation of memory accesses (spatial isolation) of diferent 
   software components. For example, Memory Managment Unit (MMU), Memory 
   Protection Unit (MPU), security-oriented technhologies (e.g., TrustZone) and 
   hardware controllers.

#. **Platform Quality of Service (QoS) Resources**: Platform-wide resources that 
   can be (intentionally or unintentionally) shared by multiple partitions (and 
   virtual machines). These resources can mainly impact the temporal isolation 
   guarantees.

#. **Platform Interrupt Facilities**: Platform-wide interrupt facilities that 
   need to be shared by multiple partitions. The interrupt controller is a key 
   component that can impact both temporal and spatial isolation. 


Platform Hardware Isolation Primitives
--------------------------------------

To provide spatial isolation (memory) among the diferent software components, 
Bao partitioner and VMMs can leverage multiple hardware primitives.

#. **Virtualization extensions**. Hardware virtualization support. At the CPU 
   level, includes an additional privilege mode and set of registers. For 
   example, Arm virtualization extensions (VE) for the Armv7-A/Armv8-A and the 
   RISC-V Hypervisor extension.

#. **Security state**: Security-oriented technologies. At the CPU level, 
   tipically includes an additional orthogonal execution state which replicates
   all privilege modes. For example, Arm TrustZone for the Armv7-A/Armv8-A and 
   TrustZone-M for the Armv8-M.

#. **MMU**: Memory managment unit. At the CPU level, provides translation of
   virtual memory addresses to physical addresses while enforcing access 
   permissions. MMU can have stage 1 translation and stage 2 translation (when
   hardware virtualization extensions are implemented). 

#. **MPU**: Memory protection unit. At the CPU level, provides memory protection
   by enforcing access permissions on the physical memory space. MPU can have a 
   Level 1 and Level 2 access control (when hardware virtualization extensions 
   are implemented). For example, the Arm MPU for Armv7-M/Armv8-M and the RISC-V 
   PMP provides Level 1 access control, while the Arm MPU for the Armv8-R 
   provides both Level 1 and Level 2 access control. 

#. **IOMMU**: Input-Output memory managment unit. At the platform level, is an 
   MMU that connects a DMA-capable I/O bus to the main memory. Similar to a 
   CPU MMU, the IOMMU maps device-visible virtual addresses to physical 
   addresses. For example, Arm sMMUv1, sMMUv2, and sMMUv3. 

#. **System Memory Protection Unit**: At the platform level, is a hardware unit / 
   controller that verifies if a specific system bus master is explicitly 
   allowed to access a memory address by assigning specific addresses ranges. 
   For example, Arm TZASC, NXP (x)RDC, and Xilinx XMPU.

#. **System Peripheral Protection Unit**: At the platform level, is a hardware 
   unit / controller that verifies if a specific system bus master is explicitly 
   allowed to access a peripheral. For example, Arm TZPC and Xilinx XPPU.

The hardware isolation primitives (HIP) can be identified by a unique code, 
i.e., HIP-0000000[0-Z], where each alphanumeric symbol (0-Z) identifies the 
availability of a specific hardware primitive in a given platform, according to 
the following table:



.. list-table:: Platform hardware isolation primitives definition
   :widths: 25 25 25 25 25 25 25 25
   :header-rows: 1

   * - 
     - Virtualization
     - Security state
     - MMU
     - MPU
     - IOMMU
     - SMPU
     - SPPU
   * - 0
     - none
     - none
     - none
     - none
     - none
     - none
     - none
   * - 1
     - Armv7-A VE
     - Armv7-A TZ
     - 1-Level
     - 1-Level
     - Arm MMU-400
     - TZASC-380
     - TZPC
   * - 2
     - Armv8-A VE
     - Armv8-A TZ
     - 2-Level
     - 2-Level
     - Arm MMU-401
     - TZASC-400
     - Xilinx XPPU
   * - 3
     - Armv8-R VE
     - Armv8-M TZ
     - *reserved*
     - *reserved*
     - Arm MMU-500
     - NXP RDC
     - *reserved*
   * - 4
     - RISC-V Hypervisor
     - *reserved*
     - *reserved*
     - *reserved*
     - Arm MMU-600
     - NXP xRDC
     - *reserved*
   * - 5
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - Xilinx XMPU
     - *reserved*
   * - 6
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
   * - 7
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
   * - 8
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*
     - *reserved*


Platform Quality of Service (QoS) Resources
-------------------------------------------

#. **L1-Cache**: (D, I, D+I, unified)

#. **L2-Cache**: (D, I, D+I, unified)

#. 




Platform Interrupt Facilities
-----------------------------

#. **Interrupt Controller**: Indicates the name and version of the interrupt
   controller available on the platform. For example, the Arm GIC-400.

#. **Interrupts number**: Indicates the number of physical interrupts available
   on the platform. For example, 1024 interrupts.

#. **Interrupt priority**: Indicates the maximum priority of the physical 
   interrupts available on the platform. For example, maximum priority of 256.

The platform interrupt facilities (IF) can be identified by a unique code, 
i.e., IF-0[0-Z]-00000[0-9]-0000[0-9], where each alphanumeric symbol (0-Z) 
identifies the specific hardware interrupt controller in a given platform, 
according to the table below. The remaining fields are numeric only, and 
corresponds to the exact number and priority of interrupts.

.. list-table:: Platform interrupt controller definition
   :widths: 25 25
   :header-rows: 1

   * - 
     - Interrupt Controller
   * - 0
     - Arm GIC-400
   * - 1
     - RISC-V PLIC
   * - 2
     - reserved
   * - 3
     - reserved
   * - 4
     - reserved
   * - 5
     - reserved




Platform Examples
-----------------

Zynq UltraScale+ MPSoC ZCU104 Evaluation Kit
********************************************

ZCU104 Hardware Isolation Primitives
####################################

.. list-table:: ZCU104 hardware isolation primitives mapping
   :widths: 25 25 25 25 25 25 25
   :header-rows: 1

   * - Virtualization
     - Security state
     - MMU
     - MPU
     - IOMMU
     - IOMPU
     - SPU
   * - [2] Armv8-A VE
     - [2] Armv8-A TZ
     - [3] 2-Level
     - [0] none
     - [3] Arm MMU-500
     - [5] Xilinx XMPU 
     - [2] Xilinx XPPU

