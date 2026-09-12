# crypto-sbox-rtl-formal-verification
Multi-architecture RTL implementation and verification of AES, PRESENT, and Ascon S-boxes using LUT, AIG/Boolean, and ANF representations, with simulation, LEC, cross-architecture equivalence, bijectivity, specification conformance, netlist equivalence, and PPA analysis.
## Overview

This project presents a comparative hardware implementation and verification study of cryptographic substitution boxes (S-boxes) used in AES, PRESENT, and Ascon.

Five cryptographic substitution functions were implemented using three different hardware representation strategies:

1. LUT-based implementation
2. AIG/Boolean-based implementation
3. ANF-based implementation

The resulting architecture space consists of 15 RTL implementations. Each implementation was functionally verified using RTL simulation, formally verified using multiple equivalence and security-oriented properties, and synthesized for physical design metrics.

The verification flow combines:

* RTL simulation using AMD/Xilinx Vivado
* Logic Equivalence Checking (LEC) using Synopsys Formality
* Cross-Architecture Equivalence Checking using VC Formal
* Bijectivity verification
* Specification Conformance Checking
* Netlist Equivalence Checking
* RTL synthesis and PPA analysis using Synopsys Design Compiler

The objective is to evaluate how different Boolean representations of cryptographic S-boxes affect implementation characteristics while maintaining functional correctness and cryptographic properties.

## Motivation

Cryptographic substitution functions are fundamental nonlinear components in modern symmetric-key cryptographic hardware. Their implementation can significantly influence area, timing, power consumption, verification complexity, and resistance to implementation-related faults.

Different hardware representations of the same Boolean function can result in substantially different synthesized structures. A truth-table/LUT implementation, an AND-Inverter Graph (AIG) or Boolean implementation, and an Algebraic Normal Form (ANF) implementation expose different optimization opportunities to synthesis tools.

This project therefore investigates the same cryptographic functionality across multiple hardware architectures rather than evaluating a single RTL implementation.

The study combines architecture exploration with simulation, formal verification, and synthesis-based PPA analysis to establish a reproducible methodology for comparing cryptographic RTL implementations.

| Cipher  | Function      | Width | LUT | AIG/Boolean | ANF |
| ------- | ------------- | ----: | --: | ----------: | --: |
| AES     | S-box         | 8 → 8 |   ✓ |          ✓ |   ✓ |
| AES     | Inverse S-box | 8 → 8 |   ✓ |          ✓ |   ✓ |
| PRESENT | S-box         | 4 → 4 |   ✓ |          ✓ |   ✓ |
| PRESENT | Inverse S-box | 4 → 4 |   ✓ |          ✓ |   ✓ |
| Ascon   | S-box         | 5 → 5 |   ✓ |          ✓ |   ✓ |
