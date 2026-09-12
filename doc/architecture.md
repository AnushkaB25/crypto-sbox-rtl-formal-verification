# Cryptographic S-Box RTL Architecture

## 1. Introduction

This document describes the RTL architecture and implementation methodology used for the comparative evaluation of cryptographic S-boxes from AES, PRESENT, and Ascon.

The primary objective of this work is to investigate how different Boolean representations of cryptographic substitution functions affect hardware implementation characteristics.

Three implementation architectures were considered:

1. **LUT-based implementation**
2. **AIG / Boolean-based implementation**
3. **ANF-based implementation**

The selected cryptographic substitution functions were implemented using each of these architectures, resulting in a total of **15 RTL implementations**.

The implementations were subsequently subjected to simulation-based verification, formal verification, and synthesis-based PPA analysis.

The overall design methodology is:

```text
Cryptographic Specification
            |
            v
      S-Box Function
            |
     +------+------+------+
     |      |             |
     v      v             v
    LUT    AIG/Boolean    ANF
     |      |             |
     v      v             v
   RTL    RTL           RTL
     |      |             |
     +------+------+------+
            |
            v
     Functional Verification
            |
            v
       Formal Verification
            |
            v
       Logic Synthesis
            |
            v
       PPA Characterization
```

---

# 2. Cryptographic Functions Considered

The project considers substitution functions from three lightweight/standard cryptographic primitives:

* AES
* PRESENT
* Ascon

The S-boxes were selected because they form important nonlinear components of their respective cryptographic transformations.

The architecture study considers the following functional designs:

| ID | Cipher  | Function      | Input Width | Output Width | Inverse Available |
| -- | ------- | ------------- | ----------: | -----------: | ----------------- |
| D1 | AES     | S-box         |           8 |            8 | Yes               |
| D2 | AES     | Inverse S-box |           8 |            8 | Yes               |
| D3 | PRESENT | S-box         |           4 |            4 | Yes               |
| D4 | PRESENT | Inverse S-box |           4 |            4 | Yes               |
| D5 | Ascon   | S-box         |           5 |            5 | No                |

Each functional design was implemented using the three selected hardware representations.

Therefore:

$$
N_{implementations}=N_{functions}\times N_{architectures}
$$

$$
N_{implementations}=5\times3=15
$$

The resulting design space is shown below.

| Functional Design     | LUT-Based | AIG/Boolean-Based | ANF-Based |
| --------------------- | :-------: | :---------------: | :-------: |
| AES S-box             |     ✓     |         ✓         |     ✓     |
| AES Inverse S-box     |     ✓     |         ✓         |     ✓     |
| PRESENT S-box         |     ✓     |         ✓         |     ✓     |
| PRESENT Inverse S-box |     ✓     |         ✓         |     ✓     |
| Ascon S-box           |     ✓     |         ✓         |     ✓     |
| **Total**             |   **5**   |       **5**       |   **5**   |

---

# 3. Design Philosophy

The central design principle is to keep the cryptographic functionality constant while changing the underlying Boolean representation.

For a given S-box:

$$
Y=S(X)
$$

where:

* \(X\) is the input vector
* \(Y\) is the output vector
* \(S\) is the cryptographic substitution function

The same mapping is represented using:

```text
                  Same S-Box Function
                          |
          +---------------+---------------+
          |               |               |
          v               v               v
     LUT Representation  AIG/Boolean     ANF
          |               |               |
          v               v               v
        RTL             RTL             RTL
```

This allows the functional behavior to remain constant while implementation architecture changes.

Consequently, differences in synthesized area, timing, and power can be attributed to the selected implementation representation and the optimization performed by the synthesis flow.

---

# 4. Architecture 1 — LUT-Based Implementation

## 4.1 Concept

The LUT-based architecture directly represents the S-box as a lookup table.

The input vector is used as an index into a predefined mapping table, producing the corresponding output vector.

Conceptually:

```text
              Input X
                 |
                 v
        +------------------+
        |   Lookup Table   |
        |                  |
        |  X -> S(X)       |
        +------------------+
                 |
                 v
              Output Y
```

For an \(n\)-bit input:

$$
X\in\{0,1\}^{n}
$$

there are:

$$
2^n
$$

possible input combinations.

