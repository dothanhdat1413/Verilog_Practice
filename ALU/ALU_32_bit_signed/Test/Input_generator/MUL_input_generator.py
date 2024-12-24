import os
import random

def to_twos_complement_hex(n, bits):
    """
    Chuyển đổi số nguyên có dấu sang dạng hex sử dụng bù 2 với số bit xác định.
    """
    if n < 0:
        n = (1 << bits) + n
    return format(n, f'0{bits // 4}X')

def generate_multiplication_tests():
    # Định nghĩa đường dẫn và tên tệp tin
    DIRECTORY = "../../Simu/input_data"
    INPUT_M_FILE = os.path.join(DIRECTORY, "MUL_input_M.txt")
    INPUT_Q_FILE = os.path.join(DIRECTORY, "MUL_input_Q.txt")
    OUTPUT_A_FILE = os.path.join(DIRECTORY, "MUL_output_A.txt")
    
    # Tạo thư mục nếu chưa tồn tại
    os.makedirs(DIRECTORY, exist_ok=True)
    
    # Số lượng test case
    NUM_TEST_CASES = 1000
    CATEGORIES = 7
    TESTS_PER_CATEGORY = NUM_TEST_CASES // CATEGORIES  # ~142 test case mỗi loại
    
    # Phạm vi số nguyên 32-bit có dấu
    INT32_MIN = -2147483648
    INT32_MAX = 2147483647
    
    test_cases = []
    
    # 1. M cận biên âm
    for _ in range(TESTS_PER_CATEGORY):
        M = INT32_MIN
        Q = random.randint(INT32_MIN, INT32_MAX)
        A = M * Q
        test_cases.append((M, Q, A))
    
    # 2. M cận biên dương
    for _ in range(TESTS_PER_CATEGORY):
        M = INT32_MAX
        Q = random.randint(INT32_MIN, INT32_MAX)
        A = M * Q
        test_cases.append((M, Q, A))
    
    # 3. Q cận biên âm
    for _ in range(TESTS_PER_CATEGORY):
        Q = INT32_MIN
        M = random.randint(INT32_MIN, INT32_MAX)
        A = M * Q
        test_cases.append((M, Q, A))
    
    # 4. Q cận biên dương
    for _ in range(TESTS_PER_CATEGORY):
        Q = INT32_MAX
        M = random.randint(INT32_MIN, INT32_MAX)
        A = M * Q
        test_cases.append((M, Q, A))
    
    # 5. M = 0
    for _ in range(TESTS_PER_CATEGORY):
        M = 0
        Q = random.randint(INT32_MIN, INT32_MAX)
        A = M * Q
        test_cases.append((M, Q, A))
    
    # 6. Q = 0
    for _ in range(TESTS_PER_CATEGORY):
        Q = 0
        M = random.randint(INT32_MIN, INT32_MAX)
        A = M * Q
        test_cases.append((M, Q, A))
    
    # 7. M và Q ở khoảng giữa
    for _ in range(NUM_TEST_CASES - TESTS_PER_CATEGORY * 6):
        M = random.randint(INT32_MIN + 1, INT32_MAX - 1)
        Q = random.randint(INT32_MIN + 1, INT32_MAX - 1)
        A = M * Q
        test_cases.append((M, Q, A))
    
    # Trộn các test case để không theo thứ tự nhóm
    random.shuffle(test_cases)
    
    # Ghi dữ liệu vào các tệp tin
    with open(INPUT_M_FILE, 'w') as f_m, \
         open(INPUT_Q_FILE, 'w') as f_q, \
         open(OUTPUT_A_FILE, 'w') as f_a:
        
        for M, Q, A in test_cases:
            # Chuyển đổi số sang hex với bù 2
            M_hex = to_twos_complement_hex(M, 32)
            Q_hex = to_twos_complement_hex(Q, 32)
            A_hex = to_twos_complement_hex(A, 64)  # Giả sử MUL_A_WIDTH = 64
            
            # Ghi vào tệp tin
            f_m.write(M_hex + '\n')
            f_q.write(Q_hex + '\n')
            f_a.write(A_hex + '\n')
    
    print(f"Đã tạo {NUM_TEST_CASES} bộ test cho phép nhân tại {DIRECTORY}")

if __name__ == "__main__":
    generate_multiplication_tests()
