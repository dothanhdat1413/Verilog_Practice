import random
import os

# ===========================
# Hàm Hỗ Trợ
# ===========================

def to_32bit_signed_hex(value):
    """
    Chuyển đổi số signed integer thành chuỗi hex 8 ký tự (big-endian).
    """
    unsigned_value = value & 0xFFFFFFFF
    hex_str = f'{unsigned_value:08X}'
    return hex_str

def to_cout_hex(value):
    """
    Chuyển đổi giá trị overflow/borrow thành chuỗi hex 1 ký tự.
    """
    return f'{value:X}'

def generate_random_int():
    """
    Tạo số nguyên ngẫu nhiên với dấu tùy ý trong phạm vi của 32-bit signed integer.
    """
    return random.randint(-2**31, 2**31 - 1)

def generate_boundary_cases():
    """
    Tạo các trường hợp cận biên cho phép cộng và phép trừ.
    """
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

def detect_overflow_add(a, b, c):
    """
    Phát hiện overflow trong phép cộng signed 32-bit.
    """
    if (a > 0 and b > 0 and c < 0) or (a < 0 and b < 0 and c >= 0):
        return 1
    else:
        return 0

def detect_overflow_sub(a, b, c):
    """
    Phát hiện overflow trong phép trừ signed 32-bit.
    """
    if (a > 0 and b < 0 and c < 0) or (a < 0 and b > 0 and c > 0):
        return 1
    else:
        return 0

def add_signed_32bit(a, b):
    """
    Thực hiện phép cộng và tính overflow flag.
    """
    # Thực hiện phép cộng và giữ lại 32 bit thấp nhất
    sum_unsigned = (a + b) & 0xFFFFFFFF

    # Chuyển đổi về signed
    if sum_unsigned & 0x80000000:
        sum_signed = sum_unsigned - 0x100000000
    else:
        sum_signed = sum_unsigned

    # Phát hiện overflow
    overflow = detect_overflow_add(a, b, sum_signed)

    # Debugging: In ra các giá trị
    print(f"ADD - A = {a} (0x{to_32bit_signed_hex(a)})")
    print(f"ADD - B = {b} (0x{to_32bit_signed_hex(b)})")
    print(f"ADD - Sum Unsigned = 0x{sum_unsigned:08X}")
    print(f"ADD - Sum Signed = {sum_signed} (0x{to_32bit_signed_hex(sum_signed)})")
    print(f"ADD - Overflow = {overflow}\n")

    return sum_signed, overflow

def sub_signed_32bit(a, b):
    """
    Thực hiện phép trừ và tính borrow/overflow flag.
    """
    # Thực hiện phép trừ và giữ lại 32 bit thấp nhất
    diff_unsigned = (a - b) & 0xFFFFFFFF

    # Chuyển đổi về signed
    if diff_unsigned & 0x80000000:
        diff_signed = diff_unsigned - 0x100000000
    else:
        diff_signed = diff_unsigned

    # Phát hiện overflow
    overflow = detect_overflow_sub(a, b, diff_signed)

    # Debugging: In ra các giá trị
    print(f"SUB - A = {a} (0x{to_32bit_signed_hex(a)})")
    print(f"SUB - B = {b} (0x{to_32bit_signed_hex(b)})")
    print(f"SUB - Diff Unsigned = 0x{diff_unsigned:08X}")
    print(f"SUB - Diff Signed = {diff_signed} (0x{to_32bit_signed_hex(diff_signed)})")
    print(f"SUB - Overflow/Borrow = {overflow}\n")

    return diff_signed, overflow

# ===========================
# Hàm Tạo và Ghi Bộ Test
# ===========================

