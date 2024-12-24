# import os
# import random

# # Các hằng số
# DIV_Z_SIZE = 1000
# DIV_D_SIZE = 1000
# DIV_Q_SIZE = 1000
# DIV_R_SIZE = 1000
# DIV_Z_WIDTH = 64
# DIV_D_WIDTH = 32
# DIV_Q_WIDTH = 32
# DIV_R_WIDTH = 32

# INPUT_Z_DIV = "DIV_input_Z.txt"
# INPUT_D_DIV = "DIV_input_D.txt"
# OUTPUT_Q_DIV = "DIV_output_Q.txt"
# OUTPUT_R_DIV = "DIV_output_R.txt"
# OUTPUT_FLAG_OVERFLOW_DIV = "DIV_flag_overflow.txt"

# DIRECTORY = "../../Simu/input_data"

# # Hàm chuyển đổi số dấu sang Hex trong dạng bù 2
# def signed_to_hex(value, width):
#     if value < 0:
#         value = (1 << width) + value
#     hex_width = width // 4
#     return format(value, f'0{hex_width}X')

# # Hàm tạo số nguyên ngẫu nhiên trong khoảng cho phép
# def generate_random_signed(min_val, max_val):
#     return random.randint(min_val, max_val)

# # Hàm đảm bảo thư mục tồn tại
# def ensure_directory(path):
#     os.makedirs(path, exist_ok=True)

# # Hàm tạo các test case cho bộ chia
# def generate_div_tests():
#     # Các loại trường hợp cần tạo
#     categories = {
#         'Z_min': DIV_Z_SIZE // 8,
#         'Z_max': DIV_Z_SIZE // 8,
#         'D_min': DIV_Z_SIZE // 8,
#         'D_max': DIV_Z_SIZE // 8,
#         'Z_zero': DIV_Z_SIZE // 8,
#         'D_zero': DIV_Z_SIZE // 8,
#         'Z_D_mid': DIV_Z_SIZE // 8,
#         'Z_large_D_small': DIV_Z_SIZE - 7*(DIV_Z_SIZE //8)  # Trường hợp còn lại
#     }

#     # Giá trị tối thiểu và tối đa cho Z và D
#     Z_min_val = -2**63
#     Z_max_val = 2**63 -1
#     D_min_val = -2**31
#     D_max_val = 2**31 -1
#     Q_min = -2**31
#     Q_max = 2**31 -1

#     # Danh sách lưu trữ các giá trị
#     Z_list, D_list, Q_list, R_list, Overflow_list = [], [], [], [], []

#     # Tạo test case cho từng loại
#     for category, count in categories.items():
#         for _ in range(count):
#             if category == 'Z_min':
#                 Z = Z_min_val
#                 D = generate_random_signed(-1000, 1000)
#                 if D == 0:
#                     D = 1  # Tránh chia cho 0
#             elif category == 'Z_max':
#                 Z = Z_max_val
#                 D = generate_random_signed(-1000, 1000)
#                 if D == 0:
#                     D = 1
#             elif category == 'D_min':
#                 D = D_min_val
#                 Z = generate_random_signed(-1000, 1000)
#             elif category == 'D_max':
#                 D = D_max_val
#                 Z = generate_random_signed(-1000, 1000)
#             elif category == 'Z_zero':
#                 Z = 0
#                 D = generate_random_signed(-2**31, 2**31 -1)
#                 if D == 0:
#                     D = 1
#             elif category == 'D_zero':
#                 Z = generate_random_signed(-2**63, 2**63 -1)
#                 D = 0
#             elif category == 'Z_D_mid':
#                 Z = generate_random_signed(-1000000, 1000000)
#                 D = generate_random_signed(-1000000, 1000000)
#                 if D == 0:
#                     D = 1
#             elif category == 'Z_large_D_small':
#                 Z = generate_random_signed(2**30, 2**63 -1) * random.choice([-1,1])
#                 D = generate_random_signed(1, 1000) * random.choice([-1,1])
#             else:
#                 # Trường hợp không xác định, tạo ngẫu nhiên
#                 Z = generate_random_signed(-2**63, 2**63 -1)
#                 D = generate_random_signed(-2**31, 2**31 -1)
#                 if D == 0:
#                     D = 1

#             # Kiểm tra D không bằng 0 ngoại trừ category 'D_zero'
#             if category != 'D_zero':
#                 assert D != 0, f"D should not be zero in category {category}"

#             # Tính toán Q, R và kiểm tra overflow
#             if D == 0:
#                 Q, R, Overflow = 0, 0, 1  # Chia cho 0 được xem là overflow
#                 print(f"Division by zero detected: Z={Z}, D={D}, Overflow={Overflow}")
#             else:
#                 Q = Z // D
#                 R = Z % D
#                 Overflow = 1 if Q < Q_min or Q > Q_max else 0
#                 # Cắt Q và R theo bit width
#                 Q &= 0xFFFFFFFF
#                 R &= 0xFFFFFFFF

