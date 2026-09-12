# Experimental Results

## 1. Overview

This document presents the functional verification, formal verification, and synthesis results obtained from the 15 cryptographic S-box RTL implementations.

The results are organized into three major categories:

1. Functional verification
2. Formal verification
3. PPA analysis

The objective is to compare the three implementation architectures:

* LUT
* AIG/Boolean
* ANF

while maintaining the same underlying cryptographic functionality.

---

# 2. Design Space

The experiment evaluates:

$$
5\text{ functional designs}\times3\text{ architectures}=15\text{ RTL implementations}
$$

| Cipher  | Functional Design | LUT | AIG/Boolean | ANF |
| ------- | ----------------- | :-: | :---------: | :-: |
| AES     | S-box             |  ✓  |      ✓      |  ✓  |
| AES     | Inverse S-box     |  ✓  |      ✓      |  ✓  |
| PRESENT | S-box             |  ✓  |      ✓      |  ✓  |
| PRESENT | Inverse S-box     |  ✓  |      ✓      |  ✓  |
| Ascon   | S-box             |  ✓  |      ✓      |  ✓  |

---

# 3. Simulation Results

RTL simulation was performed using Vivado.

The simulation results should be summarized as:

| Design             | Architecture | Test Cases | Passed | Failed | Result    |
| ------------------ | ------------ | ---------: | -----: | -----: | --------- |
| AES S-box          | LUT          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| AES S-box          | AIG          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| AES S-box          | ANF          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| AES Inv. S-box     | LUT          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| AES Inv. S-box     | AIG          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| AES Inv. S-box     | ANF          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| PRESENT S-box      | LUT          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| PRESENT S-box      | AIG          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| PRESENT S-box      | ANF          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| PRESENT Inv. S-box | LUT          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| PRESENT Inv. S-box | AIG          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| PRESENT Inv. S-box | ANF          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| Ascon S-box        | LUT          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| Ascon S-box        | AIG          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |
| Ascon S-box        | ANF          |      `[ ]` |  `[ ]` |  `[ ]` | PASS/FAIL |

---

# 4. Formality LEC Results

Synopsys Formality was used for Logic Equivalence Checking.

The LEC results are summarized below.

| Design                | Reference     | Implementation     |   Result  |
| --------------------- | ------------- | ------------------ | :-------: |
| AES S-box             | `[REFERENCE]` | `[IMPLEMENTATION]` | PASS/FAIL |
| AES Inverse S-box     | `[REFERENCE]` | `[IMPLEMENTATION]` | PASS/FAIL |
| PRESENT S-box         | `[REFERENCE]` | `[IMPLEMENTATION]` | PASS/FAIL |
| PRESENT Inverse S-box | `[REFERENCE]` | `[IMPLEMENTATION]` | PASS/FAIL |
| Ascon S-box           | `[REFERENCE]` | `[IMPLEMENTATION]` | PASS/FAIL |

Where multiple LEC runs were performed, the complete reports are stored in:

```text
results/formal/
```

---

# 5. Cross-Architecture Equivalence Results

The cross-architecture checks compare alternative implementations of the same cryptographic function.

| Functional Design     | LUT ↔ AIG | LUT ↔ ANF | AIG ↔ ANF |
| --------------------- | :-------: | :-------: | :-------: |
| AES S-box             | PASS/FAIL | PASS/FAIL | PASS/FAIL |
| AES Inverse S-box     | PASS/FAIL | PASS/FAIL | PASS/FAIL |
| PRESENT S-box         | PASS/FAIL | PASS/FAIL | PASS/FAIL |
| PRESENT Inverse S-box | PASS/FAIL | PASS/FAIL | PASS/FAIL |
| Ascon S-box           | PASS/FAIL | PASS/FAIL | PASS/FAIL |

A successful result indicates that the compared architectures implement the same external functional transformation under the formal comparison assumptions.

---

# 6. Bijectivity Results

Bijectivity was evaluated for the applicable cryptographic substitution functions.

| Function              | Architecture |    Bijectivity Result   |
| --------------------- | ------------ | :---------------------: |
| AES S-box             | LUT          |        PASS/FAIL        |
| AES S-box             | AIG          |        PASS/FAIL        |
| AES S-box             | ANF          |        PASS/FAIL        |
| AES Inverse S-box     | LUT          |        PASS/FAIL        |
| AES Inverse S-box     | AIG          |        PASS/FAIL        |
| AES Inverse S-box     | ANF          |        PASS/FAIL        |
| PRESENT S-box         | LUT          |        PASS/FAIL        |
| PRESENT S-box         | AIG          |        PASS/FAIL        |
| PRESENT S-box         | ANF          |        PASS/FAIL        |
| PRESENT Inverse S-box | LUT          |        PASS/FAIL        |
| PRESENT Inverse S-box | AIG          |        PASS/FAIL        |
| PRESENT Inverse S-box | ANF          |        PASS/FAIL        |
| Ascon S-box           | LUT          | N/A / `[ACTUAL RESULT]` |
| Ascon S-box           | AIG          | N/A / `[ACTUAL RESULT]` |
| Ascon S-box           | ANF          | N/A / `[ACTUAL RESULT]` |

