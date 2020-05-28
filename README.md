# Custom_MIPS_Processor_using_VHDL_with_RC5_Cipher
![](https://github.com/akhilwadhwa22/Custom_MIPS_based_Processor_using_VHDL_with_RC5_Cipher/blob/master/NYU_ProcessorBlockDiagram.pdf)


### Video Link : https://youtu.be/TCuIPBlUtqk

## Specification Sheet
The processor comprises the following components:

 ### ● Program counter (PC) register: 
This is a 32 -bit register that contains the address of the next instruction to be executed by the processor.

### ● Decode Unit: 
This block takes as input some or all of the 32 bits of the instruction, and computes the proper control signals that are required for correctly coordinating the other blocks in your design. These signals are generated based on the type and the content of the instruction being executed.

### ● Register File:
This block contains 32 32-bit registers. The register file supports two independent register reads and one register write in one clock cycle. 5 bits are used to address the register file. R0 value is always 0. It is read only register.

### ● ALU:
This block performs operations such as addition, subtraction, comparison, etc. It uses the control signals generated by the Decode Unit, as well as the data from the registers or from the instruction directly. It computes data that can be written into one of the registers (including PC). You will implement this block by referring to the instruction set.

### ● Instruction and Data Memory: 
The instruction memory is initialized to contain the program to be executed. Instruction memory width is 8-bits. The data memory stores the data and is accessed using LW (load word) and SW (store word) instructions. Data memory width is 16-bits. The address width for the data and instruction memory will be determined by the amount of memory available in your FPGA. Use up to as much memory as your FPGA allows.

