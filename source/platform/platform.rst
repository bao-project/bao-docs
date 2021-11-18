.. _platform:

Bao Platform Isolation Profiles
#######################


Platforms Overview
***************************************

The platform specification currently identifies three main vectors aiming at 
guaranteeing strong temporal and spatial isolation among the existing system
components:

#. Platform Hardware Isolation Primitives: TBD

#. Platform (uArch) Shared Resources: TBD

#. Platform Interrupt Facilities: TBD


Platform Hardware Isolation Primitives
***************************************

To provide spatial isolation (memory) among the ... Bao can leverage multiple

#. **Virtualization extensions**. Hardware virtualization support. At the CPU 
level, includes an additional privilege mode and set of registers. For example, 
Arm virtualization extensions (VE) for the Armv7-A and the RISC-V Hypervisor
extension.

#. **Security state**: (TrustZone)

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

#. TBD


Platform Interrupt Facilities
***************************************

#. TBD


Platform Examples
***************************************

Zynq UltraScale+ MPSoC ZCU104 Evaluation Kit
====================

