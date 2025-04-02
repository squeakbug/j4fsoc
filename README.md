# j4fsoc

## Setup dev environment

```sh
nix develop
```

## Overview

The toolchain installation script installs the following tools:
- [RISC-V GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain): GCC and accompanying compiler tools
- [elf2hex](https://github.com/sifive/elf2hex): executable file to hexadecimal converter
- [bin2coe](https://github.com/anishathalye/bin2coe): binary file to COE format for Vivado IDE
- [QEMU](https://www.qemu.org/docs/master/system/target-riscv.html): emulator 1
- [buildroot (optionally)](https://buildroot.org/): embedded linux distribution builder
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

## Vivado considerations

https://github.com/barbedo/vivado-git

## Verilator and scheduling considerations

* [std::randomized are not supported in vanila version](https://github.com/verilator/verilator/issues/5438)
* [Dynamic scheduler by Antmicro](https://opensource.antmicro.com/projects/verilator-dynamic-scheduler-examples/)

## TODO:

- TODO: use [OpenLane](https://github.com/The-OpenROAD-Project/OpenLane) or [OpenLane2 (F)](https://github.com/efabless/openlane2) container instead of this tools bunch.
- TODO: add [Yocto](https://docs.yoctoproject.org/) instead of buildroot
- TODO: use [UVM](https://www.chipverify.com/tutorials/uvm) built-in classes
- TODO: REST API for co-simulation (or use CoCoTb)
    - SOmething like [that](https://github.com/ArcSpecter/rapidvpi) maybe