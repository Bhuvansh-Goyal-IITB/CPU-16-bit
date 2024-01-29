
# 16 Bit CPU
A 16 bit CPU implemented on FPGA.

## Usage of the assembler
A testbench is provided, and by default a fibonacci sequence generator program is loaded to write a program of your choice you can write it in a text file and then use the assembler program to compile it, the assembler will directly write the necessary binary code in the im_memory.vhd file, IMPORTANT: DO NOT MOVE THE assembler.exe and memory_template.txt to any other location.

``` bash
./assembler.exe <text file path relative to the project folder>
```
For example lets say the file in which the code is written is in a code folder inside the root directory of this project and the name of the file is asm.txt so to compile it one should write the following command 

``` bash
./assembler.exe ./code/asm.txt
```

