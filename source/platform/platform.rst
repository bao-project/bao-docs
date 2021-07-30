.. _platform:

Bao Platform Definition
#######################

The platform specification defines (tbd) ... hardware primitives available for isolation ... 


Platforms Overview
***************************************

The platform specification currently defines two platforms:

#. A platform: This specifies a platform capable of running rich OS such as Linux, powered by an application processor.

#. M platform: This specifies a platform capable of running RTOS and baremetal Apps, powered by a microcontroller.

#. R platform: This specifies a platform capable of running RTOS and baremetal Apps, powered by a real-time processor.


A Platform
***************************************

#. MMU

#. Virtualization extensions (Arm-VE, RISC-V H-ext)

#. Security state (TrustZone)

#. Platform Memory Controller (PMP, TZASC, RDC, xRDC, XMPU)

#. Platform Peripheral Controller (TZPC, XPPU)

#. IOMMU (sMMUv1, sMMUv2, sMMUv3)

#. ...

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


Platform Definition Examples
====================

#. Zynq UltraScale+ MPSoC ZCU104 Evaluation Kit

