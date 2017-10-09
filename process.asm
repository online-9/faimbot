struct MODULEENTRY32 
    dwSize          dd ?   
    th32ModuleID    dd ? 
    th32ProcessID   dd ? 
    GlblcntUsage    dd ? 
    ProccntUsage    dd ? 
    modBaseAddr     dd ?   
    modBaseSize     dd ? 
    hModule         dd ? 
    szModule        rb 260 
    szExePath       rb 1024
ends 

Initialize:
    cinvoke printf, szWaitingProcess
    .topInit:
        invoke Sleep, 500
        invoke FindWindow, 0, szWindowTitle
        mov [tWnd], eax
        test eax, eax
        jz .topInit

        invoke GetWindowThreadProcessId, eax, pId
        cinvoke printf, szPIDFormat, [pId]

        invoke OpenProcess, PROCESS_ALL_ACCESS, FALSE, [pId]
        mov [pHandle], eax

    .initModule:
        .init:
            invoke CreateToolhelp32Snapshot, 0x8, [pId] ; 0x00000008 = TH32CS_SNAPMODULE
            mov [tmpSnap], eax
            mov [tmpProc.dwSize], sizeof.MODULEENTRY32
            invoke Module32First, [tmpSnap], tmpProc
        
        .topModule:
            ; ===========================================
            ; engine.dll
            ; ===========================================
            cinvoke stricmp, tmpProc.szModule, szEngineDll
            test eax, eax
            jz .engine
            ; ===========================================
            ; client.dll
            ; ===========================================
            cinvoke stricmp, tmpProc.szModule, szClientDll
            test eax, eax
            jz .client

            jmp .nextModule
        .engine: 
            mov eax, [tmpProc.modBaseAddr]
            mov [dwEngine], eax
            jmp .nextModule

        .client:
            mov eax, [tmpProc.modBaseAddr]
            mov [dwClient], eax

        .nextModule:
            invoke Module32Next, [tmpSnap], tmpProc
            test eax, eax
            jnz .topModule

        .end:
            invoke CloseHandle, [tmpSnap]
            cinvoke printf, szModuleFormat, szEngineDll, [dwEngine]
            cinvoke printf, szModuleFormat, szClientDll, [dwClient]
    ret