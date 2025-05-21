package main

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"strings"
)

func generateSalt(length int) (string, error) {
	bytes := make([]byte, length)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

func simpleXORHash(input string, key byte) string {
	var hash strings.Builder
	for _, b := range []byte(input) {
		hashedByte := b ^ key
		hash.WriteString(fmt.Sprintf("%02x", hashedByte))
	}
	return hash.String()
}

func main() {
	password := "password123"
	salt, err := generateSalt(16)
	if err != nil {
		panic(err)
	}

	saltedInput := password + salt
	hash := simpleXORHash(saltedInput, 0xAA)

	fmt.Printf("Salt: %s\nHash: %s\n", salt, hash)
}
