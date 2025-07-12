# Lab 5: Nios + Qsys + Direct Digital Synthesis + LFSR + Modulations + Clock Domains

This repository contains the design and implementation of a **multi-signal generator and VGA oscilloscope interface**, created as part of the **CPEN 311: Digital Systems Design** course at the **University of British Columbia**.

---

## Overview

In this lab, you will:

- Instantiate and clock-divide a 5-bit LFSR to produce a pseudo-random bit sequence (1 Hz).  
- Instantiate a DDS module to generate a 3 Hz carrier waveform (50 MHz sampling).  
- Implement ASK and BPSK purely in Verilog, and FSK via a hybrid hardware/software approach using Nios II.  
- Connect all signals to a two-channel VGA “oscilloscope” for real-time visualization, with proper clock-domain crossings.

---

## Project Structure

The design is organized into three main tasks:

### Task 1: LFSR and Clock Division

- **`clk_div_1hz.sv`**  
  Divides the 50 MHz board clock down to 1 Hz.

- **`LFSRs.sv`**  
  Implements a 5-bit maximal-length LFSR driven by the 1 Hz clock.

### Task 2: DDS and Modulation

- **`dds_and_nios_lab.v`**  
  Top-level wrapper instantiating the DDS core.

- **`ASK.sv`** & **`BPSK.sv`**  
  Verilog modules using LFSR bit 0 to generate ASK (OOK) and BPSK waveforms.

- **`dds_tuning_words.vh`**  
  Constants for 3 Hz, 1 Hz, and 5 Hz tuning words (included via Verilog header).

### Task 3: Hybrid FSK and VGA Interface

- **`student_code.c`**  
  Nios II ISR that reads the LFSR value on each rising edge via PIO, and writes a new DDS tuning word (1 Hz or 5 Hz) to the `dds_increment` PIO.

- **`sig_to_vga.sv`**  
  Routes selected modulation and raw DDS outputs through Nios-controlled multiplexers, applies clock-domain crossing, and connects to the VGA oscilloscope channels.

---

## Usage

1. **Generate the 1 Hz clock & LFSR**  
   Compile and simulate `clk_div_1hz.sv` and `LFSRs.sv` to verify the PN-sequence output.

2. **Instantiate the DDS**  
   Include the `waveform_gen` megafunction in Quartus and connect the 32-bit tuning word for a 3 Hz carrier.

3. **Modulation**  
   - **ASK/BPSK**: Pure Verilog using LFSR[0] to gate or invert the DDS output.  
   - **FSK**: Configure Nios II and Qsys with three PIOs (`lfsr_clk_interrupt_gen`, `lfsr_val`, `dds_increment`), then implement the ISR in `student_code.c`.

4. **VGA Oscilloscope**  
   Use `sig_to_vga.sv` to map any of the four signals (DDS, ASK, BPSK, FSK) onto the two VGA channels. Control selection via keyboard GUI.

---

## Running the Design

1. Open the Quartus project (`dds_and_nios_lab.qpf`).  
2. Assign base addresses in Qsys for the three PIOs and generate the system.  
3. Compile to produce the `.sof` file and program the DE1-SoC board.  
4. Import, build, and download the `lab5.elf` into Nios II using Eclipse.  
5. Use the keyboard-driven VGA GUI to select and observe each waveform in real time.
