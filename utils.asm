Ingame:
    mov eax, [dwEngine]
    add eax, [dwClientState]
    invoke ReadProcessMemory, [pHandle], eax, dwTemp, 4, 0
    mov eax, [dwTemp]
    add eax, [dwOffsetState]
    invoke ReadProcessMemory, [pHandle], eax, dwState, 4, 0
    ret

GetLocalTeam:
	mov eax, [dwLocalPlayer]
    add eax, 0xF0
    invoke ReadProcessMemory, [pHandle], eax, dwTemp, 4, 0
   	mov eax, [dwTemp]
    ret