---

# 7. Specification Conformance Results

The specification conformance checks verify that the implementation satisfies the intended cryptographic mapping.

| Design                | Architecture | Specification Conformance |
| --------------------- | ------------ | :-----------------------: |
| AES S-box             | LUT          |         PASS/FAIL         |
| AES S-box             | AIG          |         PASS/FAIL         |
| AES S-box             | ANF          |         PASS/FAIL         |
| AES Inverse S-box     | LUT          |         PASS/FAIL         |
| AES Inverse S-box     | AIG          |         PASS/FAIL         |
| AES Inverse S-box     | ANF          |         PASS/FAIL         |
| PRESENT S-box         | LUT          |         PASS/FAIL         |
| PRESENT S-box         | AIG          |         PASS/FAIL         |
| PRESENT S-box         | ANF          |         PASS/FAIL         |
| PRESENT Inverse S-box | LUT          |         PASS/FAIL         |
| PRESENT Inverse S-box | AIG          |         PASS/FAIL         |
| PRESENT Inverse S-box | ANF          |         PASS/FAIL         |
| Ascon S-box           | LUT          |         PASS/FAIL         |
| Ascon S-box           | AIG          |         PASS/FAIL         |
| Ascon S-box           | ANF          |         PASS/FAIL         |

---

# 8. Netlist Equivalence Results

After synthesis, the generated gate-level netlists were checked against the corresponding RTL implementations.

| Design                | Architecture | RTL ↔ Netlist |
| --------------------- | ------------ | :-----------: |
| AES S-box             | LUT          |   PASS/FAIL   |
| AES S-box             | AIG          |   PASS/FAIL   |
| AES S-box             | ANF          |   PASS/FAIL   |
| AES Inverse S-box     | LUT          |   PASS/FAIL   |
| AES Inverse S-box     | AIG          |   PASS/FAIL   |
| AES Inverse S-box     | ANF          |   PASS/FAIL   |
| PRESENT S-box         | LUT          |   PASS/FAIL   |
| PRESENT S-box         | AIG          |   PASS/FAIL   |
| PRESENT S-box         | ANF          |   PASS/FAIL   |
| PRESENT Inverse S-box | LUT          |   PASS/FAIL   |
| PRESENT Inverse S-box | AIG          |   PASS/FAIL   |
| PRESENT Inverse S-box | ANF          |   PASS/FAIL   |
| Ascon S-box           | LUT          |   PASS/FAIL   |
| Ascon S-box           | AIG          |   PASS/FAIL   |
| Ascon S-box           | ANF          |   PASS/FAIL   |

---

# 9. PPA Results

Synopsys Design Compiler was used to synthesize the 15 implementations.

The following table should contain the values extracted directly from the DC reports.

| Cipher  | Function | Architecture |  Area | Delay | Power |
| ------- | -------- | ------------ | ----: | ----: | ----: |
| AES     | S-box    | LUT          | `[ ]` | `[ ]` | `[ ]` |
| AES     | S-box    | AIG          | `[ ]` | `[ ]` | `[ ]` |
| AES     | S-box    | ANF          | `[ ]` | `[ ]` | `[ ]` |
| AES     | Inverse  | LUT          | `[ ]` | `[ ]` | `[ ]` |
| AES     | Inverse  | AIG          | `[ ]` | `[ ]` | `[ ]` |
| AES     | Inverse  | ANF          | `[ ]` | `[ ]` | `[ ]` |
| PRESENT | S-box    | LUT          | `[ ]` | `[ ]` | `[ ]` |
| PRESENT | S-box    | AIG          | `[ ]` | `[ ]` | `[ ]` |
| PRESENT | S-box    | ANF          | `[ ]` | `[ ]` | `[ ]` |
| PRESENT | Inverse  | LUT          | `[ ]` | `[ ]` | `[ ]` |
| PRESENT | Inverse  | AIG          | `[ ]` | `[ ]` | `[ ]` |
| PRESENT | Inverse  | ANF          | `[ ]` | `[ ]` | `[ ]` |
| Ascon   | S-box    | LUT          | `[ ]` | `[ ]` | `[ ]` |
| Ascon   | S-box    | AIG          | `[ ]` | `[ ]` | `[ ]` |
| Ascon   | S-box    | ANF          | `[ ]` | `[ ]` | `[ ]` |

---

# 10. Architecture-Level PPA Comparison

