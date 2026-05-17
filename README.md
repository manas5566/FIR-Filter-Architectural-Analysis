# FIR Filter Architectural Analysis

Benchmarking study of 1D FIR filter architectures across multiple adder types on Intel Cyclone V FPGA, evaluating area, power, and timing trade-offs.

---

## Overview

This project implements and compares **4 FIR filter architectures** across **7 adder types**, resulting in **28 unique design combinations**. Each combination is synthesized and analyzed for LUT utilization, power consumption, and timing slack on the Intel Cyclone V FPGA using Intel Quartus Prime.

**Key Result:** Approximate Adder + Fully Serial architecture achieves **74% fewer LUTs** and **55% lower power** compared to the worst-case Fully Parallel CLA implementation.

---

## Filter Architectures

| Architecture | Description |
|---|---|
| Fully Parallel | All filter taps computed simultaneously |
| Fully Serial | One tap computed per clock cycle |
| Partly Serial | Partial parallelism across taps |
| Cascade Serial | Serial stages cascaded for pipelined operation |

---

## Adder Types

| Adder | Type |
|---|---|
| Ripple Carry Adder (RCA) | Ripple propagation |
| Carry Lookahead Adder (CLA) | Fast lookahead logic |
| Carry Skip Adder | Skip logic for speed |
| Carry Save Adder | Redundant representation |
| Carry Select Adder | Parallel select paths |
| XOR MUX Based Adder | XOR-MUX hybrid |
| Approximate Adder | Error-tolerant, area-optimized |

---

## Results

### Fully Parallel

| Adder | LUTs | Power (W) | Setup Slack (ns) | Hold Slack (ns) |
|---|---|---|---|---|
| XOR MUX Based | 1565 | 0.028 | 24.528 | 0.175 |
| Ripple Carry | 1264 | 0.022 | 23.637 | 0.130 |
| Carry Lookahead | 1884 | 0.027 | 6.923 | 0.114 |
| Carry Skip | 1599 | 0.027 | 1.185 | 0.076 |
| Carry Save | 1952 | 0.022 | 0.509 | 0.097 |
| Carry Select | 1782 | 0.024 | 10.222 | 0.089 |
| Approximate | 635 | 0.009 | 29.687 | 0.117 |

### Fully Serial

| Adder | LUTs | Power (W) | Setup Slack (ns) | Hold Slack (ns) |
|---|---|---|---|---|
| XOR MUX Based | 613 | 0.011 | 28.546 | 0.040 |
| Ripple Carry | 613 | 0.011 | 28.546 | 0.040 |
| Carry Lookahead | 727 | 0.014 | 26.157 | 0.130 |
| Carry Skip | 479 | 0.009 | 27.415 | 0.077 |
| Carry Save | 607 | 0.011 | 26.796 | 0.053 |
| Carry Select | 521 | 0.010 | 27.639 | 0.062 |
| Approximate | 326 | 0.005 | 31.733 | 0.124 |

### Partly Serial

| Adder | LUTs | Power (W) | Setup Slack (ns) | Hold Slack (ns) |
|---|---|---|---|---|
| XOR MUX Based | 830 | 0.016 | 29.112 | 0.061 |
| Ripple Carry | 830 | 0.016 | 29.112 | 0.061 |
| Carry Lookahead | 957 | 0.020 | 30.533 | 0.060 |
| Carry Skip | 665 | 0.013 | 29.432 | 0.029 |
| Carry Save | 762 | 0.015 | 30.064 | 0.060 |
| Carry Select | 833 | 0.016 | 30.081 | 0.122 |
| Approximate | 423 | 0.007 | 33.891 | 0.060 |

### Cascade Serial

| Adder | LUTs | Power (W) | Setup Slack (ns) | Hold Slack (ns) |
|---|---|---|---|---|
| XOR MUX Based | 1239 | 0.019 | 23.868 | 0.064 |
| Ripple Carry | 1239 | 0.019 | 23.868 | 0.064 |
| Carry Lookahead | 1413 | 0.023 | 27.126 | 0.055 |
| Carry Skip | 1018 | 0.014 | 25.668 | 0.031 |
| Carry Save | 1247 | 0.016 | 27.178 | 0.050 |
| Carry Select | 1049 | 0.017 | 24.792 | 0.064 |
| Approximate | 709 | 0.007 | 29.348 | 0.082 |

---

## Key Findings

- **Most area & power efficient:** Approximate Adder + Fully Serial — **326 LUTs, 5mW**
- **Best timing margin:** Approximate Adder + Partly Serial — **33.89 ns setup slack**
- **Worst case:** Carry Save Adder + Fully Parallel — 1952 LUTs, 22mW
- Approximate Adder consistently achieves the lowest LUT count and power across all architectures at the cost of minor computational error

---

## Tools & Hardware

| Item | Detail |
|---|---|
| FPGA Board | Intel Cyclone V |
| EDA Tool | Intel Quartus Prime |
| HDL | Verilog |
| Clock Period | 10 µs |
| Testbenches | Self-checking Verilog testbenches for all 28 combinations |

---

## Repository Structure

```
FIR-Filter-Architectural-Analysis/
├── src/                  # Verilog RTL source files
│   ├── adders/           # All 7 adder implementations
│   └── fir/              # 4 FIR filter architectures
├── tb/                   # Self-checking testbenches
└── README.md
```

---

## Author

**Kole Manas**  
BTech ECE, Vellore Institute of Technology  
[LinkedIn](https://linkedin.com/in/K-Manas) | [GitHub](https://github.com/manas5566)