For the AES S-box:

$$
n=8
$$

therefore:

$$
2^8=256
$$

possible input combinations exist.

For PRESENT:

$$
n=4
$$

therefore:

$$
2^4=16
$$

possible input combinations exist.

For Ascon:

$$
n=5
$$

therefore:

$$
2^5=32
$$

possible input combinations exist.

---

## 4.2 RTL Representation

A LUT implementation can be represented in SystemVerilog using a combinational case statement, array-based lookup, or equivalent combinational construct.

A conceptual representation is:

```systemverilog
always_comb begin
    case (in)
        // cryptographic mapping
        ...
        default: out = '0;
    endcase
end
```

The actual implementation used in this project is located under:

```text
rtl/
├── aes/
├── present/
└── ascon/
```

with the LUT implementations organized under the corresponding `lut` directories.

---

## 4.3 Characteristics

The LUT representation provides a direct correspondence between the cryptographic specification and RTL.

Advantages include:

* Simple RTL description
* Direct representation of the truth table
* Easy functional debugging
* Straightforward exhaustive simulation
* Useful baseline architecture

The primary purpose of this implementation in the project is to provide a reference architecture against which alternative Boolean representations can be compared.

---

# 5. Architecture 2 — AIG / Boolean-Based Implementation

## 5.1 Concept

The second implementation strategy represents each S-box as a Boolean logic network.

The S-box output bits are expressed as Boolean functions of the input bits.

For example:

$$
Y_i=f_i(X_0,X_1,\ldots,X_{n-1})
$$

where each output bit \(Y_i\) is implemented using Boolean operations.

A conceptual architecture is:

```text
        X[n-1:0]
             |
      +------+------+
      |             |
      v             v
    AND/NOT       AND/NOT
      |             |
      +------+------+
             |
       Boolean Network
             |
             v
         Y[m-1:0]
```

---

## 5.2 AIG Representation

An And-Inverter Graph represents Boolean logic primarily using:

* AND operations
* Inverted/complemented signals

Conceptually:

```text
             X0 --------\
                          AND ----\
             X1 --------/         \
                                   AND ---- Y0
             X2 --------\         /
                          AND ----/
             X3 --------/
```

The actual network can contain multiple levels of Boolean decomposition.

The objective is not to reproduce the lookup table directly, but to express the same cryptographic mapping as a Boolean logic network.

---

## 5.3 Output Equations

For an \(m\)-bit output:

$$
Y=(Y_0,Y_1,\ldots,Y_{m-1})
$$

each output is represented as a Boolean function:

$$
Y_0=f_0(X)
$$

$$
Y_1=f_1(X)
$$

$$
\vdots
$$

$$
Y_{m-1}=f_{m-1}(X)
$$

The resulting Boolean equations are implemented as combinational RTL.

---

## 5.4 Characteristics

The AIG/Boolean architecture provides:

* Explicit Boolean logic representation
* Potentially reduced lookup-table structures
* Opportunities for Boolean optimization
* A structure suitable for logic synthesis
* A useful alternative to direct LUT representation

The synthesized implementation characteristics depend on the Boolean network structure and the synthesis tool's optimization algorithms.

---

# 6. Architecture 3 — ANF-Based Implementation

## 6.1 Concept

The third implementation uses the **Algebraic Normal Form (ANF)** representation of the cryptographic Boolean function.

ANF expresses Boolean functions using XOR and AND operations.

A Boolean function can be represented in the form:

$$
f(x_0,x_1,\ldots,x_{n-1})
=
c_0
\oplus
\bigoplus_i c_i x_i
\oplus
\bigoplus_{i<j} c_{ij}x_ix_j
\oplus
\cdots
$$

where:

* \(c_i\in\{0,1\}\)
* \(\oplus\) represents XOR
* multiplication represents Boolean AND

---

## 6.2 Conceptual Architecture

```text
Input Variables
      |
      +------------------+
      |                  |
      v                  v
     AND               AND
      |                  |
      +--------+---------+
               |
              XOR
               |
               v
            Output
```

For multiple output bits:

```text
             Input Bits
                 |
       +---------+---------+
       |         |         |
       v         v         v
     ANF Y0    ANF Y1    ANF Y2
       |         |         |
       v         v         v
      Y0        Y1        Y2
```

