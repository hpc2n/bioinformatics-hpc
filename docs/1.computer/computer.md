# What is a computer?

!!! note 

    "A computer is a machine that can be programmed to automatically carry out sequences of arithmetic or logical operations (computation)." 
    (Wikipedia) 

In this session we are going to do a short walk-through of what a computer is, both the hardware parts and the system software. 

Everyone has an idea of what a computer is; usually we are thinking of a screen, a keyboard, and internal components like CPU, GPU, HDD/SSH, and RAM/memory. 

Computers are special types of machines. Most machines only do one thing (cars, ovens, sewing machines, coffee machines), but computers are what is called "universal machines". They run programs that means they can do many different tasks. 

## Hardware parts

![Computer build](../../images/setup.png){: style="width: 600px;"}

Let us take a look inside a typical desktop computer. This shows a simplified sketch of the inside of the case: 

![Computer case, PSU, motherboard](../../images/desktop-case.png){: style="width: 600px;"}

- PSU is the power supply unit. 
- CD/DVD are getting increasingly rare
- If you have spinning disk/HDD installed, it sits in a rack along the side and is connected to the motherboard (power cable and data cable). Used for long term storage. Do not confuse with memory!
- A motherboard is mounted in the case, and has a socket for a CPU as well as slots for RAM/memory, SSDs/M.2 disk, PCIe etc. 
- How much RAM usually depends on the motherboard, and they should be of the same size (8GB, 16GB, 32GB, etc.) DRAM (Dynamic Random-Access Memory). Memory is a physical device that can be used to store information temporarily - when the computer is shut down the data disappears from the memory. Do NOT confuse with storage space!
- SSD storage are placed in the suitable slots. Size again depends on the motherboard. New SSDs are typically NVMe/M.2, which has better speed usually. Used for long term storage. Do not confuse with memory!  
- PCIe are expansion slots, often used for graphics cards/GPUs. These can be large and the case size is important when seeing if there is space for many of the modern types of GPUs.
- The GPU generally has its own cooling, but the CPU needs cooling. Either fans for air cooling or water cooling 
- Storage is related to "disks" on the computer. A disk is a storage device that stores and retrieves data using magnetic or optical technology. An SSD or a HDD is an example.


### A motherboard

![An example of a motherboard](../../images/motherboard.png){: style="width: 600px;"}

