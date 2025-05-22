use rand::Rng;
use itertools::Itertools;

fn generate_salt(length: usize) -> String {
    let mut rng = rand::thread_rng();
    (0..length)
        .map(|_| format!("{:02x}", rng.r#gen::<u8>()))
        .collect()
}


fn simple_xor_hash(input: &str, key: u8) -> String {
    input.bytes()
        .map(|c| c ^ key)
        .map(|hashed_byte| format!("{:02x}", hashed_byte))
        .collect()
}

fn main() {
    let password = "password123";
    let salt = generate_salt(16);
    let salted_input = format!("{}{}", password, salt);
    let hash = simple_xor_hash(&salted_input, 0xAA);
    
    println!("Salt: {}\nHash: {}", salt, hash);
}
