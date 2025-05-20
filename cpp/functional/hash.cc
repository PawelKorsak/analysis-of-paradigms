#include <iostream>
#include <string>
#include <random>
#include <iomanip>
#include <sstream>

// Generate hex-encoded salt (same as before)
std::string generate_salt(size_t length = 16) {
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<uint8_t> dis(0, 255);

  std::stringstream ss;
  for (size_t i = 0; i < length; ++i) {
    uint8_t byte = dis(gen);
    ss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(byte);
  }
  return ss.str();
}

// Trivial XOR-based "hash" (for demonstration only!)
std::string simple_xor_hash(const std::string& input) {
  const uint8_t key = 0xAA; // Arbitrary XOR key
  std::stringstream hash;

  for (char c : input) {
    uint8_t hashed_byte = static_cast<uint8_t>(c) ^ key;
    hash << std::hex << std::setw(2) << std::setfill('0') 
         << static_cast<int>(hashed_byte);
  }
  return hash.str();
}

int main() {
  const std::string password = "password123";
  const std::string salt = generate_salt();
  const std::string salted_input = password + salt;
  const std::string hash = simple_xor_hash(salted_input);

  std::cout << "Salt: " << salt << "\nHash: " << hash << std::endl;
  return 0;
}