(MSI PRO B850-VC EVO WIFI6E motherboard. Image from https://www.msi.com/Motherboard/PRO-B850-VC-EVO-WIFI6E)


### Intel CPU and AMD CPU 

![Intel CPU](../../images/intel-cpu.jpeg){: style="width: 200px;"}
![AMD CPU](../../images/amd-cpu.jpg){: style="width: 200px;"}

(Images from https://news.softpedia.com/news/Latest-Core-i7-Extreme-Ivy-Bridge-E-Intel-CPU-Delayed-335790.shtml and https://hothardware.com/reviews/amd-ryzen-9-9950x3d-cpu-review)

### Memory

![RAM/memory](../../images/ram.jpeg){: style="width: 200px;"}
A couple memory sticks / RAM 

(Image from https://medium.com/@sunnybabacom10/ram-a-deep-dive-into-its-importance-types-and-functionality-c042a095ef95)

### SSD storage 

![SSD storage](../../images/ssd.jpg){: style="width: 200px;"}
2TB of SSD storage 

(Image from https://ssd-tester.com/crucial_p310_2tb.html) 

### GPU

![GPU](../../images/GPU.jpg){: style="width: 300px;"}
GPU (Nvidia)
![GPU chip](../../images/GPU-chip.jpg){: style="width: 200px;"}
GPU chip

(Images from https://www.techpowerup.com/gpu-specs/geforce-rtx-2070.c3252)

### Cooling 

![Fan](../../images/fan.jpg){: style="width: 100px;"}
A fan
![Watercooling](../../images/water-cooler.jpg){: style="width: 300px;"}
Watercooling including heat sink (the heat sink will be attached on top of a CPU with cooling paste in between) 

(Image from https://www.noctua.at/en/products/nf-a12x25-pwm and https://www.enermax.com/en/search/label/360mm%20Radiaotr) 

## System software 

System software is what is required for the computer to run and to let us interact with it. 

![System software](../../images/system-software.png){: style="width: 600px;"}

This picture shows how the different components talk together. 
=======
A computer is a machine that can be programmed to automatically carry out sequences of 
arithmetic or logical operations (computation). (Wikipedia) 

## Basic Functions of a Computer

A computer typically performs four main tasks:

1. **Input** – Receiving data (e.g., keyboard, mouse)
2. **Processing** – Performing calculations or operations
3. **Storage** – Saving data for later use
4. **Output** – Displaying results (e.g., monitor, printer)


## The Von Neumann Architecture

Almost every general-purpose computer built since the late 1940s follows the **Von Neumann architecture**, 
a design model first described by mathematician John von Neumann in his 1945 *First Draft of a Report on the EDVAC*. 
The model was groundbreaking because it proposed that a computer should store its **program (instructions) 
and its data in the same memory**, rather than having the program hardwired into the machine. 
This concept — known as the **stored-program model** — is what allows a computer to be reprogrammed 
simply by loading different instructions into memory, rather than rewiring its hardware.

The Von Neumann model defines four main components that communicate over a shared **bus**:

- **Central Processing Unit (CPU)** — fetches instructions from memory, decodes them, and executes them. 
Contains the ALU, Control Unit, and registers (described in detail below).
- **Memory Unit** — a single, unified address space that holds both the program instructions and the data they operate on.
- **Input/Output (I/O)** — mechanisms for receiving data from the outside world and sending results back out.
- **Bus** — the shared communication pathway connecting all components (carrying addresses, data, and control signals).

```
           ┌─────────────────────────────┐
           │            CPU              │
           │  ┌──────────┐  ┌─────────┐  │
           │  │   ALU    │  │   CU    │  │
           │  └──────────┘  └─────────┘  │
           │       Registers             │
           └─────────────┬───────────────┘
                         │  System Bus
           ┌─────────────┼──────────────┐
           │             │              │
     ┌─────┴──────┐  ┌───┴──────┐  ┌────┴─────┐
     │   Memory   │  │  Input   │  │  Output  │
     │ (programs  │  │ devices  │  │ devices  │
     │  + data)   │  └──────────┘  └──────────┘
     └────────────┘
```

### The Von Neumann Bottleneck

A fundamental limitation of this architecture is that the CPU and memory share the **same bus** for both instructions and data. 
This means the CPU can only do one of these at a time — fetch an instruction *or* read/write data — creating a traffic bottleneck 
known as the **Von Neumann bottleneck**. As CPUs grew faster over the decades while memory speeds improved more slowly, this 
bottleneck became an increasingly serious constraint on performance.

Modern hardware addresses this in several ways: **cache hierarchies** (L1/L2/L3) keep frequently used data 
close to the CPU to reduce bus traffic; **Harvard-style L1 caches** split the first cache level into separate 
instruction and data caches so both can be accessed simultaneously; **wide memory buses**, **DDR channels**, 
and **HBM (High Bandwidth Memory)** increase the raw data transfer rate; and **prefetching** units predict which 
data will be needed next and load it into cache before the CPU asks. Despite these mitigations, the memory wall 
— the growing gap between CPU speed and memory bandwidth — remains one of the central challenges in modern 
computer architecture and HPC system design.


## What Is a CPU?

The **Central Processing Unit (CPU)** is often called the brain of the computer. It is responsible for fetching, 
decoding, and executing instructions, as well as processing data.

### Main Parts of a CPU

#### Control Unit (CU)
Directs the operation of the processor. It fetches instructions from memory, decodes them, and coordinates the 
activities of all other components.

#### Arithmetic Logic Unit (ALU)
Performs mathematical calculations (addition, subtraction, multiplication, etc.) and logical operations 
(comparisons such as greater than, equal to, or AND/OR logic).

#### Registers
Registers are the smallest and fastest storage locations inside the CPU. They hold temporary data, operands, 
and intermediate results *during* instruction execution. Because they sit directly inside the processor, 
accessing a register takes less than one CPU cycle — far faster than any other form of memory. Common register types include:

- **General-purpose registers** – hold operands and results (e.g., `rax`, `rbx` on x86-64)
- **Program Counter (PC)** – tracks the address of the next instruction to execute
- **Stack Pointer (SP)** – points to the top of the current call stack
- **Flags/Status register** – records condition codes (zero, carry, overflow, etc.) from the last operation


## What Is an Instruction?

An **instruction** is the most basic command a CPU can execute. A program is ultimately a sequence of such 
instructions encoded in **machine code** — binary patterns the hardware can decode directly.

Each instruction typically specifies:
- An **opcode** — what operation to perform (e.g., ADD, LOAD, BRANCH)
- **Operands** — which registers or memory addresses to operate on

The set of all instructions a CPU understands is called its **Instruction Set Architecture (ISA)**. 
The ISA defines the interface between software and hardware: as long as a program targets a given ISA, 
it can run on any CPU that implements it, regardless of the underlying microarchitecture.

Modern CPUs execute instructions through a **pipeline**: fetch → decode → execute → write-back. 
Multiple instructions can be in different pipeline stages simultaneously, greatly increasing throughput.

### Common ISAs

**x86-64 (also called AMD64 or Intel 64)** is the dominant ISA for desktop computers, laptops, 
and servers. It originated as a 16-bit design (Intel 8086, 1978), was extended to 32-bit (IA-32/x86), 
and then to 64-bit by AMD in 2003 — hence the name. x86-64 is a **CISC** (Complex Instruction Set Computer) 
architecture, meaning it has a large, feature-rich instruction set where a single instruction 
can express complex operations (e.g., a memory-to-memory move or a string comparison). 
Modern x86-64 CPUs internally translate these complex instructions into simpler micro-operations 
(µops) for pipelined execution. Nearly all software you run on a Linux workstation or Windows PC targets this ISA.

**AArch64 (ARM64)** is the 64-bit version of the ARM ISA, introduced with ARMv8 in 2011. ARM follows a **RISC** (Reduced Instruction Set Computer) philosophy: a smaller, simpler, more uniform set of instructions where each instruction does less, but the result is easier pipelining and, critically, lower power consumption per operation. This makes ARM the dominant choice in mobile devices (smartphones, tablets), embedded systems, and increasingly in laptops (Apple M-series, Qualcomm Snapdragon X) and cloud servers (AWS Graviton, Ampere Altra). In HPC, ARM is gaining ground — for example, the Fujitsu A64FX processor (used in the Fugaku supercomputer) is AArch64-based and includes SVE (Scalable Vector Extension) for wide SIMD operations.

**RISC-V** is an open, royalty-free ISA that has gained rapid adoption since its publication by UC Berkeley in 2010. Unlike x86-64 and ARM, RISC-V is not owned by any single company, which makes it attractive for research, embedded systems, and custom silicon. It is a clean RISC design with a small base integer ISA that can be extended with standardised modules (e.g., `M` for integer multiply/divide, `F`/`D` for floating-point, `V` for vector operations). RISC-V chips are appearing in microcontrollers, FPGAs, and increasingly in HPC accelerators and AI processors.

**Other notable ISAs** include **POWER/PowerPC** (IBM's architecture, still used in high-end servers and the Summit/Frontier-era HPC systems), **SPARC** (historically important in scientific workstations, now largely retired), and **IA-64 (Itanium)** (Intel's ill-fated VLIW architecture, discontinued in 2021). For GPUs — which are not general-purpose CPUs but execute massively parallel workloads — NVIDIA uses its own proprietary ISA (PTX/SASS for CUDA), while AMD uses RDNA/CDNA for its GPU family.

### CISC vs. RISC in Practice

The CISC/RISC distinction matters less than it once did. Modern x86-64 CPUs decode CISC instructions into RISC-like µops internally, so the execution engine is effectively RISC. Conversely, modern ARM chips have grown their instruction sets considerably (NEON, SVE, Pointer Authentication, etc.). The more meaningful practical differences today are **power envelope** (ARM tends to be more efficient), **ecosystem** (x86-64 has decades of optimised software and libraries), and **vendor model** (ARM licenses its ISA to many chip designers, while x86-64 is only manufactured by Intel and AMD).


## What Are CPU Cores?

A **core** is a complete, independent processing unit within the CPU. Each core has its own ALU, CU, registers, and private cache levels (L1 and L2).

- A **single-core** CPU processes one instruction stream at a time.
- A **multi-core** CPU (dual-core, quad-core, many-core, etc.) can execute multiple instruction streams in parallel.

More cores generally improve performance for multitasking and parallel workloads such as scientific simulations, video encoding, and HPC applications. However, not all software can take advantage of multiple cores — programs must be explicitly written to use parallel execution (e.g., via threads, OpenMP, or MPI).


## What Is Cache Memory?

**Cache** is a small, extremely fast memory built directly into (or very close to) the CPU. Its purpose is to reduce the time the CPU spends waiting for data to arrive from the much slower main memory (RAM).

Caches are organised in levels:

| Level | Location | Size (typical) | Speed |
|-------|----------|---------------|-------|
| **L1** | Inside each core | 32 – 128 KB | ~4 cycles |
| **L2** | Inside each core (or nearby) | 256 KB – 4 MB | ~12 cycles |
| **L3** | Shared across all cores | 8 – 64 MB | ~40 cycles |
| **RAM** | On the motherboard | 8 – 512 GB | ~100–200 cycles |

When the CPU needs data, it first checks L1, then L2, then L3, and only fetches from RAM if the data is not found in any cache level (a **cache miss**). This hierarchy exploits **locality of reference**: programs tend to reuse the same data and instructions repeatedly.

Cache efficiency has a profound impact on real-world performance. A cache-friendly algorithm can be orders of magnitude faster than one that repeatedly misses to RAM.


## What Is RAM?

**RAM (Random Access Memory)** is the computer's short-term, working memory. It temporarily stores the data and instructions that the CPU is actively using. RAM is fast compared to disk storage, but volatile — its contents are lost when the computer is powered off.

### Why RAM Matters

- More RAM allows the operating system to keep more programs and data in memory simultaneously.
- Insufficient RAM forces the OS to use **swap space** (disk-based virtual memory), which is orders of magnitude slower and can make the system feel unresponsive.
- RAM speed (measured in MT/s or MHz) and latency also affect how quickly the CPU can fetch data that is not in cache.


## NUMA — Non-Uniform Memory Access

Modern servers and workstations often contain multiple CPU **sockets**, each with its own cores and a local bank of RAM. This architecture is called **NUMA (Non-Uniform Memory Access)**.

```
  Socket 0                        Socket 1
┌──────────────────┐           ┌──────────────────┐
│  Core 0 … Core N │           │  Core 0 … Core N │
│  L1 / L2 / L3    │           │  L1 / L2 / L3    │
│  Local RAM       │◄─────────►  Local RAM        │
└──────────────────┘  Inter-   └──────────────────┘
                     connect
                    (e.g. AMD
                    Infinity
                    Fabric or
                    Intel UPI)
```

- A core can access its **local** RAM quickly (low latency).
- Accessing **remote** RAM (on the other socket) is possible but slower — typically 1.5× to 3× more latency.

In HPC and high-performance workloads, NUMA awareness is critical. Placing data in the same NUMA node as the cores that process it avoids expensive cross-socket traffic. Tools like `numactl`, `hwloc`, and SLURM's `--mem-bind` option help manage NUMA placement on Linux clusters.


## How Everything Works Together

```
  Input Devices
  (keyboard, sensor)
        │
        ▼
  ┌─────────────────────────────────────────┐
  │                   CPU                   │
  │  ┌──────┐  ┌──────┐  ┌───────────────┐  │
  │  │  CU  │  │ ALU  │  │  Registers    │  │
  │  └──┬───┘  └──┬───┘  └───────────────┘  │
  │     └────┬────┘                         │
  │          │   ◄──── L1 / L2 cache        │
  └──────────┼──────────────────────────────┘
             │   ◄──── L3 cache (shared)
             ▼
           RAM
             │
             ▼
     Storage / Output
  (SSD, monitor, network)
```

1. **Instructions and data** are loaded from storage into RAM.
2. The **CPU** fetches instructions from RAM (or cache), decodes them, and executes them using the ALU and registers.
3. The **cache hierarchy** keeps frequently used data close to the cores.
4. On multi-socket systems, **NUMA** topology determines how fast each core can reach each region of RAM.
5. **Results** are written back to RAM, storage, or output devices.


## Summary

| Component | Role |
|-----------|------|
| **CPU** | Executes instructions; the "brain" of the computer |
| **Cores** | Independent execution units within a CPU; enable parallelism |
| **Registers** | Tiny, ultra-fast storage inside each core for live data |
| **Instructions / ISA** | The language the CPU understands; defines what operations it can perform |
| **Cache (L1/L2/L3)** | Fast on-chip memory that reduces costly trips to RAM |
| **RAM** | Larger, volatile working memory for active programs and data |
| **NUMA** | Architecture of multi-socket systems where memory access time depends on locality |

!!! tip "References"

    
    - <a href="https://johny4u.com/igcse_theory_2023/07)%20Computer%20Architecture.php" target="_blank">Computer Architecture</a>
    - <a href="https://en.wikipedia.org/wiki/First_Draft_of_a_Report_on_the_EDVAC" target="_blank">Von Neumann Report</a>
    - <a href="https://www.geeksforgeeks.org/computer-organization-architecture/computer-organization-von-neumann-architecture/" target="_blank">Computer organization</a>
    - <a href="https://www.geeksforgeeks.org/computer-organization-architecture/introduction-of-control-unit-and-its-design/" target="_blank">Instruction control units</a>
    - <a href="https://www.geeksforgeeks.org/computer-organization-architecture/essential-registers-for-instruction-execution/" target="_blank">Registers for instruction</a>
    - <a href="https://daemons.net/hardware/processors/x86.html" target="_blank">x86 instruction set</a>
    - <a href="https://en.wikipedia.org/wiki/X86-64" target="_blank">x86-64 instruction set</a>
    - <a href="https://en.wikipedia.org/wiki/AArch64" target="_blank">AArch64</a>
    - <a href="https://jasonblog.github.io/note/arm/introduction_to_armv8_64-bit_architecture.html" target="_blank">ARM64</a>
    - <a href="https://dl.acm.org/doi/10.1145/3757348.3757367" target="_blank">RISC-V instruction set</a>
    - <a href="https://www.geeksforgeeks.org/computer-science-fundamentals/central-processing-unit-cpu/" target="_blank">Central Processing Unit</a>
    - <a href="https://en.wikipedia.org/wiki/CPU_cache" target="_blank">Central Processing Unit cache</a>
    - <a href="https://www.geeksforgeeks.org/computer-science-fundamentals/cache-memory/" target="_blank">Cache memory</a>
    - <a href="https://www.geeksforgeeks.org/computer-organization-architecture/cache-memory-performance/" target="_blank">Cache memory performance</a>
    - <a href="https://www.geeksforgeeks.org/computer-science-fundamentals/random-access-memory-ram/" target="_blank">Random Access Memory</a>
    - <a href="https://www.geeksforgeeks.org/computer-organization-architecture/difference-between-uniform-memory-access-uma-and-non-uniform-memory-access-numa/" target="_blank">Non Uniform Access Memory</a>
    - <a href="https://en.wikipedia.org/wiki/Non-uniform_memory_access" target="_blank">NUMA</a>