Each output bit is represented as an independent Boolean polynomial.

---

# 7. ANF Generation

For each S-box, the truth table can be transformed into an algebraic normal form.

For an \(n\)-input Boolean function:

$$
f:\{0,1\}^{n}\rightarrow\{0,1\}
$$

the ANF coefficients can be derived using Boolean/Möbius transformation techniques.

For an \(m\)-bit S-box:

$$
S:\{0,1\}^{n}\rightarrow\{0,1\}^{m}
$$

the transformation is applied independently to each output bit.

Thus:

$$
S(X)=
(Y_0,Y_1,\ldots,Y_{m-1})
$$

where:

$$
Y_i=ANF_i(X)
$$

for:

$$
i=0,\ldots,m-1
$$

---

# 8. Comparison of the Three Architectures

The three architectures implement the same cryptographic mapping but expose different internal structures.

| Characteristic                   | LUT             | AIG/Boolean     | ANF                |
| -------------------------------- | --------------- | --------------- | ------------------ |
| Primary representation           | Lookup mapping  | Boolean network | XOR/AND polynomial |
| Main operations                  | Table selection | AND/NOT         | XOR/AND            |
| RTL complexity                   | Low             | Medium/High     | Medium/High        |
| Direct truth-table mapping       | Yes             | No              | No                 |
| Boolean structure visible        | Limited         | High            | High               |
| Synthesis optimization potential | Tool dependent  | High            | High               |
| Formal equivalence               | Applicable      | Applicable      | Applicable         |
| PPA comparison                   | Applicable      | Applicable      | Applicable         |

The purpose of this comparison is not to assume that one architecture is universally superior, but to experimentally characterize the implementation trade-offs.

---

# 9. AES S-Box Architecture

## 9.1 Functional Description

The AES S-box is an 8-bit to 8-bit nonlinear substitution function.

It maps:

$$
S_{AES}:\{0,1\}^{8}\rightarrow\{0,1\}^{8}
$$

Therefore, there are:

$$
2^8=256
$$

possible input combinations.

The AES S-box is bijective and therefore has a corresponding inverse S-box.

---

## 9.2 AES S-Box Implementation

Three implementations are provided:

```text
AES S-box
   |
   +---- LUT
   |
   +---- AIG/Boolean
   |
   +---- ANF
```

Each implementation produces an 8-bit output from an 8-bit input.

```text
Input [7:0]
     |
     v
+----+-----------------------+
|    AES S-box Architecture  |
|                            |
| LUT / AIG / ANF            |
+----------------------------+
     |
     v
Output [7:0]
```

---

# 10. AES Inverse S-Box Architecture

The AES inverse S-box implements the inverse mapping:

$$
S^{-1}_{AES}:\{0,1\}^{8}\rightarrow\{0,1\}^{8}
$$

such that:

$$
S^{-1}_{AES}(S_{AES}(x))=x
$$

and:

$$
S_{AES}(S^{-1}_{AES}(x))=x
$$

The inverse S-box was implemented using the same three architecture styles:

```text
AES Inverse S-box
       |
       +---- LUT
       |
       +---- AIG/Boolean
       |
       +---- ANF
```

This provides three alternative hardware implementations of the same inverse cryptographic function.

---

# 11. PRESENT S-Box Architecture

The PRESENT S-box is a 4-bit to 4-bit substitution function:

$$
S_{PRESENT}:\{0,1\}^{4}\rightarrow\{0,1\}^{4}
$$

There are:

$$
2^4=16
$$

possible input combinations.

The small input domain makes the PRESENT S-box particularly suitable for exhaustive verification.

Three architectures were implemented:

```text
PRESENT S-box
      |
      +---- LUT
      |
      +---- AIG/Boolean
      |
      +---- ANF
```

---

# 12. PRESENT Inverse S-Box Architecture

The inverse PRESENT S-box implements:

$$
S^{-1}_{PRESENT}
$$

such that:

$$
S^{-1}_{PRESENT}(S_{PRESENT}(x))=x
$$

The inverse function was also implemented using:

* LUT representation
* AIG/Boolean representation
* ANF representation

This results in three additional RTL implementations.

---

# 13. Ascon S-Box Architecture

