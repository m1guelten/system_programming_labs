.386
.model flat,stdcall
option casemap: none
include \masm32\include\masm32rt.inc
include \masm32\include\fpu.inc
includelib \masm32\lib\fpu.lib

.data
MsgBoxCaption db "7-21-IM-13-Potapenko",0

var_53 dq 53.0
var_4 dq 4.0

EXTRN znamennyk@0:NEAR

;Macros
newData MACRO varSymbol
    mov eax, [ebx+esi]
    mov ecx, offset var&varSymbol&
    mov [ecx], eax
    add esi, 4
    mov eax, [ebx+esi]
    mov [ecx+4], eax
    add esi,4
    invoke FloatToStr, var&varSymbol&, addr buff&varSymbol&
endm

Array_A DQ 10.5, 0.77, 1.28, 2.45
        DQ 4.25, -2.0, 0.5, 5.6
        DQ 13.25, 1.375, 6.54, 2.5
        DQ 0, 3.75, -2.54, 5.6
        DQ -13.25, 3.75, -2.54, 5.6
        DQ 3.25, -0.375, 6.54, 5.6
        DQ 4.25, 3.75, -2.54, 5.6
         
count db 7

form db "(sqrt(53/A) + D - 4*B)/(1 + B*C)",13,13,
    "A = %s",9,"B = %s",9,"C = %s",9,"D = %s",13,13,
    "Результат = %s",0
 
formError0 db "(sqrt(53/A) + D - 4*B)/(1 + B*C)",13,13,
    "A = %s",9,"B = %s",9,"C = %s",9,"D = %s",13,13,
    "Знаменник дорівнює нулю, рішення неможливе",0

formError1 db "(sqrt(53/A) + D - 4*B)/(1 + B*C)",13,13,
    "A = %s",9,"B = %s",9,"C = %s",9,"D = %s",13,13,
    "Підкореневе значення від'ємне, рішення неможливе",0
   
.data?
    buff db 256 dup(?)
    buffA db 256 dup(?)
    buffB db 256 dup(?)
    buffC db 256 dup(?)
    buffD db 256 dup(?)
    buffRes db 256 dup(?)
    varA dq ?
    varB dq ?
    varC dq ?
    varD dq ?
    result dq ?

.code
    chyselnyk1 PROC
        fld var_53          ;st(0)=53
        fld qword ptr [eax] ;st(0)=varA st(1)=53    
        fdiv                ;53/a
        fsqrt               ;sqrt(53/a)
        ret 
    chyselnyk1 ENDP

    chyselnyk2 PROC
        push ebp
        mov ebp, esp

            mov eax, [ebp+8]
            fld qword ptr [eax] ;st(0)=varD    
            fld var_4           ;st(0)=4 st(1)=varD
            mov eax, [ebp+12]
            fld qword ptr [eax] ;st(0)=varB st(1)=4 st(2)=varD    
            fmul                ;4*b
            fsub                ;d-4b
        
        pop ebp
        ret 8
    chyselnyk2 ENDP


Start:
    mov ebx,offset Array_A
    mov esi, 0
    
nextData:
    
    newData A
    newData B
    newData C
    newData D

    finit
    fld varA
    
    ftst                ;перевіряємо чи знаменник дорівнює 0
    fstsw ax
    sahf
    je DIL_NULL         
    
   
    and ah,1            ;перевірка підкореневого на від'ємність с0=1-st(0)<0    
    jne DIL_MINUS
    fstp varA
    
    mov eax, offset varA
    call chyselnyk1

    push offset varB
    push offset varD
    call chyselnyk2
    
    fadd 

    push offset varB
    push offset varC
    call znamennyk@0

        
    ftst                ;перевіряємо чи знаменник дорівнює 0
    fstsw ax
    sahf
    je DIL_NULL         
    
    fdiv                ;(sqrt(53/a)+d-4b)/(b*c+1)
    fst result
        
    invoke FpuFLtoA, offset result, 16, offset buffRes, SRC1_FPU or SRC2_DIMM
    invoke wsprintf, addr buff, addr form, addr buffA, addr buffB, addr buffC, addr buffD, addr buffRes
    invoke MessageBox, 0, addr buff, offset MsgBoxCaption, 0
    jmp EndEnter

DIL_NULL:
        invoke wsprintf, addr buff, addr formError0, addr buffA, addr buffB, addr buffC, addr buffD
        invoke MessageBox, 0, addr buff, offset MsgBoxCaption, 0
        jmp EndEnter

DIL_MINUS:
        invoke wsprintf, addr buff, addr formError1, addr buffA, addr buffB, addr buffC, addr buffD
        invoke MessageBox, 0, addr buff, offset MsgBoxCaption, 0
      
EndEnter:
    dec count
    jne nextData

    invoke ExitProcess, 0
end Start