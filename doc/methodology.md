# Experimental Methodology

## 1. Overview

This project performs a comparative hardware implementation study of cryptographic substitution functions from AES, PRESENT, and Ascon.

The methodology was designed to isolate the effect of RTL implementation representation while keeping the underlying cryptographic functionality unchanged.

Five functional designs were selected and implemented using three architecture styles:

* LUT-based
* AIG/Boolean-based
* ANF-based

This resulted in 15 RTL implementations.

Each implementation was passed through a common verification and synthesis flow.

---

# 2. Experimental Objective

The primary objective is to evaluate the relationship between:

$$
\text{Cryptographic Function}
\rightarrow
\text{Boolean Representation}
\rightarrow
\text{RTL}
\rightarrow
\text{Verification}
\rightarrow
\text{Synthesis}
\rightarrow
\text{PPA}
$$

The study investigates whether different representations of the same cryptographic function produce different implementation characteristics after synthesis.

---

# 3. Design Space

The design space consists of:

### Cryptographic functions

* AES S-box
* AES inverse S-box
* PRESENT S-box
* PRESENT inverse S-box
* Ascon S-box

### RTL architectures

* LUT
* AIG/Boolean
* ANF

Therefore:

$$
5\times3=15
$$

RTL implementations were evaluated.

---

# 4. Reference Specification

Each RTL implementation is derived from the corresponding cryptographic S-box specification.

The reference mapping defines:

$$
Y=S(X)
$$

where \(X\) is the input and \(Y\) is the expected output.

The reference specification is maintained independently of the implementation architecture so that alternative RTL descriptions can be compared against the same functional target.

---

# 5. Architecture Generation

For each cryptographic function, three representations were generated.

```text
             Reference S-box
                    |
        +-----------+-----------+
        |           |           |
        v           v           v
       LUT         AIG         ANF
        |           |           |
        v           v           v
      RTL         RTL         RTL
```

The functional mapping remains constant while the internal Boolean representation changes.

---

# 6. RTL Development

All implementations are written as combinational SystemVerilog RTL.

The common interface principle is used where possible.

For example:

```text
AES:
Input  = 8 bits
Output = 8 bits

PRESENT:
Input  = 4 bits
Output = 4 bits

Ascon:
Input  = 5 bits
Output = 5 bits
```

A common interface makes the designs suitable for automated verification and cross-architecture comparison.

---

# 7. Simulation Methodology

RTL simulation is performed using Vivado.

For each design:

1. Compile the RTL.
2. Compile the testbench.
3. Apply input vectors.
4. Capture the RTL output.
5. Compare the output against the expected mapping.
6. Report mismatches.
7. Record the final PASS/FAIL status.

For small S-boxes, exhaustive input-space verification can be used.

The complete input spaces are:

$$
2^8=256
$$

for AES,

$$
2^4=16
$$

for PRESENT, and:

$$
2^5=32
$$

for Ascon.

---

# 8. Formality LEC Methodology

Synopsys Formality is used to perform Logic Equivalence Checking.

The general methodology is:

```text
Reference RTL
      |
      v
Reference Design
      |
      +----------+
                 |
                 v
             Formality
                 ^
                 |
      +----------+
      |
Implementation RTL
```

The formal engine attempts to prove:

$$
Y_{reference}(X)=Y_{implementation}(X)
$$

for all legal input combinations under the defined assumptions.

A successful proof is recorded as PASS.

---

# 9. Cross-Architecture Formal Methodology

VC Formal is used to compare alternative implementations of the same cryptographic function.

For each function:

```text
LUT
 |
 +-------- AIG
 |
 +-------- ANF
```

Pairwise equivalence checks are performed.

The architecture combinations are:

$$
LUT\leftrightarrow AIG
$$

$$
LUT\leftrightarrow ANF
$$

$$
AIG\leftrightarrow ANF
$$

This verifies that the architecture transformation does not alter the intended cryptographic function.

---

# 10. Cryptographic Property Verification

Selected cryptographic properties are checked independently of implementation style.

These include:

* Bijectivity where applicable
* Specification conformance
* Correct input/output mapping
* Inverse relationship for inverse S-boxes

For a bijective function:

$$
S(x_1)=S(x_2)
\Rightarrow
x_1=x_2
$$

