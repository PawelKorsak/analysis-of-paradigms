use rand::Rng;
use std::fmt::Write;

fn generate_salt(length: usize) -> String {
    let mut rng = rand::thread_rng();
    let mut salt = String::with_capacity(length * 2);
    
    for _ in 0..length {
        let byte: u8 = rng.r#gen();
        write!(&mut salt, "{:02x}", byte).unwrap();
    }
    salt
}

fn simple_xor_hash(input: &str, key: u8) -> String {
    let mut hash = String::with_capacity(input.len() * 2);
    
    for c in input.chars() {
        let hashed_byte = c as u8 ^ key;
        write!(&mut hash, "{:02x}", hashed_byte).unwrap();
    }
    hash
}

fn main() {
    let password = "password123";
    let salt = generate_salt(16);
    let salted_input = format!("{}{}", password, salt);
    let hash = simple_xor_hash(&salted_input, 0xAA);
    
    println!("Salt: {}\nHash: {}", salt, hash);
}