def int_to_bin(number: str, bin_length: int) -> str:
    number = int(number)
    if number > pow(2, bin_length ) - 1:
        raise Exception("Number is out of range")
    ans = ""
    for i in range(0, bin_length):
        ans += str(number & 1)
        number >>= 1
    return ans[::-1]

def reg_to_bin(reg_str: str) -> str:
    return int_to_bin(reg_str[1], 3)
