Triggerbot:
    mov eax, [dwLocalPlayer]
    add eax, [dwOffsetCrossId]
    invoke ReadProcessMemory, [pHandle], eax, dwCrossid, 4, 0 
    cmp [dwCrossid], 0
    jnz .check
    ret
    .check:
        push [dwCrossid]
        call GetEntityByIndex
        add esp, 4

        push eax
        call GetEntityTeam
        add esp, 4
        mov ebx, eax

        call GetLocalTeam
        add esp, 0

        cmp ebx, eax
        jne .shot
        ret
    .shot:
        mov eax, [dwClient]
        add eax, [dwForceAttack]
        invoke WriteProcessMemory, [pHandle], eax, dwForce, 4, 0
        invoke Sleep, 0xA
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

NoFlash:
    mov eax, [dwLocalPlayer]
    add eax, [dwFlashAlpha]
    invoke WriteProcessMemory, [pHandle], eax, 0, 4, 0
    ret

NoHands:
    mov eax, [dwLocalPlayer]
    add eax, [dwFlashAlpha]