import random
import os
import struct

# ===========================
# Hàm Hỗ Trợ
# ===========================

def to_hex(value, width=32):
    """
    Chuyển đổi số signed integer thành chuỗi hex với độ rộng bit xác định.
    """
    if width == 32:
        format_str = '<I'  # Little-endian unsigned
    elif width == 64:
        format_str = '<Q'  # Little-endian unsigned
    else:
        raise ValueError("Unsupported width")

    unsigned_value = value & ((1 << width) - 1)
    hex_str = ''.join(f'{byte:02X}' for byte in struct.pack(format_str, unsigned_value))
    return hex_str

def detect_overflow_add(a, b, c):
    """
    Phát hiện overflow cho phép cộng signed 32-bit.
    """
    if (a > 0 and b > 0 and c < 0):
        return 1
    elif (a < 0 and b < 0 and c >= 0):
        return 1
    else:
        return 0

def detect_overflow_sub(a, b, c):
    """
    Phát hiện overflow cho phép trừ signed 32-bit.
    """
    if (a > 0 and b < 0 and c < 0):
        return 1
    elif (a < 0 and b > 0 and c > 0):
        return 1
    else:
        return 0

def add_signed_32bit(a, b):
    sum_total = a + b
    overflow = detect_overflow_add(a, b, sum_total)
    # Saturation Arithmetic
    if overflow:
        if a > 0 and b > 0:
            sum_clamped = 2**31 - 1
        elif a < 0 and b < 0:
            sum_clamped = -2**31
    else:
        sum_clamped = sum_total
    # Giới hạn trong phạm vi 32-bit signed
    sum_clamped = max(min(sum_clamped, 2**31 -1), -2**31)
    return sum_clamped, overflow

def sub_signed_32bit(a, b):
    diff_total = a - b
    overflow = detect_overflow_sub(a, b, diff_total)
    # Saturation Arithmetic
    if overflow:
        if a > 0 and b < 0:
            diff_clamped = 2**31 - 1
        elif a < 0 and b > 0:
            diff_clamped = -2**31
    else:
        diff_clamped = diff_total
    # Giới hạn trong phạm vi 32-bit signed
    diff_clamped = max(min(diff_clamped, 2**31 -1), -2**31)
    return diff_clamped, overflow

def mul_signed_32bit(a, b):
    product = a * b
    # Giới hạn kết quả trong phạm vi 64-bit signed
    product_clamped = max(min(product, 2**63 -1), -2**63)
    return product_clamped

def div_signed_32bit(z, d):
    if d == 0:
        # Division by zero: define Q and R as max values or specific indicators
        Q = 2**32 -1  # Representing undefined
        R = 2**32 -1
    else:
        Q = z // d
        R = z % d
        # Giới hạn Q và R trong phạm vi 32-bit signed
        Q = max(min(Q, 2**31 -1), -2**31)
        R = max(min(R, 2**31 -1), -2**31)
    return Q, R

# ===========================
# Hàm Tạo Bộ Test Cho Các Phép Toán
# ===========================

def generate_add_sub_boundary_cases():
    cases = []
    # ADD Cases
    # 1. A min, B min
    cases.append(('ADD', -2**31, -2**31))
    # 2. A max, B max
    cases.append(('ADD', 2**31 - 1, 2**31 - 1))
    # 3. A min, B max
    cases.append(('ADD', -2**31, 2**31 - 1))
    # 4. A max, B min
    cases.append(('ADD', 2**31 - 1, -2**31))
    # 5. A max, B max to cause overflow
    cases.append(('ADD', 2**31 - 1, 1))
    # 6. A min, B min to cause overflow
    cases.append(('ADD', -2**31, -1))
    
    # SUB Cases
    # 1. A min, B min
    cases.append(('SUB', -2**31, -2**31))
    # 2. A max, B max
    cases.append(('SUB', 2**31 - 1, 2**31 - 1))
    # 3. A min, B max
    cases.append(('SUB', -2**31, 2**31 - 1))
    # 4. A max, B min
    cases.append(('SUB', 2**31 - 1, -2**31))
    # 5. A min, B max to cause overflow
    cases.append(('SUB', -2**31, 1))
    # 6. A max, B min to cause overflow
    cases.append(('SUB', 2**31 - 1, -1))
    
    return cases

