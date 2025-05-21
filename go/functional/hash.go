package main

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"strings"
)

type HashFunc func(string) string

func generateSalt(length int) (string, error) {
	bytes := make([]byte, length)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

func xorHasher(key byte) HashFunc {
	return func(input string) string {
		var hash strings.Builder
		for _, b := range []byte(input) {
			hashedByte := b ^ key
			hash.WriteString(fmt.Sprintf("%02x", hashedByte))
		}
		return hash.String()
	}
}

func main() {
	password := "password123"
	salt, err := generateSalt(16)
	if err != nil {
		panic(err)
	}

	saltedInput := password + salt
	hashFunc := xorHasher(0xAA)
	hash := hashFunc(saltedInput)

	fmt.Printf("Salt: %s\nHash: %s\n", salt, hash)
}
