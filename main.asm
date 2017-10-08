format pe console
entry main

include 'win32a.inc'
include 'process.asm'
include 'utils.asm'
include 'features.asm'

section '.text' code executable
main:
	call Initialize
worker:
	call Ingame
	cmp [dwState], 6
	je .ingame
	jmp worker

	.ingame:
		mov eax, [dwClient]
		add eax, [dwLocalPlayerPtr]
		invoke ReadProcessMemory, [pHandle], eax, dwLocalPlayer, 4, 0 

		invoke GetAsyncKeyState, 5
        test eax, eax
        jnz .triggerKey

        invoke GetAsyncKeyState, 32
        test eax, eax
        jnz .bhopKey
        jmp worker

        .triggerKey:
			call Triggerbot
			jmp worker
		.bhopKey:
			call Bunnyhop
			jmp worker
		
exit:
    invoke ExitProcess, 0

section '.data' data  readable writeable
    tWnd    dd ?
    pId     dd ?
    pHandle dd ?

    dwEngine dd ?
    dwClient dd ?

    dwLocalPlayer   dd ?
    dwFlags         dd ?
    dwTemp 			dd ?
    dwState 		dd ?
    dwCrossid 		dd ?

    tmpProc MODULEENTRY32
    tmpSnap dd ?

section '.rdata' data readable
	debugMsg db "Salut", 10, 0

	dwForce db 0x6
	dwLocalPlayerPtr 	dd 0xAAFC3C
	dwClientState 		dd 0x5A5344
	dwOffsetState 		dd 0x108
	dwOffsetCrossId		dd 0xB294
	dwForceJump         dd 0x4F23F08
	dwForceAttack       dd 0x2ECF3DC

	szWaitingProcess 	db "Waiting for CSGO", 10, 0
	szWindowTitle 		db 'Counter-Strike: Global Offensive', 0

	szEngineDll     	db 'engine.dll', 0
    szClientDll     	db 'client.dll', 0

    ; Output message
    szValue			db "%d", 10, 0
    szPIDFormat     db 'PID: %u', 0xD, 0xA, 0
    szAddrFormat    db '0x%lx', 0xD, 0xA, 0
    szModuleFormat  db '%s @ 0x%x', 0xD, 0xA, 0

section '.idata' data readable import
    library kernel32, 'kernel32', \
            user32,   'user32', \
            msvcrt,   'msvcrt'

    include 'api\kernel32.inc'
    include 'api\user32.inc'
    import msvcrt, printf,  'printf', \
                   stricmp, '_stricmp'