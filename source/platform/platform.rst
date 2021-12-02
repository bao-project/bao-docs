.. _platform:

Bao Platform Isolation Profiles
#######################


Platforms Overview
***************************************

The platform specification currently identifies three main vectors aiming at 
guaranteeing strong temporal and spatial isolation among the existing system
components:

#. Platform Hardware Isolation Primitives: Hardware building blocks available 
on the CPU and on the overall platform that can be leveraged to guarantee 
isolation of memory accesses (spatial isolation) of diferent software 
components. For example, Memory Managment Unit (MMU), Memory Protection Unit 
(MPU), security-oriented technhologies (e.g., TrustZone) and hardware 
controllers.

#. Platform (uArch) Shared Resources: Platform-wide resources that can be 
(unintentionally) shared by multiple partitions (and virtual machines). These
resources can mainly impact the temporal isolation guarantees.

#. Platform Interrupt Facilities: Platform-wide interrupt facilities that need
to be shared by multiple partitions. The interrupt controller is a key 
component that can impact both temporal and spatial isolation. 


Platform Hardware Isolation Primitives
***************************************

To provide spatial isolation (memory) among the diferent software components, 
Bao partitioner and VMMs can leverage multiple

#. **Virtualization extensions**. Hardware virtualization support. At the CPU 
level, includes an additional privilege mode and set of registers. For example, 
Arm virtualization extensions (VE) for the Armv7-A and the RISC-V Hypervisor
extension.

#. **Security state**: (TrustZone-A, TrustZone-M)

#. **MMU**: 

#. **MPU**: 

#. **IOMMU**: (sMMUv1, sMMUv2, sMMUv3)

#. **IOMPU**: 

#. **Platform Memory Controller**: (PMP, TZASC, RDC, xRDC, XMPU)

#. **Platform Peripheral Controller**: (TZPC, XPPU)

The hardware isolation primitives (HIP) can be identified by a code ...

HIP-00000[0-Z]


.. list-table:: Platform hardware isolation primitives definition
   :widths: 25 25 25 25 25 25 25
   :header-rows: 1

   * - 
     - Virtualization
     - Security state
     - MMU
     - MPU
     - IOMMU
     - IOMPU
     - PMC
     - PPC
   * - 0
     - none
     - none
     - none
     - none
     - none
     - none
   * - 1
     - Armv7-A VE
     - none
     - none
     - none
     - none
   * - 2
     - none
     - none
     - none
     - none
     - none
     - none


Platform (uArch) Shared Resources
***************************************

#. **L1-Cache**: (D, I, D+I, unified)

#. **L2-Cache**: (D, I, D+I, unified)

#. 




Platform Interrupt Facilities
***************************************

#. **Interrupt Controller**:

#. **Interrupts number**:



Platform Examples
***************************************

Zynq UltraScale+ MPSoC ZCU104 Evaluation Kit
====================