def generate_mul_boundary_cases():
    cases = []
    # MUL Boundary Cases
    # 1. M min, Q min
    cases.append(('MUL', -2**31, -2**31))
    # 2. M max, Q max
    cases.append(('MUL', 2**31 - 1, 2**31 - 1))
    # 3. M min, Q max
    cases.append(('MUL', -2**31, 2**31 - 1))
    # 4. M max, Q min
    cases.append(('MUL', 2**31 - 1, -2**31))
    # 5. M = 0, Q random
    for _ in range(2):
        cases.append(('MUL', 0, generate_random_int32()))
    # 6. Q = 0, M random
    for _ in range(2):
        cases.append(('MUL', generate_random_int32(), 0))
    # 7. M and Q mid-range
    for _ in range(2):
        cases.append(('MUL', generate_random_int32(), generate_random_int32()))
    return cases

def generate_div_boundary_cases():
    cases = []
    # DIV Boundary Cases
    # 1. Z min, D min
    cases.append(('DIV', -2**63, -2**31))
    # 2. Z max, D max
    cases.append(('DIV', 2**63 - 1, 2**31 - 1))
    # 3. Z min, D max
    cases.append(('DIV', -2**63, 2**31 - 1))
    # 4. Z max, D min
    cases.append(('DIV', 2**63 - 1, -2**31))
    # 5. Z = 0, D random (except D = 0)
    for _ in range(2):
        d = generate_random_int32()
        while d == 0:
            d = generate_random_int32()
        cases.append(('DIV', 0, d))
    # 6. D = 0, Z random (division by zero)
    for _ in range(2):
        z = generate_random_int64()
        cases.append(('DIV', z, 0))
    # 7. Z and D mid-range
    for _ in range(2):
        z = generate_random_int64()
        d = generate_random_int32()
        while d == 0:
            d = generate_random_int32()
        cases.append(('DIV', z, d))
    return cases

# Hàm tạo số nguyên ngẫu nhiên với dấu tùy ý trong phạm vi của 32-bit signed integer
def generate_random_int32():
    return random.randint(-2**31, 2**31 - 1)

# Hàm tạo số nguyên ngẫu nhiên với dấu tùy ý trong phạm vi của 64-bit signed integer
def generate_random_int64():
    return random.randint(-2**63, 2**63 - 1)

# ===========================
# Hàm Tạo và Ghi Bộ Test
# ===========================

