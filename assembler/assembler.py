from utility import int_to_bin, reg_to_bin

ins_dict = {
    "add": {"opcode": "0000", "ins_type": "r"},
    "sub": {"opcode": "0010", "ins_type": "r"},
    "mul": {"opcode": "0011", "ins_type": "r"},
    "adi": {"opcode": "0001", "ins_type": "i"},
    "and": {"opcode": "0100", "ins_type": "r"},
    "ora": {"opcode": "0101", "ins_type": "r"},
    "imp": {"opcode": "0110", "ins_type": "r"},
    "lhi": {"opcode": "1000", "ins_type": "j"},
    "lli": {"opcode": "1001", "ins_type": "j"},
    "lw": {"opcode": "1010", "ins_type": "i"},
    "sw": {"opcode": "1011", "ins_type": "i"},
    "beq": {"opcode": "1100", "ins_type": "i"},
    "jal": {"opcode": "1101", "ins_type": "j"},
    "jlr": {"opcode": "1111", "ins_type": "i"},
    "nop": {"opcode": "0111", "ins_type": "h"},
    "prt": {"opcode": "1110", "ins_type": "p"},
}

blocks = dict()
current_block = ""
current_mem_address = 0


def line_to_binary(line):
    output = ""
    output += ins_dict[line[0]]["opcode"]

    ins_type = ins_dict[line[0]]["ins_type"]

    if ins_type == "r":
        output += reg_to_bin(line[1])
        output += reg_to_bin(line[2])
        output += reg_to_bin(line[3])
        output += "000"
    elif ins_type == "i":
        output += reg_to_bin(line[1])
        output += reg_to_bin(line[2])
        if len(line) == 3:
            output += "000000"
        else:
            output += int_to_bin(line[3], 6)
    elif ins_type == "j":
        output += reg_to_bin(line[1])
        output += int_to_bin(line[2], 9)
    elif ins_type == "h":
        output += "000000000000"
    elif ins_type == "p":
        if line[1][0] == "@":
            output += reg_to_bin(line[1][1:])
            output += "000000001"
        else:
            output += reg_to_bin(line[1]) 
            output += "000000000"

    return output


with open("./assembler/asm.txt", "r") as file:
    lines = file.readlines()

parsed_lines = list()
for line in lines:
    parsed_line = [word.strip() for word in line.strip().split(" ") if word != ""]
    if len(parsed_line):
        parsed_lines.append(parsed_line)

for parsed_line in parsed_lines:
    if len(parsed_line) == 1 and parsed_line[0][-1] == ":":
        current_block = parsed_line[0]
    else:
        if current_block in blocks:
            blocks[current_block]["lines"].append(parsed_line)
            current_mem_address += 1
        else:
            blocks[current_block] = dict()
            blocks[current_block]["mem_address"] = current_mem_address
            blocks[current_block]["lines"] = list()
            blocks[current_block]["lines"].append(parsed_line)
            current_mem_address += 1

with open("./input.txt", "w") as file:
    pass

for key, value in blocks.items():
    for parsed_line in value["lines"]:
        with open("./input.txt", "a") as file:
            file.write(line_to_binary(parsed_line) + "\n")

with open("assembler/memory_template.txt", "r") as file:
    template = file.read()

with open("input.txt", "r") as file:
    bin_lines = file.readlines()
    bin_lines = [str(index) + " => " + f'"{line.strip()}",' for index, line in enumerate(bin_lines)]
    final_block = ""
    for line in bin_lines:
        final_block += line + "\n"

with open("im_memory.vhd", "w") as file:
    file.write(template.replace("{insert}", final_block))