## 13.1 Functional Description

Ascon uses a 5-bit substitution mapping within its permutation.

The substitution function can be represented as:

$$
S_{Ascon}:\{0,1\}^{5}\rightarrow\{0,1\}^{5}
$$

The input space therefore contains:

$$
2^5=32
$$

possible input combinations.

---

## 13.2 Why There Is No Separate Inverse S-Box

Unlike AES and PRESENT, this project does not include a separate inverse S-box for Ascon.

The Ascon substitution layer is used as part of the Ascon permutation and is not treated as an AES/PRESENT-style standalone inverse S-box in this architecture study.

Therefore, the Ascon portion of the project contains one functional S-box design represented using the three implementation architectures:

```text
Ascon S-box
     |
     +---- LUT
     |
     +---- AIG/Boolean
     |
     +---- ANF
```

---

# 14. Complete Architecture Matrix

The complete architecture space explored by this project is:

```text
                         CRYPTOGRAPHIC FUNCTIONS
                                  |
             +--------------------+--------------------+
             |                    |                    |
            AES                PRESENT               Ascon
             |                    |                    |
        +----+----+          +----+----+               |
        |         |          |         |               |
       S-box     Inv.       S-box     Inv.           S-box
        |         |          |         |               |
        +----+----+          +----+----+               |
             |                    |                    |
             +--------------------+--------------------+
                                  |
                         5 FUNCTIONAL DESIGNS
                                  |
                  +---------------+---------------+
                  |               |               |
                 LUT             AIG             ANF
                  |               |               |
                  +---------------+---------------+
                                  |
                           15 RTL DESIGNS
```

---

# 15. RTL Module Organization

The RTL implementation is organized according to cipher and architecture.

Recommended repository structure:

```text
rtl/
│
├── aes/
│   ├── lut/
│   │   ├── aes_sbox_lut.sv
│   │   └── aes_inv_sbox_lut.sv
│   │
│   ├── aig/
│   │   ├── aes_sbox_aig.sv
│   │   └── aes_inv_sbox_aig.sv
│   │
│   └── anf/
│       ├── aes_sbox_anf.sv
│       └── aes_inv_sbox_anf.sv
│
├── present/
│   ├── lut/
│   │   ├── present_sbox_lut.sv
│   │   └── present_inv_sbox_lut.sv
│   │
│   ├── aig/
│   │   ├── present_sbox_aig.sv
│   │   └── present_inv_sbox_aig.sv
│   │
│   └── anf/
│       ├── present_sbox_anf.sv
│       └── present_inv_sbox_anf.sv
│
└── ascon/
    ├── lut/
    │   └── ascon_sbox_lut.sv
    │
    ├── aig/
    │   └── ascon_sbox_aig.sv
    │
    └── anf/
        └── ascon_sbox_anf.sv
```

The filenames should be modified to match the actual RTL modules in the repository.

---

# 16. Common RTL Interface

Where possible, all implementations of the same cryptographic function use a consistent module interface.

For example:

```systemverilog
module aes_sbox (
    input  logic [7:0] in,
    output logic [7:0] out
);
```

Similarly, PRESENT uses a 4-bit interface:

```systemverilog
module present_sbox (
    input  logic [3:0] in,
    output logic [3:0] out
);
```

and Ascon uses a 5-bit interface:

```systemverilog
module ascon_sbox (
    input  logic [4:0] in,
    output logic [4:0] out
);
```

A common interface simplifies:

* Testbench reuse
* Formal equivalence setup
* Cross-architecture comparison
* Automated simulation
* Synthesis scripting
* Result collection

---

# 17. Combinational Nature of the Designs

The S-box implementations in this study are combinational logic blocks.

The general data path is:

```text
Input
  |
  v
Combinational S-box Logic
  |
  v
Output
```

No sequential storage element is required for the basic S-box function.

Therefore:

$$
Y(t)=S(X(t))
$$

subject to the propagation delay of the synthesized combinational network.

This makes the designs suitable for studying:

* Logic depth
* Gate count
* Area
* Critical path delay
* Power
* Synthesis optimization
* Boolean representation trade-offs

---

# 18. Architecture-Level Equivalence

A key aspect of this project is that the three architectures for each cryptographic function are expected to implement the same mathematical mapping.

