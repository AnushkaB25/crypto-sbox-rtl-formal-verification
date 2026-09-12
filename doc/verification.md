# Verification Methodology

## 1. Overview

Verification is a central component of this project. Since the objective is to compare multiple hardware representations of cryptographic substitution functions, functional correctness must be established independently of the selected RTL architecture.

A layered verification methodology was therefore developed for the 15 RTL implementations.

The verification flow consists of:

1. RTL simulation using AMD/Xilinx Vivado
2. Logic Equivalence Checking (LEC) using Synopsys Formality
3. Cross-Architecture Equivalence Checking using VC Formal
4. Bijectivity Checking
5. Specification Conformance Checking
6. Netlist Equivalence Checking

The overall verification methodology is:

```text
                    Cryptographic Specification
                              |
                              v
                       Reference Function
                              |
                              v
                     +--------+--------+
                     |                 |
                     v                 v
                RTL Simulation      Formal Verification
                   Vivado          FM + VC Formal
                     |                 |
                     |       +---------+---------+
                     |       |         |         |
                     |      LEC        CAE     Properties
                     |                 |         |
                     |                 |    +----+---------+
                     |                 |    |              |
                     |                 | Bijectivity   Specification
                     |                 |              Conformance
                     |                 |
                     |                 v
                     |          Formal Results
                     |                 |
                     +--------+--------+
                              |
                              v
                       Verified RTL Design
                              |
                              v
                       Logic Synthesis
                              |
                              v
                         Gate Netlist
                              |
                              v
                    Netlist Equivalence Check
```

---

# 2. Verification Objectives

The verification methodology is designed to answer several independent questions.

| Verification Question                                               | Verification Method            |
| ------------------------------------------------------------------- | ------------------------------ |
| Does the RTL produce the expected S-box output?                     | RTL Simulation                 |
| Are two implementations functionally identical?                     | Logic Equivalence Checking     |
| Are different architecture representations equivalent?              | Cross-Architecture Equivalence |
| Is the S-box bijective where required?                              | Bijectivity Checking           |
| Does the implementation conform to the cryptographic specification? | Specification Conformance      |
| Does synthesis preserve the RTL functionality?                      | Netlist Equivalence            |

This separation is important because passing simulation alone does not establish all of these properties.

---

# 3. Verification Scope

The verification environment covers the following functional designs:

| Design                | Width | Simulation | Formal Verification |
| --------------------- | ----: | :--------: | :-----------------: |
| AES S-box             | 8 → 8 |      ✓     |          ✓          |
| AES Inverse S-box     | 8 → 8 |      ✓     |          ✓          |
| PRESENT S-box         | 4 → 4 |      ✓     |          ✓          |
| PRESENT Inverse S-box | 4 → 4 |      ✓     |          ✓          |
| Ascon S-box           | 5 → 5 |      ✓     |          ✓          |

Each function is implemented using:

* LUT-based RTL
* AIG/Boolean-based RTL
* ANF-based RTL

Therefore, the verification environment covers all 15 implementations.

---

# 4. RTL Simulation Verification

## 4.1 Purpose

RTL simulation provides the first level of functional verification.

The purpose is to verify that the RTL implementation produces the expected cryptographic output for applied input vectors.

The simulation flow is:

```text
Testbench
    |
    v
Input Vector
    |
    v
RTL S-box
    |
    v
Actual Output
    |
    +------------------+
                       |
                       v
                Expected Output
                       |
                       v
                 Comparison
                       |
                 +-----+-----+
                 |           |
                PASS        FAIL
```

---

## 4.2 Simulation Tool

RTL simulation was performed using:

**AMD/Xilinx Vivado**

The testbenches apply known input combinations and compare the RTL output against the expected cryptographic mapping.

---

## 4.3 Input-Space Coverage

The input-space sizes are:

| Function              | Input Width | Number of Inputs |
| --------------------- | ----------: | ---------------: |
| AES S-box             |      8 bits |              256 |
| AES Inverse S-box     |      8 bits |              256 |
| PRESENT S-box         |      4 bits |               16 |
| PRESENT Inverse S-box |      4 bits |               16 |
| Ascon S-box           |      5 bits |               32 |

For these small substitution functions, exhaustive enumeration of the complete input space is practical.

Where exhaustive testing was used, every possible input combination was applied to the RTL implementation.

---

# 5. Logic Equivalence Checking

## 5.1 Purpose

Logic Equivalence Checking (LEC) is used to formally determine whether two hardware implementations produce equivalent outputs for corresponding inputs.

Synopsys Formality was used for LEC.

The conceptual flow is:

```text
                  Reference Design
                         |
                         |
                         v
                +------------------+
                |                  |
                |    Formality     |
                |                  |
                | Equivalence      |
                |     Engine       |
                |                  |
                +------------------+
                         ^
                         |
                         |
                  Implementation
```

The equivalence relationship can be expressed as:

$$
Y_{ref}(X)=Y_{impl}(X)
$$

for all valid inputs \(X\) under the comparison assumptions.

---

# 6. Cross-Architecture Equivalence Checking

## 6.1 Purpose

Cross-Architecture Equivalence Checking is used to determine whether different RTL representations of the same cryptographic function implement identical input/output behavior.

For example:

```text
                  AES S-box
                      |
          +-----------+-----------+
          |           |           |
          v           v           v
         LUT         AIG          ANF
          |           |           |
          +-----------+-----------+
                      |
                      v
             Cross-Architecture
                 Equivalence
```

The expected relationships are:

$$
S_{LUT}(X)=S_{AIG}(X)
$$

$$
S_{LUT}(X)=S_{ANF}(X)
$$

and:

$$
S_{AIG}(X)=S_{ANF}(X)
$$