For each cryptographic function, the three implementations should be compared independently.

For example:

### AES S-box

| Metric |   LUT | AIG/Boolean |   ANF | Best  |
| ------ | ----: | ----------: | ----: | ----- |
| Area   | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Delay  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Power  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |

### AES Inverse S-box

| Metric |   LUT | AIG/Boolean |   ANF | Best  |
| ------ | ----: | ----------: | ----: | ----- |
| Area   | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Delay  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Power  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |

### PRESENT S-box

| Metric |   LUT | AIG/Boolean |   ANF | Best  |
| ------ | ----: | ----------: | ----: | ----- |
| Area   | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Delay  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Power  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |

### PRESENT Inverse S-box

| Metric |   LUT | AIG/Boolean |   ANF | Best  |
| ------ | ----: | ----------: | ----: | ----- |
| Area   | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Delay  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Power  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |

### Ascon S-box

| Metric |   LUT | AIG/Boolean |   ANF | Best  |
| ------ | ----: | ----------: | ----: | ----- |
| Area   | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Delay  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |
| Power  | `[ ]` |       `[ ]` | `[ ]` | `[ ]` |

---

# 11. Normalized PPA Comparison

To make architecture comparisons easier, normalized metrics can also be reported.

For a metric \(M\):

$$
M_{normalized}=
\frac{M_i}{M_{reference}}
$$

For example, if LUT is selected as the baseline:

$$
Area_{norm}=
\frac{Area_{architecture}}{Area_{LUT}}
$$

This allows relative comparisons independent of the absolute numerical scale.

---

# 12. Verification Summary

The overall verification summary should be presented as:

| Verification Stage             | Purpose                            |       Result      |
| ------------------------------ | ---------------------------------- | :---------------: |
| RTL Simulation                 | Functional behavior                |   `[PASS/FAIL]`   |
| Formality LEC                  | Implementation equivalence         |   `[PASS/FAIL]`   |
| Cross-Architecture Equivalence | LUT/AIG/ANF equivalence            |   `[PASS/FAIL]`   |
| Bijectivity                    | Cryptographic permutation property | `[PASS/FAIL/N/A]` |
| Specification Conformance      | Specification compliance           |   `[PASS/FAIL]`   |
| Netlist Equivalence            | RTL-to-netlist preservation        |   `[PASS/FAIL]`   |

---

# 13. Key Findings

The final observations should be derived directly from the measured data.

Examples of findings that may be reported, depending on the actual results, include:

* Which architecture achieved the lowest area for each S-box.
* Which architecture achieved the shortest critical path.
* Which representation resulted in the lowest estimated power.
* Whether the same architecture was consistently optimal across AES, PRESENT, and Ascon.
* Whether architecture ranking changed between different cryptographic functions.
* Whether formal equivalence successfully established equivalence among all architecture variants.
* Whether synthesis optimization reduced the structural differences between RTL representations.

Do not claim that one architecture is universally superior unless the experimental results support that conclusion.

---

# 14. Architecture Trade-Off Analysis

The results should ultimately be interpreted as a trade-off rather than a single ranking.

For example:

```text
                 Architecture Selection
                         |
          +--------------+--------------+
          |              |              |
       Area          Timing           Power
          |              |              |
          +--------------+--------------+
                         |
                         v
                  Design Objective
                         |
              +----------+----------+
              |                     |
        Area-constrained       Performance-
           design              constrained design
```

An architecture that minimizes area may not necessarily minimize timing or power.

Therefore, the appropriate implementation depends on the target design requirements.

---

# 15. Final Result Interpretation

The experiment establishes a structured comparison between alternative Boolean representations of cryptographic S-boxes.

The overall evaluation can be summarized as:

$$
\boxed{
\text{Same Cryptographic Function}
+
\text{Different RTL Representation}
\rightarrow
\text{Different Implementation Characteristics}
}
$$

while formal verification establishes:

$$
\boxed{
S_{LUT}(X)
=
S_{AIG}(X)
=
S_{ANF}(X)
}
$$

for the corresponding cryptographic function under the verification assumptions.

The resulting PPA measurements provide an empirical basis for selecting an implementation architecture for a particular hardware target.

---

# 16. Conclusion

This study demonstrates a complete RTL-to-synthesis evaluation methodology for cryptographic substitution functions.

A total of 15 RTL implementations were evaluated across three implementation architectures and three cryptographic primitives.

The combination of simulation, formal verification, and PPA analysis provides three complementary perspectives:

```text
Simulation
    |
    v
Does it behave correctly?

Formal Verification
    |
    v
Can correctness and selected properties be formally established?

Synthesis / PPA
    |
    v
What are the hardware implementation trade-offs?
```

The final results provide an architecture-level comparison of LUT, AIG/Boolean, and ANF representations for cryptographic S-box hardware implementations.