For AES:

$$
AES_{LUT}(x)
=
AES_{AIG}(x)
=
AES_{ANF}(x)
$$

for every valid input:

$$
x\in\{0,1\}^{8}
$$

Similarly, for PRESENT:

$$
PRESENT_{LUT}(x)
=
PRESENT_{AIG}(x)
=
PRESENT_{ANF}(x)
$$

for:

$$
x\in\{0,1\}^{4}
$$

and for Ascon:

$$
ASCON_{LUT}(x)
=
ASCON_{AIG}(x)
=
ASCON_{ANF}(x)
$$

for:

$$
x\in\{0,1\}^{5}
$$

These relationships form the basis for the cross-architecture equivalence verification performed later in the verification flow.

---

# 19. Design-to-Verification Interface

Each RTL architecture is designed to connect to a common verification environment.

```text
                   RTL Architecture
                          |
                 +--------+--------+
                 |                 |
                 v                 v
            Simulation          Formal
                 |                 |
              Vivado       Formality / VC Formal
                 |                 |
                 +--------+--------+
                          |
                          v
                   Verified RTL
                          |
                          v
                    Design Compiler
                          |
                          v
                      PPA Data
```

The use of common interfaces allows the same functional specification to be evaluated independently across different implementation architectures.

---

# 20. Synthesis-Oriented Architecture Study

After functional and formal verification, each RTL implementation is synthesized using Synopsys Design Compiler.

The synthesis flow is:

```text
RTL
 |
 v
Elaboration
 |
 v
Technology Mapping
 |
 v
Logic Optimization
 |
 v
Gate-Level Netlist
 |
 +--------+--------+
 |        |        |
Area    Timing    Power
```

The resulting PPA metrics are used to compare the three architecture styles.

The comparison is performed while keeping the synthesis environment and constraints consistent across architectures.

---

# 21. Design-Space Exploration

The architecture study can be viewed as a design-space exploration problem.

For each cryptographic function:

```text
                 Function
                    |
        +-----------+-----------+
        |           |           |
       LUT         AIG         ANF
        |           |           |
       PPA         PPA         PPA
```

The resulting measurements can be compared to determine which representation provides favorable implementation characteristics for a particular design objective.

For example:

* Minimum area
* Minimum delay
* Minimum power
* Balanced area/timing
* Technology-specific optimization

There is therefore no assumption that one representation is universally optimal.

---

# 22. Summary of the Architecture

The project implements a controlled comparison of three hardware representations for five cryptographic substitution functions.

The architecture hierarchy is:

```text
                         PROJECT
                            |
                Cryptographic S-Boxes
                            |
          +-----------------+-----------------+
          |                 |                 |
         AES             PRESENT            Ascon
          |                 |                 |
       S-box +          S-box +             S-box
       Inverse          Inverse
          |                 |                 |
          +-----------------+-----------------+
                            |
                    5 Functional Designs
                            |
          +-----------------+-----------------+
          |                 |                 |
         LUT              AIG                ANF
          |                 |                 |
          +-----------------+-----------------+
                            |
                     15 RTL Designs
                            |
             +--------------+--------------+
             |              |              |
        Simulation       Formal         Synthesis
             |              |              |
           Vivado      FM / VC Formal       DC
                            |              |
                            |              |
                     Functional &          PPA
                     Property Proof       Analysis
```

The architecture methodology therefore establishes a common framework for comparing alternative RTL representations of cryptographic nonlinear functions while maintaining the same functional specification.

---

# 23. Key Architectural Takeaway

The primary architectural contribution of this work is the systematic comparison of multiple RTL representations of identical cryptographic functionality.

Instead of evaluating a single implementation of an S-box, the design space is expanded across:

$$
\boxed{
5\ \text{functional designs}
\times
3\ \text{architectures}
=
15\ \text{RTL implementations}
}
$$

This enables a structured analysis of the relationship between:

$$
\boxed{
\text{Boolean Representation}
\rightarrow
\text{RTL Structure}
\rightarrow
\text{Formal Correctness}
\rightarrow
\text{Synthesized Implementation}
\rightarrow
\text{PPA}
}
$$

The architecture documentation should therefore be read together with the verification and synthesis documentation in this repository.

