#include <iostream>
#include <string>
#include <random>
#include <iomanip>
#include <sstream>

void generate_salt(std::string& salt, size_t length = 16) {
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<uint8_t> dis(0, 255);

  std::stringstream ss;
  for (size_t i = 0; i < length; ++i) {
    uint8_t byte = dis(gen);
    ss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(byte);
  }
  salt = ss.str();
}

void simple_xor_hash(const std::string& input, std::string& hash) {
  const uint8_t key = 0xAA;
  std::stringstream ss;

  for (char c : input) {
    uint8_t hashed_byte = static_cast<uint8_t>(c) ^ key;
    ss << std::hex << std::setw(2) << std::setfill('0') 
       << static_cast<int>(hashed_byte);
  }
  hash = ss.str();
}

int main() {
  std::string password = "password123";
  std::string salt, hash;

  generate_salt(salt);
  simple_xor_hash(password + salt, hash);

  std::cout << "Salt: " << salt << "\nHash: " << hash << std::endl;
  return 0;
}