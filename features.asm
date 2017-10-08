Triggerbot:
    mov eax, [dwLocalPlayer]
    add eax, [dwOffsetCrossId]
    invoke ReadProcessMemory, [pHandle], eax, dwCrossid, 4, 0 
    cmp [dwCrossid], 0
    jnz .shot
    ret
    .shot:
        mov eax, [dwClient]
        add eax, [dwForceAttack]
        invoke WriteProcessMemory, [pHandle], eax, dwForce, 4, 0
    ret

Bunnyhop:
    mov eax, [dwLocalPlayer]
    add eax, 0x100
    invoke ReadProcessMemory, [pHandle], eax, dwFlags, 4, 0
    cmp [dwFlags], 257
    je .jump
    ret
    .jump:
        mov eax, [dwClient]
        add eax, [dwForceJump]
        invoke WriteProcessMemory, [pHandle], eax, dwForce, 4, 0
    ret