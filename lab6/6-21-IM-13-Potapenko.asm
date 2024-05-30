.386
.model flat,stdcall
option casemap: none
include \masm32\include\masm32rt.inc
include \masm32\include\fpu.inc
includelib \masm32\lib\fpu.lib

.data
MsgBoxCaption db "6-21-IM-13-Potapenko",0

var_53 dq 53.0
var_4 dq 4.0
var_1 dq 1.0

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
Start:
    mov ebx,offset Array_A
    mov esi, 0

nextData:
    
    newData A
    newData B
    newData C
    newData D

    finit
    fld var_53
    fld varA
    
    ftst                ;перевіряємо чи знаменник дорівнює 0
    fstsw ax
    sahf
    je DIL_NULL         
    
    fdiv                ;53/a

    and ah,1            ;перевірка підкореневого на від'ємність с0=1-st(0)<0    
    jne DIL_MINUS
    
    fsqrt               ;sqrt(53/a)
    fld varD
    fadd                ;sqrt(53/a)+d
    fld var_4
    fld varB
    fmul                ;4*b
    fsub                ;sqrt(53/a)+d-4b
    
    fld varB
    fld varC
    fmul                ;b*c
    fld var_1
    fadd                ;b*c+1
    
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