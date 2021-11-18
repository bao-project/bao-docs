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

#. MMU

#. Virtualization extensions (Arm-VE, RISC-V H-ext)

#. Security state (TrustZone)

#. Platform Memory Controller (PMP, TZASC, RDC, xRDC, XMPU)

#. Platform Peripheral Controller (TZPC, XPPU)

#. IOMMU (sMMUv1, sMMUv2, sMMUv3)


A-00000[0-F]


.. list-table:: A Platform - hardware isolation primitives definition
   :widths: 25 25 25 25 25 25 25
   :header-rows: 1

   * - 
     - MMU
     - Virtualization
     - Security state
     - PMC
     - PPC
     - IOMMU
   * - 0
     - none
     - none
     - none
     - none
     - none
     - none
   * - 1
     - standard
     - Arm-VE
     - TrustZone
     - TZASC
     - TZPC
     - sMMUv1
   * - 2
     - 
     - RISC-V H-ext
     - none
     - RDC
     - XPPU
     - sMMUv2


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

