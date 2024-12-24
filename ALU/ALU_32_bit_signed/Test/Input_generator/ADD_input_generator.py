import random
import os

# Hàm chuyển đổi số nguyên thành chuỗi hexadecimal 8 ký tự (big-endian)
def to_32bit_signed_hex(value):
    unsigned_value = value & 0xFFFFFFFF
    hex_str = f'{unsigned_value:08X}'
    return hex_str

# Hàm tạo số nguyên ngẫu nhiên với dấu tùy ý trong phạm vi của 32-bit signed integer
def generate_random_int():
    return random.randint(-2**31, 2**31 - 1)

# Các trường hợp cận biên cho A và B
def generate_boundary_cases():
    cases = []

    # Các cận biên: A, B có thể là các giá trị cận biên âm/dương
    cases.append((-2**31, -2**31))  # A âm, B âm
    cases.append((2**31 - 1, 2**31 - 1))  # A dương, B dương
    cases.append((-2**31, 2**31 - 1))  # A âm, B dương
    cases.append((2**31 - 1, -2**31))  # A dương, B âm

    # Cộng với các giá trị lớn để tạo ra Overflow
    cases.append((2**31 - 1, 1))  # A là max positive, B là 1 -> Overflow
    cases.append((-2**31, -1))  # A là min negative, B là -1 -> Overflow

    return cases

# Hàm phát hiện overflow trong phép cộng signed 32-bit
def detect_overflow(a, b, c):
    # Overflow xảy ra khi A và B cùng dấu nhưng C có dấu khác
    if (a > 0 and b > 0 and c < 0) or (a < 0 and b < 0 and c >= 0):
        return 1
    else:
        return 0

# Hàm thực hiện phép cộng và tính Cout (overflow)
def add_signed_32bit(a, b):
    # Thực hiện phép cộng và giữ lại 32 bit thấp nhất
    sum_unsigned = (a + b) & 0xFFFFFFFF

    # Chuyển đổi về signed
    if sum_unsigned & 0x80000000:
        sum_signed = sum_unsigned - 0x100000000
    else:
        sum_signed = sum_unsigned

    # Phát hiện overflow
    overflow = detect_overflow(a, b, sum_signed)

    # Debugging: In ra các giá trị
    print(f"A = {a} (0x{to_32bit_signed_hex(a)})")
    print(f"B = {b} (0x{to_32bit_signed_hex(b)})")
    print(f"Sum Unsigned = 0x{sum_unsigned:08X}")
    print(f"Sum Signed = {sum_signed} (0x{to_32bit_signed_hex(sum_signed)})")
    print(f"Overflow = {overflow}\n")

    return sum_signed, overflow

# Đảm bảo thư mục Simu tồn tại
directory = "../../Simu/input_data"
os.makedirs(directory, exist_ok=True)

# Đường dẫn các file đầu ra
output_file_C_ADD = os.path.join(directory, "ADD_output_C.txt")
output_file_Cout_ADD = os.path.join(directory, "ADD_output_Cout.txt")
input_file_A = os.path.join(directory, "ADD&SUB_input_A.txt")
input_file_B = os.path.join(directory, "ADD&SUB_input_B.txt")

# Tổng số lượng bộ cần tạo
num_entries = 1000

# Tạo các trường hợp cận biên
boundary_cases = generate_boundary_cases()

# Ghi các giá trị vào file
with open(input_file_A, 'w') as f_A, \
     open(input_file_B, 'w') as f_B, \
     open(output_file_C_ADD, 'w') as f_C, \
     open(output_file_Cout_ADD, 'w') as f_Cout:

    # Ghi các trường hợp cận biên vào file đầu tiên (input)
    for A, B in boundary_cases:
        hex_A = to_32bit_signed_hex(A)
        hex_B = to_32bit_signed_hex(B)
        f_A.write(f"{hex_A}\n")
        f_B.write(f"{hex_B}\n")
        
        # Tính C = A + B và Cout (overflow)
        C, Cout = add_signed_32bit(A, B)
        
        hex_C = to_32bit_signed_hex(C)
        hex_Cout = f'{Cout:X}'  # Chỉ lấy giá trị Overflow

        f_C.write(f"{hex_C}\n")
        f_Cout.write(f"{hex_Cout}\n")
        
    # Tiếp tục tạo các bộ test ngẫu nhiên cho đến khi đủ số lượng
    for _ in range(num_entries - len(boundary_cases)):
        A = generate_random_int()
        B = generate_random_int()
        
        hex_A = to_32bit_signed_hex(A)
        hex_B = to_32bit_signed_hex(B)
        f_A.write(f"{hex_A}\n")
        f_B.write(f"{hex_B}\n")
        
        # Tính C = A + B và Cout (overflow)
        C, Cout = add_signed_32bit(A, B)
        
        hex_C = to_32bit_signed_hex(C)
        hex_Cout = f'{Cout:X}'  # Chỉ lấy giá trị Overflow
        
        f_C.write(f"{hex_C}\n")
        f_Cout.write(f"{hex_Cout}\n")

print(f"Đã lưu {num_entries} bộ test vào các file:\n{input_file_A}\n{input_file_B}\n{output_file_C_ADD}\n{output_file_Cout_ADD}")
