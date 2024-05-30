.386
.model flat,stdcall
.data
    var_1 dq 1.0

PUBLIC znamennyk

.code
znamennyk PROC
    push ebp
    mov ebp, esp
        mov eax, [ebp+8]
        fld qword ptr [eax] ;st(0)=varC 
        mov eax, [ebp+12]
        fld qword ptr [eax] ;st(0)=varB st(1)=varC   
        fmul                ;b*c
        fld var_1           ;st(0)=1 st(1)=varC*varB
        fadd                ;b*c+1
    pop ebp
    ret 8
znamennyk endp
end
