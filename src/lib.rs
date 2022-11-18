extern "C" {
    fn hello_world();
}

#[no_mangle]
extern "C" fn main() {
    unsafe {
        hello_world();
    }
}