The same methodology is applied independently to AES, PRESENT, and Ascon.

---

# 7. Cross-Architecture Comparison Matrix

The formal comparisons can be represented as:

| Function              |  LUT ↔ AIG  |  LUT ↔ ANF  |  AIG ↔ ANF  |
| --------------------- | :---------: | :---------: | :---------: |
| AES S-box             | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] |
| AES Inverse S-box     | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] |
| PRESENT S-box         | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] |
| PRESENT Inverse S-box | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] |
| Ascon S-box           | [PASS/FAIL] | [PASS/FAIL] | [PASS/FAIL] |

Replace the placeholders with the actual VC Formal results.

---

# 8. Bijectivity Checking

## 8.1 Purpose

Bijectivity is an important functional property for substitution functions that must be invertible.

For a function:

$$
S:\{0,1\}^{n}\rightarrow\{0,1\}^{n}
$$

bijectivity requires that every input maps to a unique output.

Equivalently:

$$
S(x_1)=S(x_2)
\Rightarrow
x_1=x_2
$$

A bijective S-box therefore has exactly:

$$
2^n
$$

distinct output values.

---

## 8.2 AES

The AES S-box is bijective.

Therefore:

$$
|\mathrm{Range}(S_{AES})|=256
$$

and the inverse mapping exists.

The formal verification environment checks the corresponding uniqueness/invertibility property.

---

## 8.3 PRESENT

The PRESENT S-box is also bijective.

For its 4-bit input space:

$$
|\mathrm{Range}(S_{PRESENT})|=16
$$

The inverse S-box therefore provides the reverse mapping.

---

## 8.4 Ascon

The Ascon substitution mapping is a 5-bit vectorial substitution function used within the Ascon permutation.

It should be verified according to the actual property and specification being targeted in the formal environment rather than automatically assuming an AES/PRESENT-style inverse S-box requirement.

The repository documents the exact property used in the formal verification setup.

---

# 9. Specification Conformance Checking

Specification Conformance Checking verifies that an implementation satisfies the intended cryptographic specification rather than merely matching another implementation.

The conceptual flow is:

```text
              Cryptographic Specification
                         |
                         v
                  Expected Function
                         |
                         v
                  Formal Property
                         |
                         v
                   RTL Design
                         |
                         v
                    PASS / FAIL
```

This distinction is important.

There are two different questions:

### Implementation Equivalence

```text
Does Design A equal Design B?
```

### Specification Conformance

```text
Does Design A implement the required cryptographic function?
```

Both are useful, but they provide different forms of assurance.

---

# 10. Netlist Equivalence Checking

## 10.1 Purpose

After synthesis, the RTL is transformed into a technology-mapped gate-level netlist.

Netlist Equivalence Checking verifies that the synthesized implementation preserves the intended RTL functionality.

The flow is:

```text
                  RTL
                   |
                   v
              Synthesis
                   |
                   v
            Gate-Level Netlist
                   |
                   v
          Netlist Equivalence
                   |
             +-----+-----+
             |           |
            PASS        FAIL
```

The expected equivalence relationship is:

$$
RTL(X)=Netlist(X)
$$

under the specified synthesis and formal assumptions.

---

# 11. Formal Verification Hierarchy

The complete formal verification strategy can therefore be viewed as:

```text
                         Formal Verification
                                  |
             +--------------------+--------------------+
             |                    |                    |
            LEC              Cross-Architecture    Properties
             |                    |                    |
       Implementation       LUT ↔ AIG ↔ ANF       +---+--------+
       Equivalence                                  |            |
                                               Bijectivity    Specification
                                                              Conformance
                                  |
                                  v
                         Netlist Equivalence
```

This provides multiple verification perspectives rather than relying on a single checking mechanism.

---

# 12. Verification Result Summary

The final verification results should be summarized in a single table.

| Design             | Architecture | Simulation | LEC | Cross-Architecture | Bijectivity | Spec. Conformance | Netlist Equivalence |
| ------------------ | ------------ | :--------: | :-: | :----------------: | :---------: | :---------------: | :-----------------: |
| AES S-box          | LUT          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| AES S-box          | AIG          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| AES S-box          | ANF          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| AES Inv. S-box     | LUT          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| AES Inv. S-box     | AIG          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| AES Inv. S-box     | ANF          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| PRESENT S-box      | LUT          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| PRESENT S-box      | AIG          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| PRESENT S-box      | ANF          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| PRESENT Inv. S-box | LUT          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| PRESENT Inv. S-box | AIG          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| PRESENT Inv. S-box | ANF          |     [ ]    | [ ] |         [ ]        |     [ ]     |        [ ]        |         [ ]         |
| Ascon S-box        | LUT          |     [ ]    | [ ] |         [ ]        |  N/A / [ ]  |        [ ]        |         [ ]         |
| Ascon S-box        | AIG          |     [ ]    | [ ] |         [ ]        |  N/A / [ ]  |        [ ]        |         [ ]         |
| Ascon S-box        | ANF          |     [ ]    | [ ] |         [ ]        |  N/A / [ ]  |        [ ]        |         [ ]         |

---

# 13. Verification Philosophy

The verification strategy follows a layered approach:

$$
\boxed{
Simulation
\rightarrow
Equivalence
\rightarrow
Cryptographic Properties
\rightarrow
Specification
\rightarrow
Netlist
}
$$

Simulation provides practical functional validation.

Formal equivalence provides exhaustive mathematical comparison between implementations.

Property checking verifies selected cryptographic characteristics.

Specification conformance establishes correspondence with the intended function.

Netlist equivalence verifies preservation of functionality through synthesis.

Together, these stages provide a stronger verification methodology for cryptographic RTL than simulation-only validation.