#             # Đảm bảo Overflow được đặt đúng
#             if D == 0:
#                 assert Overflow == 1, "Overflow flag should be 1 when D is zero."

#             # Chuyển đổi sang Hex
#             Z_hex = signed_to_hex(Z, DIV_Z_WIDTH)
#             D_hex = signed_to_hex(D, DIV_D_WIDTH)
#             Q_hex = signed_to_hex(Q, DIV_Q_WIDTH)
#             R_hex = signed_to_hex(R, DIV_R_WIDTH)

#             # Thêm vào danh sách
#             Z_list.append(Z_hex)
#             D_list.append(D_hex)
#             Q_list.append(Q_hex)
#             R_list.append(R_hex)
#             Overflow_list.append(str(Overflow))

#     # Ghi dữ liệu vào các file
#     with open(os.path.join(DIRECTORY, INPUT_Z_DIV), 'w') as fz, \
#          open(os.path.join(DIRECTORY, INPUT_D_DIV), 'w') as fd, \
#          open(os.path.join(DIRECTORY, OUTPUT_Q_DIV), 'w') as fq, \
#          open(os.path.join(DIRECTORY, OUTPUT_R_DIV), 'w') as fr, \
#          open(os.path.join(DIRECTORY, OUTPUT_FLAG_OVERFLOW_DIV), 'w') as foverflow:
#         for z, d, q, r, overflow in zip(Z_list, D_list, Q_list, R_list, Overflow_list):
#             fz.write(z + '\n')
#             fd.write(d + '\n')
#             fq.write(q + '\n')
#             fr.write(r + '\n')
#             foverflow.write(overflow + '\n')

#     # Đếm số lượng các trường hợp Overflow và D_zero
#     overflow_count = sum(1 for overflow in Overflow_list if overflow == '1')
#     d_zero_count = categories.get('D_zero', 0)
#     print(f"Tổng số trường hợp Overflow: {overflow_count}")
#     print(f"Tổng số trường hợp D_zero: {d_zero_count}")
#     print("Đã tạo xong các test case cho bộ chia (DIV).")

# # Thực thi hàm chính
# def main():
#     # Đảm bảo thư mục lưu file tồn tại
#     ensure_directory(DIRECTORY)
#     # Tạo test case cho DIV
#     generate_div_tests()
#     print("Tất cả các test case cho DIV đã được tạo thành công.")

# if __name__ == "__main__":
#     main()


import os
import random

# Các hằng số
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
OUTPUT_FLAG_OVERFLOW_DIV = "DIV_flag_overflow.txt"

DIRECTORY = "../../Simu/input_data"

# Hàm chuyển đổi số dấu sang Hex trong dạng bù 2
def signed_to_hex(value, width):
    if value < 0:
        value = (1 << width) + value
    hex_width = width // 4
    return format(value, f'0{hex_width}X')

# Hàm tạo số nguyên ngẫu nhiên trong khoảng cho phép
def generate_random_signed(min_val, max_val):
    return random.randint(min_val, max_val)

# Hàm đảm bảo thư mục tồn tại
def ensure_directory(path):
    os.makedirs(path, exist_ok=True)

