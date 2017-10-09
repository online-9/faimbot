; args index
GetEntityByIndex:
	push ebp
    mov ebp, esp
    mov eax, [esp+8]
    sub eax, 1
    mov ebx, 0x10
    mul ebx
    mov [dwTemp], eax
    mov eax, [dwClient]
    add eax, [dwEntityList]
    add eax, [dwTemp]
    invoke ReadProcessMemory, [pHandle], eax, ebx, 4, 0
    mov eax, ebx
    leave 
	ret

;args pointer
GetEntityTeam:
	push ebp
    mov ebp, esp
    mov eax, [esp+8]
    add eax, 0xF0
    invoke ReadProcessMemory, [pHandle], eax, dwTemp, 4, 0
    mov eax, [dwTemp]
    leave 
	ret

GetEntityDormant:
    push ebp
    mov ebp, esp
    mov eax, [esp+8]
    add eax, 0xE9
    invoke ReadProcessMemory, [pHandle], eax, ebx, 4, 0
    mov eax, ebx
    leave
    ret