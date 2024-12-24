#include <iostream>
#include <string>

using namespace std;

struct Zodiac {
    string sign;
    int startDay, startMonth;
    int endDay, endMonth;
};

const Zodiac zodiacSigns[] = {
    {"Capricorn", 22, 12, 19, 1},
    {"Aquarius", 20, 1, 18, 2},
    {"Pisces", 19, 2, 20, 3},
    {"Aries", 21, 3, 19, 4},
    {"Taurus", 20, 4, 20, 5},
    {"Gemini", 21, 5, 20, 6},
    {"Cancer", 21, 6, 22, 7},
    {"Leo", 23, 7, 22, 8},
    {"Virgo", 23, 8, 22, 9},
    {"Libra", 23, 9, 22, 10},
    {"Scorpio", 23, 10, 21, 11},
    {"Sagittarius", 22, 11, 21, 12}
};

const int numSigns = 12;

int main() {
    for(int i = 0; i < numSigns; i++) {
        cout << zodiacSigns[i].sign<< " " << zodiacSigns[i].startDay << " " << zodiacSigns[i].startMonth << " " << zodiacSigns[i].endDay << " " << zodiacSigns[i].endMonth << endl;
    }
}