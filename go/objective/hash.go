package main

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"strings"
)

type Hasher struct {
	key byte
}

func NewHasher(key byte) *Hasher {
	return &Hasher{key: key}
}

func (h *Hasher) GenerateSalt(length int) (string, error) {
	bytes := make([]byte, length)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

func (h *Hasher) ComputeHash(input string) string {
	var hash strings.Builder
	for _, b := range []byte(input) {
		hashedByte := b ^ h.key
		hash.WriteString(fmt.Sprintf("%02x", hashedByte))
	}
	return hash.String()
}

func main() {
	hasher := NewHasher(0xAA)
	salt, err := hasher.GenerateSalt(16)
	if err != nil {
		panic(err)
	}

	saltedInput := "password123" + salt
	hash := hasher.ComputeHash(saltedInput)

	fmt.Printf("Salt: %s\nHash: %s\n", salt, hash)
}
