#include <iostream>
#include <string>
#include <random>
#include <memory>
#include <iomanip>
#include <sstream>

class Hasher {
public:
  virtual ~Hasher() = default;
  virtual std::string generateSalt(size_t length = 16) = 0;
  virtual std::string hash(const std::string& data) = 0;
};

class XORHasher : public Hasher {
public:
  std::string generateSalt(size_t length) override {
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

  std::string hash(const std::string& data) override {
    const uint8_t key = 0xAA;
    std::stringstream ss;

    for (char c : data) {
      uint8_t hashed_byte = static_cast<uint8_t>(c) ^ key;
      ss << std::hex << std::setw(2) << std::setfill('0') 
         << static_cast<int>(hashed_byte);
    }
    return ss.str();
  }
};

class HashingService {
private:
  std::unique_ptr<Hasher> hasher;

public:
  explicit HashingService(std::unique_ptr<Hasher>&& hasherImpl)
    : hasher(std::move(hasherImpl)) {}

  void hashAndPrint(const std::string& password) {
    const std::string salt = hasher->generateSalt();
    const std::string hash = hasher->hash(password + salt);
    std::cout << "Salt: " << salt << "\nHash: " << hash << std::endl;
  }
};

int main() {
  auto hasher = std::make_unique<XORHasher>();
  HashingService service(std::move(hasher));
  service.hashAndPrint("password123");
  return 0;
}