def generate_test_cases():
    # Đảm bảo thư mục Simu tồn tại
    directory = "../../Simu/input_data"
    if not os.path.exists(directory):
        try:
            os.makedirs(directory)
            print(f"Tạo thư mục: {directory}")
        except Exception as e:
            print(f"Lỗi khi tạo thư mục {directory}: {e}")
            return
    else:
        print(f"Thư mục đã tồn tại: {directory}")

    # Định nghĩa các file
    output_file_C_ADD = os.path.join(directory, "ADD_output_C.txt")
    output_file_Cout_ADD = os.path.join(directory, "ADD_output_Cout.txt")
    output_file_C_SUB = os.path.join(directory, "SUB_output_C.txt")
    output_file_Cout_SUB = os.path.join(directory, "SUB_output_Cout.txt")
    input_file_A = os.path.join(directory, "ADD&SUB_input_A.txt")
    input_file_B = os.path.join(directory, "ADD&SUB_input_B.txt")

    # Tổng số lượng bộ cần tạo
    num_entries = 1000

    # Tạo các trường hợp cận biên
    print("Tạo các trường hợp cận biên...")
    boundary_cases = generate_boundary_cases()

    # Ghi các giá trị vào file
    try:
        with open(input_file_A, 'w') as f_A, \
             open(input_file_B, 'w') as f_B, \
             open(output_file_C_ADD, 'w') as f_C_add, \
             open(output_file_Cout_ADD, 'w') as f_Cout_add, \
             open(output_file_C_SUB, 'w') as f_C_sub, \
             open(output_file_Cout_SUB, 'w') as f_Cout_sub:

            # Ghi các trường hợp cận biên vào file đầu tiên (input)
            print("Ghi các trường hợp cận biên...")
            for A, B in boundary_cases:
                hex_A = to_32bit_signed_hex(A)
                hex_B = to_32bit_signed_hex(B)
                f_A.write(f"{hex_A}\n")
                f_B.write(f"{hex_B}\n")

                # Tính C = A + B và Cout (overflow) cho ADD
                C_add, Cout_add = add_signed_32bit(A, B)
                hex_C_add = to_32bit_signed_hex(C_add)
                hex_Cout_add = to_cout_hex(Cout_add)  # Chỉ lấy giá trị Overflow
                f_C_add.write(f"{hex_C_add}\n")
                f_Cout_add.write(f"{hex_Cout_add}\n")

                # Tính C = A - B và Cout (borrow/overflow) cho SUB
                C_sub, Cout_sub = sub_signed_32bit(A, B)
                hex_C_sub = to_32bit_signed_hex(C_sub)
                hex_Cout_sub = to_cout_hex(Cout_sub)  # Chỉ lấy giá trị Overflow/Borrow
                f_C_sub.write(f"{hex_C_sub}\n")
                f_Cout_sub.write(f"{hex_Cout_sub}\n")

            # Tiếp tục tạo các bộ test ngẫu nhiên cho đến khi đủ số lượng
            remaining = num_entries - len(boundary_cases)
            print(f"Ghi {remaining} bộ test ngẫu nhiên cho ADD và SUB...")
            for idx in range(1, remaining + 1):
                A = generate_random_int()
                B = generate_random_int()

                hex_A = to_32bit_signed_hex(A)
                hex_B = to_32bit_signed_hex(B)
                f_A.write(f"{hex_A}\n")
                f_B.write(f"{hex_B}\n")

                # Tính C = A + B và Cout (overflow) cho ADD
                C_add, Cout_add = add_signed_32bit(A, B)
                hex_C_add = to_32bit_signed_hex(C_add)
                hex_Cout_add = to_cout_hex(Cout_add)  # Chỉ lấy giá trị Overflow
                f_C_add.write(f"{hex_C_add}\n")
                f_Cout_add.write(f"{hex_Cout_add}\n")

                # Tính C = A - B và Cout (borrow/overflow) cho SUB
                C_sub, Cout_sub = sub_signed_32bit(A, B)
                hex_C_sub = to_32bit_signed_hex(C_sub)
                hex_Cout_sub = to_cout_hex(Cout_sub)  # Chỉ lấy giá trị Overflow/Borrow
                f_C_sub.write(f"{hex_C_sub}\n")
                f_Cout_sub.write(f"{hex_Cout_sub}\n")

                if idx % 100 == 0:
                    print(f"Đã ghi {idx} / {remaining} bộ test SUB ngẫu nhiên...")

        print(f"Đã lưu {num_entries} bộ test vào các file:")
        print(f"{input_file_A}")
        print(f"{input_file_B}")
        print(f"{output_file_C_ADD}")
        print(f"{output_file_Cout_ADD}")
        print(f"{output_file_C_SUB}")
        print(f"{output_file_Cout_SUB}")

    except Exception as e:
        print(f"Đã xảy ra lỗi khi ghi dữ liệu: {e}")

# ===========================
# Thực Thi
# ===========================

if __name__ == "__main__":
    try:
        print("Bắt đầu tạo dữ liệu test cho ADD và SUB...")
        generate_test_cases()
        print("Đã hoàn thành tạo dữ liệu test cho ADD và SUB.")
    except Exception as e:
        print(f"Đã xảy ra lỗi trong quá trình tạo dữ liệu test: {e}")
