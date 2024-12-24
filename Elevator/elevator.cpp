#include <iostream>
#include <bitset>
#include <vector>

class elevator {
    public:
        std::bitset<5> cur_fl{0b00001}; // ở tầng nào thì bit ở đo bằng 1
        std::bitset<2> dir{0b00};// 00 là đi xuống, 11 là đi lên, 01 là dừng sau khi đi xuống, 10 là dừng sau khi đi lên
        std::bitset<1> door{0b0};// 0 là đóng, 1 là mở
        std::bitset<5> mov_fl{0b00000};// tầng nào cần di chuyển tới thì sẽ bật là 1
        std::vector<std::vector<std::bitset<1>>> cal_fl; // các tầng gọi thang và hướng đi mong muốn của người gọi, sử dụng 1 mảng gồm 5 hàng 2 cột các ptu 1 bit để biểu diễn, tầng nào gọi thang thì cột 0 hàng (tầng) = 1, đi lên thì là 1, đi xuống thì là 0, ví dụ là tầng 4 gọi thang đi xuống thì sẽ là cal[4]=10;
        elevator();
    private:
};

elevator::elevator(): cal_fl(5, std::vector<std::bitset<1>>(2)) {
    cur_fl=0b00000;
}



int main(){
    elevator e;
    std::cout << e.cur_fl << std::endl;
    return 0;
}


