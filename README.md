# j4fsoc

## Overview

The toolchain installation script installs the following tools:
- [RISC-V GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain): GCC and accompanying compiler tools
- [elf2hex](https://github.com/sifive/elf2hex): executable file to hexadecimal converter
- [QEMU](https://www.qemu.org/docs/master/system/target-riscv.html): emulator 1
- [j4frv32emu](https://github.com/squeakbug/j4frv32emu): emulator 2
- [Spike](https://github.com/riscv-software-src/riscv-isa-sim): functional RISC-V model
- [Yosys](https://github.com/YosysHQ/yosys): framework for RTL synthesis tools
    - [SymbiYosys](https://github.com/YosysHQ/sby)
    - [Mutation Cover with Yosys](https://github.com/YosysHQ/mcy)
- [Verilator](https://github.com/verilator/verilator): open-source Verilog simulator
- [Verible](https://github.com/chipsalliance/verible): open-source SystemVerilog linter
- [RISC-V Sail Model](https://github.com/riscv/sail-riscv): golden reference model for RISC-V
- [OSU Skywater 130 cell library](https://foss-eda-tools.googlesource.com/skywater-pdk/libs/sky130_osu_sc_t12): standard cell library
- [RISCOF](https://github.com/riscv-software-src/riscof.git): RISC-V compliance test framework
- [j4fos](https://github.com/squeakbug/j4fos): rtos for debugging

## RISC-V cores

### SystemVerilog/Verilog/VHDL

- [schoolRISC-V](https://github.com/zhelnio/schoolRISCV)
    - [schoolRISC-V + instruction cache](https://github.com/NickolayTernovoy/schoolRISCV_ICache)
- [picorv32 by Yosys team](https://github.com/YosysHQ/picorv32)
- [Simple educational RISC-V CPU for demonstrating riscv-formal](https://github.com/YosysHQ/nerv)
- [nanoFOX](https://github.com/Dmitriy0111/nanoFOX)
- [neorv32](https://github.com/stnolting/neorv32)
- [Hazard3](https://github.com/Wren6991/Hazard3)
- [SCR1 by syntacore](https://github.com/syntacore/scr1)
- [ibex by lowRISC](https://github.com/lowRISC/ibex)
- [Taiga](https://github.com/tsmk94/Taiga)
- [CORE-V (pipelined RISC-V core and SoC) Wally by D. Harris](https://github.com/openhwgroup/cvw)
    - [CVW verification](https://github.com/openhwgroup/cvw-arch-verif)
- [cva6 by openhwgroup)](https://github.com/openhwgroup/cva6)
- [core by BlackParrot](https://github.com/black-parrot/black-parrot)
- [opentitan](https://github.com/lowrisc/opentitan)
- [kianRiscV](https://github.com/splinedrive/kianRiscV)
- [OpenC910 by XuanTie/Alibaba](https://github.com/XUANTIE-RV/openc910)
- [VeeR EL2 Core by CHIPS Alliance](https://github.com/chipsalliance/Cores-VeeR-EL2)
- [e203](https://github.com/riscv-mcu/e203_hbirdv2)
- [darkriscv](https://github.com/darklife/darkriscv)

### Chisel/SpinalHDL/...

- [The Berkeley Out-of-Order RISC-V Processor](https://github.com/riscv-boom/riscv-boom)
- [XiangShan](https://github.com/OpenXiangShan/XiangShan)
- [VexRiscv](https://github.com/SpinalHDL/VexRiscv)
- [SaxonSoc](https://github.com/SpinalHDL/SaxonSoc)
- [ChiselV by carlosedp](https://github.com/carlosedp/chiselv)

## Frameworks

- [Rocket Chip Generator ](https://github.com/chipsalliance/rocket-chip)
- [chipyard](https://github.com/ucb-bar/chipyard)
- [OSS CAD by Yosys team](https://github.com/YosysHQ/oss-cad-suite-build)

## Formats

- [UHDM](https://github.com/chipsalliance/UHDM)

## RISC-V based SoCs

- [quasiSoC](https://github.com/regymm/quasiSoC)
- [croc](https://github.com/pulp-platform/croc)
- [cva6-based SoC - cheshire](https://github.com/pulp-platform/cheshire)
- [ysyxSoC](https://github.com/OSCPU/ysyxSoC)

## Literature and other sources

- [RISC-V System-On-Chip Design](https://shop.elsevier.com/books/risc-v-system-on-chip-design/harris/978-0-323-99498-9)
- [Путеводитель АПС](https://github.com/MPSU/APS)
- [Edaplayground](https://www.edaplayground.com/)

### FPU

- [PERCIVAL: Open-Source Posit RISC-V Core with Quire Capability (posit for RISC-V)](https://arxiv.org/pdf/2111.15286)