# Hàm tạo các test case cho bộ chia
def generate_div_tests():
    # Các loại trường hợp cần tạo
    categories = {
        'Z_min': DIV_Z_SIZE // 8,
        'Z_max': DIV_Z_SIZE // 8,
        'D_min': DIV_Z_SIZE // 8,
        'D_max': DIV_Z_SIZE // 8,
        'Z_zero': DIV_Z_SIZE // 8,
        'D_zero': DIV_Z_SIZE // 8,
        'Z_D_mid': DIV_Z_SIZE // 8,
        'Z_large_D_small': DIV_Z_SIZE - 7*(DIV_Z_SIZE //8)  # Trường hợp còn lại
    }

    # Giá trị tối thiểu và tối đa cho Z và D
    Z_min_val = -2**63
    Z_max_val = 2**63 -1
    D_min_val = -2**31
    D_max_val = 2**31 -1
    Q_min = -2**31
    Q_max = 2**31 -1

    # Danh sách lưu trữ các giá trị
    Z_list, D_list, Q_list, R_list, Overflow_list = [], [], [], [], []

    # Tạo test case cho từng loại
    for category, count in categories.items():
        for _ in range(count):
            if category == 'Z_min':
                Z = Z_min_val
                D = generate_random_signed(-1000, 1000)
                if D == 0:
                    D = 1  # Tránh chia cho 0
            elif category == 'Z_max':
                Z = Z_max_val
                D = generate_random_signed(-1000, 1000)
                if D == 0:
                    D = 1
            elif category == 'D_min':
                D = D_min_val
                Z = generate_random_signed(-1000, 1000)
            elif category == 'D_max':
                D = D_max_val
                Z = generate_random_signed(-1000, 1000)
            elif category == 'Z_zero':
                Z = 0
                D = generate_random_signed(-2**31, 2**31 -1)
                if D == 0:
                    D = 1
            elif category == 'D_zero':
                Z = generate_random_signed(-2**63, 2**63 -1)
                D = 0
            elif category == 'Z_D_mid':
                Z = generate_random_signed(-1000000, 1000000)
                D = generate_random_signed(-1000000, 1000000)
                if D == 0:
                    D = 1
            elif category == 'Z_large_D_small':
                Z = generate_random_signed(2**30, 2**63 -1) * random.choice([-1,1])
                D = generate_random_signed(1, 1000) * random.choice([-1,1])
            else:
                # Trường hợp không xác định, tạo ngẫu nhiên
                Z = generate_random_signed(-2**63, 2**63 -1)
                D = generate_random_signed(-2**31, 2**31 -1)
                if D == 0:
                    D = 1

            # Kiểm tra D không bằng 0 ngoại trừ category 'D_zero'
            if category != 'D_zero':
                assert D != 0, f"D should not be zero in category {category}"

            # Tính toán Q, R và kiểm tra overflow
            if D == 0:
                Q, R, Overflow = 0, 0, 1  # Chia cho 0 được xem là overflow
                print(f"Division by zero detected: Z={Z}, D={D}, Overflow={Overflow}")
            else:
                Q = Z // D
                R = Z % D

                # Điều chỉnh R và Q để R cùng dấu với Z
                if (R != 0) and ((Z < 0 and R > 0) or (Z > 0 and R < 0)):
                    if (R > 0 and D > 0) or (R < 0 and D < 0): # Nếu R và D cùng dấu
                        R = R - D
                        Q = Q + 1
                    else:
                        R = R + D
                        Q = Q - 1

                Overflow = 1 if Q < Q_min or Q > Q_max else 0

                # Cắt Q và R theo bit width
                Q &= 0xFFFFFFFF
                R &= 0xFFFFFFFF

            # Đảm bảo Overflow được đặt đúng
            if D == 0:
                assert Overflow == 1, "Overflow flag should be 1 when D is zero."

            # Chuyển đổi sang Hex
            Z_hex = signed_to_hex(Z, DIV_Z_WIDTH)
            D_hex = signed_to_hex(D, DIV_D_WIDTH)
            Q_hex = signed_to_hex(Q, DIV_Q_WIDTH)
            R_hex = signed_to_hex(R, DIV_R_WIDTH)

            # Thêm vào danh sách
            Z_list.append(Z_hex)
            D_list.append(D_hex)
            Q_list.append(Q_hex)
            R_list.append(R_hex)
            Overflow_list.append(str(Overflow))

    # Ghi dữ liệu vào các file
    with open(os.path.join(DIRECTORY, INPUT_Z_DIV), 'w') as fz, \
         open(os.path.join(DIRECTORY, INPUT_D_DIV), 'w') as fd, \
         open(os.path.join(DIRECTORY, OUTPUT_Q_DIV), 'w') as fq, \
         open(os.path.join(DIRECTORY, OUTPUT_R_DIV), 'w') as fr, \
         open(os.path.join(DIRECTORY, OUTPUT_FLAG_OVERFLOW_DIV), 'w') as foverflow:
        for z, d, q, r, overflow in zip(Z_list, D_list, Q_list, R_list, Overflow_list):
            fz.write(z + '\n')
            fd.write(d + '\n')
            fq.write(q + '\n')
            fr.write(r + '\n')
            foverflow.write(overflow + '\n')

    # Đếm số lượng các trường hợp Overflow và D_zero
    overflow_count = sum(1 for overflow in Overflow_list if overflow == '1')
    d_zero_count = categories.get('D_zero', 0)
    print(f"Tổng số trường hợp Overflow: {overflow_count}")
    print(f"Tổng số trường hợp D_zero: {d_zero_count}")
    print("Đã tạo xong các test case cho bộ chia (DIV).")

# Thực thi hàm chính
def main():
    # Đảm bảo thư mục lưu file tồn tại
    ensure_directory(DIRECTORY)
    # Tạo test case cho DIV
    generate_div_tests()
    print("Tất cả các test case cho DIV đã được tạo thành công.")

if __name__ == "__main__":
    main()
