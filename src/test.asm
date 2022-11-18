section .data
    msg: db "Hello World!", 10
    msg_len: equ $ - msg

section .text
    global hello_world
    
hello_world:
    push rbp
    mov rbp, rsp

    mov rax, 0x01
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rsp, rbp
    pop rbp

    ret