def generate_test_cases():
    # Thông số và đường dẫn file
    DIRECTORY = "../../Simu/input_data"
    os.makedirs(DIRECTORY, exist_ok=True)
    
    # ADD
    ADD_A_SIZE = 1000
    ADD_B_SIZE = 1000
    ADD_C_SIZE = 1000
    ADD_Cout_SIZE = 1000
    ADD_A_WIDTH = 32
    ADD_B_WIDTH = 32
    ADD_C_WIDTH = 32
    ADD_Cout_WIDTH = 1
    INPUT_A_32 = "ADD&SUB_input_A.txt"
    INPUT_B_32 = "ADD&SUB_input_B.txt"
    OUTPUT_C_ADD = "ADD_output_C.txt"
    OUTPUT_Cout_ADD = "ADD_output_Cout.txt"
    
    # SUB
    SUB_A_SIZE = 1000
    SUB_B_SIZE = 1000
    SUB_C_SIZE = 1000
    SUB_Cout_SIZE = 1000
    SUB_A_WIDTH = 32
    SUB_B_WIDTH = 32
    SUB_C_WIDTH = 32
    SUB_Cout_WIDTH = 1
    OUTPUT_C_SUB = "SUB_output_C.txt"
    OUTPUT_Cout_SUB = "SUB_output_Cout.txt"
    
    # MUL
    MUL_M_SIZE = 1000
    MUL_Q_SIZE = 1000
    MUL_A_SIZE = 1000
    MUL_M_WIDTH = 32
    MUL_Q_WIDTH = 32
    MUL_A_WIDTH = 64  # Đã sửa từ 6e4 thành 64
    INPUT_M_MUL = "MUL_input_M.txt"
    INPUT_Q_MUL = "MUL_input_Q.txt"
    OUTPUT_A_MUL = "MUL_output_A.txt"
    
    # DIV
    DIV_Z_SIZE = 1000
    DIV_D_SIZE = 1000
    DIV_Q_SIZE = 1000
    DIV_R_SIZE = 1000
    DIV_Z_WIDTH = 64
    DIV_D_WIDTH = 32
    DIV_Q_WIDTH = 32
    DIV_R_WIDTH = 32
    INPUT_Z_DIV = "DIV_input_Z.txt"
    INPUT_D_DIV = "DIV_input_D.txt"
    OUTPUT_Q_DIV = "DIV_output_Q.txt"
    OUTPUT_R_DIV = "DIV_output_R.txt"
    
    # Đường dẫn đầy đủ
    input_file_A_ADD_SUB = os.path.join(DIRECTORY, INPUT_A_32)
    input_file_B_ADD_SUB = os.path.join(DIRECTORY, INPUT_B_32)
    output_file_C_ADD = os.path.join(DIRECTORY, OUTPUT_C_ADD)
    output_file_Cout_ADD = os.path.join(DIRECTORY, OUTPUT_Cout_ADD)
    output_file_C_SUB = os.path.join(DIRECTORY, OUTPUT_C_SUB)
    output_file_Cout_SUB = os.path.join(DIRECTORY, OUTPUT_Cout_SUB)
    input_file_M_MUL = os.path.join(DIRECTORY, INPUT_M_MUL)
    input_file_Q_MUL = os.path.join(DIRECTORY, INPUT_Q_MUL)
    output_file_A_MUL = os.path.join(DIRECTORY, OUTPUT_A_MUL)
    input_file_Z_DIV = os.path.join(DIRECTORY, INPUT_Z_DIV)
    input_file_D_DIV = os.path.join(DIRECTORY, INPUT_D_DIV)
    output_file_Q_DIV = os.path.join(DIRECTORY, OUTPUT_Q_DIV)
    output_file_R_DIV = os.path.join(DIRECTORY, OUTPUT_R_DIV)
    
    # Tổng số lượng bộ test cho mỗi phép toán
    TOTAL_TESTS_PER_OPERATION = 1000
    
    # Tạo các trường hợp cận biên
    add_sub_boundary_cases = generate_add_sub_boundary_cases()
    mul_boundary_cases = generate_mul_boundary_cases()
    div_boundary_cases = generate_div_boundary_cases()
    
    # Tạo các bộ test ngẫu nhiên
    def generate_random_add_sub_tests(num):
        tests = []
        for _ in range(num):
            a = generate_random_int32()
            b = generate_random_int32()
            tests.append((a, b))
        return tests
    
    def generate_random_mul_tests(num):
        tests = []
        for _ in range(num):
            m = generate_random_int32()
            q = generate_random_int32()
            tests.append((m, q))
        return tests
    
    def generate_random_div_tests(num):
        tests = []
        for _ in range(num):
            z = generate_random_int64()
            d = generate_random_int32()
            tests.append((z, d))
        return tests
    
    # Ghi dữ liệu vào các file
    with open(input_file_A_ADD_SUB, 'w') as f_A, \
         open(input_file_B_ADD_SUB, 'w') as f_B, \
         open(output_file_C_ADD, 'w') as f_C_add, \
         open(output_file_Cout_ADD, 'w') as f_Cout_add, \
         open(output_file_C_SUB, 'w') as f_C_sub, \
         open(output_file_Cout_SUB, 'w') as f_Cout_sub, \
         open(input_file_M_MUL, 'w') as f_M_mul, \
         open(input_file_Q_MUL, 'w') as f_Q_mul, \
         open(output_file_A_MUL, 'w') as f_A_mul, \
         open(input_file_Z_DIV, 'w') as f_Z_div, \
         open(input_file_D_DIV, 'w') as f_D_div, \
         open(output_file_Q_DIV, 'w') as f_Q_div, \
         open(output_file_R_DIV, 'w') as f_R_div:
        
        # === ADD Tests ===
        print("Generating ADD test cases...")
        # Ghi các trường hợp cận biên
        for case in add_sub_boundary_cases:
            if case[0] != 'ADD':
                continue
            op, A, B = case
            C, Cout = add_signed_32bit(A, B)
            hex_A = to_hex(A, width=32)
            hex_B = to_hex(B, width=32)
            hex_C = to_hex(C, width=32)
            hex_Cout = f'{Cout:X}'
            f_A.write(f"{hex_A}\n")
            f_B.write(f"{hex_B}\n")
            f_C_add.write(f"{hex_C}\n")
            f_Cout_add.write(f"{hex_Cout}\n")
        
        # Tính số lượng bộ test đã tạo cho ADD boundary cases
        num_add_boundary = len([1 for case in add_sub_boundary_cases if case[0] == 'ADD'])
        
        # Tạo và ghi các bộ test ngẫu nhiên cho ADD
        remaining_add = TOTAL_TESTS_PER_OPERATION - num_add_boundary
        random_add_tests = generate_random_add_sub_tests(remaining_add)
        for A, B in random_add_tests:
            C, Cout = add_signed_32bit(A, B)
            hex_A = to_hex(A, width=32)
            hex_B = to_hex(B, width=32)
            hex_C = to_hex(C, width=32)
            hex_Cout = f'{Cout:X}'
            f_A.write(f"{hex_A}\n")
            f_B.write(f"{hex_B}\n")
            f_C_add.write(f"{hex_C}\n")
            f_Cout_add.write(f"{hex_Cout}\n")
        
        print("ADD test cases generated.")
        
        # === SUB Tests ===
        print("Generating SUB test cases...")
        # Ghi các trường hợp cận biên
        for case in add_sub_boundary_cases:
            if case[0] != 'SUB':
                continue
            op, A, B = case
            C, Cout = sub_signed_32bit(A, B)
            hex_A = to_hex(A, width=32)
            hex_B = to_hex(B, width=32)
            hex_C = to_hex(C, width=32)
            hex_Cout = f'{Cout:X}'
            f_A.write(f"{hex_A}\n")
            f_B.write(f"{hex_B}\n")
            f_C_sub.write(f"{hex_C}\n")
            f_Cout_sub.write(f"{hex_Cout}\n")
        
        # Tính số lượng bộ test đã tạo cho SUB boundary cases
        num_sub_boundary = len([1 for case in add_sub_boundary_cases if case[0] == 'SUB'])
        
        # Tạo và ghi các bộ test ngẫu nhiên cho SUB
        remaining_sub = TOTAL_TESTS_PER_OPERATION - num_sub_boundary
        random_sub_tests = generate_random_add_sub_tests(remaining_sub)
        for A, B in random_sub_tests:
            C, Cout = sub_signed_32bit(A, B)
            hex_A = to_hex(A, width=32)
            hex_B = to_hex(B, width=32)
            hex_C = to_hex(C, width=32)
            hex_Cout = f'{Cout:X}'
            f_A.write(f"{hex_A}\n")
            f_B.write(f"{hex_B}\n")
            f_C_sub.write(f"{hex_C}\n")
            f_Cout_sub.write(f"{hex_Cout}\n")
        
        print("SUB test cases generated.")
        
        # === MUL Tests ===
        print("Generating MUL test cases...")
        # Ghi các trường hợp cận biên
        for case in mul_boundary_cases:
            op, M, Q = case
            A = mul_signed_32bit(M, Q)
            hex_M = to_hex(M, width=32)
            hex_Q = to_hex(Q, width=32)
            hex_A = to_hex(A, width=64)
            f_M_mul.write(f"{hex_M}\n")
            f_Q_mul.write(f"{hex_Q}\n")
            f_A_mul.write(f"{hex_A}\n")
        
        # Tính số lượng bộ test đã tạo cho MUL boundary cases
        num_mul_boundary = len(mul_boundary_cases)
        
        # Tạo và ghi các bộ test ngẫu nhiên cho MUL
        remaining_mul = TOTAL_TESTS_PER_OPERATION - num_mul_boundary
        random_mul_tests = generate_random_mul_tests(remaining_mul)
        for M, Q in random_mul_tests:
            A = mul_signed_32bit(M, Q)
            hex_M = to_hex(M, width=32)
            hex_Q = to_hex(Q, width=32)
            hex_A = to_hex(A, width=64)
            f_M_mul.write(f"{hex_M}\n")
            f_Q_mul.write(f"{hex_Q}\n")
            f_A_mul.write(f"{hex_A}\n")
        
        print("MUL test cases generated.")
        
        # === DIV Tests ===
        print("Generating DIV test cases...")
        # Ghi các trường hợp cận biên
        for case in div_boundary_cases:
            op, Z, D = case
            Q, R = div_signed_32bit(Z, D)
            hex_Z = to_hex(Z, width=64)
            hex_D = to_hex(D, width=32)
            hex_Q = to_hex(Q, width=32)
            hex_R = to_hex(R, width=32)
            f_Z_div.write(f"{hex_Z}\n")
            f_D_div.write(f"{hex_D}\n")
            f_Q_div.write(f"{hex_Q}\n")
            f_R_div.write(f"{hex_R}\n")
        
        # Tính số lượng bộ test đã tạo cho DIV boundary cases
        num_div_boundary = len(div_boundary_cases)
        
        # Tạo và ghi các bộ test ngẫu nhiên cho DIV
        remaining_div = TOTAL_TESTS_PER_OPERATION - num_div_boundary
        random_div_tests = generate_random_div_tests(remaining_div)
        for Z, D in random_div_tests:
            Q, R = div_signed_32bit(Z, D)
            hex_Z = to_hex(Z, width=64)
            hex_D = to_hex(D, width=32)
            hex_Q = to_hex(Q, width=32)
            hex_R = to_hex(R, width=32)
            f_Z_div.write(f"{hex_Z}\n")
            f_D_div.write(f"{hex_D}\n")
            f_Q_div.write(f"{hex_Q}\n")
            f_R_div.write(f"{hex_R}\n")
        
        print("DIV test cases generated.")

# ===========================
# Thực Thi
# ===========================

if __name__ == "__main__":
    generate_test_cases()
    print("Đã lưu các bộ test cho ADD, SUB, MUL, DIV vào các file tương ứng trong thư mục ../Simu/input_data")
