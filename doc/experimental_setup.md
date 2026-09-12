# Experimental Setup

## 1. Overview

This document describes the hardware design, verification, formal verification, and synthesis environment used for the cryptographic S-box architecture study.

The objective is to ensure that the results can be interpreted in the context of the exact tools, constraints, and target technology used during experimentation.

---

# 2. Hardware Description Language

| Parameter             | Configuration |
| --------------------- | ------------- |
| HDL                   | SystemVerilog |
| RTL Type              | Combinational |
| Number of RTL Designs | 15            |
| AES Width             | 8 → 8         |
| PRESENT Width         | 4 → 4         |
| Ascon Width           | 5 → 5         |

---

# 3. Simulation Environment

RTL simulation was performed using AMD/Xilinx Vivado.

| Parameter         | Value                           |
| ----------------- | ------------------------------- |
| Tool              | AMD/Xilinx Vivado               |
| Version           | `[ENTER VERSION]`               |
| Simulator         | `[ENTER SIMULATOR]`             |
| Language          | SystemVerilog                   |
| Testbench         | `[ENTER TESTBENCH INFORMATION]` |
| Verification Type | `[Exhaustive / Vector-based]`   |

---

# 4. Simulation Configuration

The simulation environment consists of:

```text
Testbench
    |
    v
Input Stimulus
    |
    v
DUT
    |
    v
Output
    |
    v
Expected-value Comparison
```

The input-space sizes are:

| Cipher  | Input Width | Input Combinations |
| ------- | ----------: | -----------------: |
| AES     |           8 |                256 |
| PRESENT |           4 |                 16 |
| Ascon   |           5 |                 32 |

Where exhaustive verification was performed, all possible input combinations were evaluated.

---

# 5. Synopsys Formality Environment

Logic Equivalence Checking was performed using Synopsys Formality.

| Parameter             | Value                                         |
| --------------------- | --------------------------------------------- |
| Tool                  | Synopsys Formality                            |
| Version               | `[ENTER VERSION]`                             |
| Verification Type     | Logic Equivalence Checking                    |
| Reference Design      | `[ENTER]`                                     |
| Implementation Design | `[ENTER]`                                     |
| Technology Library    | `[ENTER LIBRARY NAME — NO PROPRIETARY FILES]` |

The Formality environment was used to establish functional equivalence between reference and implementation designs.

---

# 6. VC Formal Environment

Additional formal verification was performed using Synopsys VC Formal.

| Parameter                      | Value              |
| ------------------------------ | ------------------ |
| Tool                           | Synopsys VC Formal |
| Version                        | `[ENTER VERSION]`  |
| Cross-Architecture Equivalence | Yes                |
| Bijectivity Checking           | `[Yes/No]`         |
| Specification Conformance      | Yes                |
| Netlist Equivalence            | Yes                |

The formal environment was configured according to the corresponding verification objective.

---

# 7. Design Compiler Environment

Synthesis and PPA analysis were performed using Synopsys Design Compiler.

| Parameter                  | Value                    |
| -------------------------- | ------------------------ |
| Tool                       | Synopsys Design Compiler |
| Version                    | `[ENTER VERSION]`        |
| Target Technology          | `[ENTER]`                |
| Standard-Cell Library      | `[ENTER]`                |
| Operating Condition        | `[ENTER]`                |
| Wire-Load / Physical Model | `[ENTER]`                |
| Optimization Mode          | `[ENTER]`                |

---

# 8. Synthesis Constraints

The following constraints were applied consistently across the compared implementations.

| Constraint          | Value     |
| ------------------- | --------- |
| Clock Period        | `[ENTER]` |
| Clock Uncertainty   | `[ENTER]` |
| Input Delay         | `[ENTER]` |
| Output Delay        | `[ENTER]` |
| Input Transition    | `[ENTER]` |
| Output Load         | `[ENTER]` |
| Clock Frequency     | `[ENTER]` |
| Operating Condition | `[ENTER]` |

If the S-box was synthesized as a purely combinational block without a clock, document the exact timing constraint methodology used instead.

---

# 9. PPA Metrics

The following metrics were collected from synthesis:

### Area

The synthesized area is used to compare hardware resource requirements.

### Timing

Timing analysis is used to evaluate the critical path and delay characteristics of each implementation.

### Power

Power analysis is included where the configured synthesis flow provides a meaningful power estimate.

The reported PPA values must always be interpreted together with the synthesis technology, constraints, operating conditions, and tool version.

---

# 10. Directory Structure

The experimental environment is represented in the repository as:

```text
scripts/
├── vivado/
│   └── run_simulation.tcl
│
├── formality/
│   └── run_lec.tcl
│
├── vcformal/
│   ├── run_cross_architecture.tcl
│   ├── run_bijectivity.tcl
│   ├── run_spec_conformance.tcl
│   └── run_netlist_equivalence.tcl
│
└── dc/
    └── run_synthesis.tcl
```

Modify the filenames to match the actual scripts included in the repository.

---

# 11. Reproducibility Procedure

A user with access to the required EDA tools can reproduce the experiment using the following high-level flow:

```text
1. Clone repository
        |
        v
2. Review RTL
        |
        v
3. Run Vivado simulation
        |
        v
4. Run Formality LEC
        |
        v
5. Run VC Formal checks
        |
        v
6. Run Design Compiler synthesis
        |
        v
7. Collect PPA reports
        |
        v
8. Compare results
```

---

# 12. Commercial Tool and Library Disclaimer

The repository does not distribute commercial EDA software, proprietary technology libraries, foundry PDK files, or licensed standard-cell databases.

Users must provide their own licensed installation and technology files when reproducing the synthesis and formal verification experiments.

The repository provides the RTL, verification methodology, properties, constraints, scripts, and summarized results that are legally appropriate for redistribution.

---

# 13. Environment Summary

The complete environment can be summarized as:

| Stage      | Tool                     | Purpose                               |
| ---------- | ------------------------ | ------------------------------------- |
| RTL Design | SystemVerilog            | Hardware implementation               |
| Simulation | Vivado                   | Functional verification               |
| LEC        | Synopsys Formality       | Logic equivalence                     |
| Formal     | VC Formal                | Equivalence and property verification |
| Synthesis  | Synopsys Design Compiler | Logic synthesis                       |
| PPA        | Design Compiler reports  | Area/timing/power analysis            |

---

# 14. Reproducibility Note

Exact results may vary if the following parameters differ:

* EDA tool version
* Standard-cell library
* Technology node
* Synthesis constraints
* Operating conditions
* Optimization settings
* Power estimation methodology

Therefore, all reported PPA results in this repository should be interpreted together with the experimental configuration documented above.