For an inverse pair:

$$
S^{-1}(S(x))=x
$$

and:

$$
S(S^{-1}(x))=x
$$

These properties provide additional assurance beyond implementation-to-implementation equivalence.

---

# 11. Netlist Verification

After RTL verification, each design is synthesized.

The resulting gate-level netlist is then subjected to equivalence verification.

The flow is:

```text
Verified RTL
     |
     v
Design Compiler
     |
     v
Gate-Level Netlist
     |
     v
Netlist Equivalence
     |
     v
PASS / FAIL
```

This verifies that the synthesized implementation preserves the intended RTL behavior.

---

# 12. Synthesis Methodology

Synopsys Design Compiler is used for synthesis.

Each architecture is synthesized under a controlled and consistent environment.

The general synthesis process is:

```text
Read RTL
   |
   v
Elaborate
   |
   v
Apply Constraints
   |
   v
Compile / Optimize
   |
   v
Technology Mapping
   |
   v
Generate Reports
```

The following implementation metrics are collected:

* Area
* Timing
* Power, where available/configured

---

# 13. PPA Comparison

The PPA analysis compares architectures for the same cryptographic function.

For example:

```text
AES S-box
   |
   +---- LUT ----> Area / Timing / Power
   |
   +---- AIG ----> Area / Timing / Power
   |
   +---- ANF ----> Area / Timing / Power
```

This approach allows the implementation trade-offs of different representations to be evaluated under the same synthesis environment.

---

# 14. Controlled Experimental Variables

For a meaningful comparison, the following parameters should remain consistent across implementations wherever applicable:

* Target technology/library
* Synthesis tool version
* Clock constraints
* Input constraints
* Output constraints
* Operating conditions
* Optimization settings
* RTL interface
* Functional specification

The exact values are documented in `experimental_setup.md`.

---

# 15. Data Collection

The project collects results at three major stages:

### Simulation

```text
PASS / FAIL
```

### Formal

```text
LEC
Cross-Architecture Equivalence
Bijectivity
Specification Conformance
Netlist Equivalence
```

### Synthesis

```text
Area
Timing
Power
```

These results are consolidated into the `results/` directory.

---

# 16. Overall Methodology

The complete methodology is:

```text
                Cryptographic Specifications
                           |
                           v
                    5 S-box Functions
                           |
                           v
             +-------------+-------------+
             |             |             |
            LUT           AIG           ANF
             |             |             |
             +-------------+-------------+
                           |
                           v
                    15 RTL Designs
                           |
             +-------------+-------------+
             |             |             |
             v             v             v
         Simulation      Formal       Synthesis
          Vivado      FM + VC Formal      DC
             |             |             |
             |       +-----+------+      |
             |       |     |      |      |
             |      LEC   CAE   Properties|
             |             |      |       |
             |             |  +---+----+  |
             |             |  |        |  |
             |             | Bijective Spec.
             |             |          |
             |             |          |
             |             +----------+
             |                  |
             |                  v
             |          Verified Function
             |                  |
             |                  v
             |             Gate Netlist
             |                  |
             |                  v
             |          Netlist Equivalence
             |                  |
             +------------------+
                        |
                        v
                  PPA Comparison
                        |
                        v
                Architecture Trade-offs
```

---

# 17. Experimental Output

The final experiment produces:

1. 15 verified RTL implementations
2. Simulation results
3. Formal verification results
4. Synthesis reports
5. PPA comparison tables
6. Architecture-level observations

The results are documented separately in `results.md`.

---

# 18. Reproducibility

The repository is structured so that the RTL, verification properties, testbenches, synthesis constraints, and tool scripts can be reviewed and, where the required commercial EDA environment is available, rerun.

Commercial EDA software, proprietary technology libraries, and generated tool databases are not included in the repository.

The scripts provided in the repository describe the intended execution flow.

---

# 19. Methodology Summary

The methodology deliberately separates:

$$
\boxed{\text{Function}}
$$

from:

$$
\boxed{\text{Implementation Architecture}}
$$

and evaluates the resulting designs through:

$$
\boxed{
Simulation
+
Formal Verification
+
Synthesis
}
$$

This provides a systematic framework for studying cryptographic RTL architecture and implementation trade-offs.
