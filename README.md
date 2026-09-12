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
