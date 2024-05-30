.386
.model flat,stdcall
option casemap: none
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\windows.inc

.data

MsgBoxCaption db "5-21-IM-13-Potapenko",0

;Macros
newData MACRO varSymbol
    mov ax, [ebx+esi]
    mov var&varSymbol&, ax
    movsx eax,var&varSymbol&
    mov var&varSymbol&_dd, eax
    add esi, 2
endm

Array_A DW 4,30,2
    DW -3,20,4
    DW 2,-51,20
    DW -5,222,1000
    DW 6,200,-102

count db 5

form db "(C + 33 - D/2)/(2*A*A - 1)",13,13,
    "A = %d",9," C = %d",9," D = %d",13,13,
    "Result = %d",9,"EndResult = %d",0
  
.data?
    buff db 256 dup(?)
    varA dw ?
    varC dw ?
    varD dw ?
    varA_dd dd ?
    varC_dd dd ?
    varD_dd dd ?
    result dw ?
    result_dd dd ? 
    endResult dd ?

.code
Start:
    mov ebx,offset Array_A
    mov esi, 0

nextData:
    newData A
    newData C
    newData D

    mov ax, varD	
    sar ax, 1 		;d/2
    sub varC, ax	;c-d/2
    add varC, 33	;c-d/2+33

    mov ax, varA
    imul ax		    ;a*a
    sal ax, 1		;2*a*a
    dec ax		    ;2*a*a-1
    mov cx, ax
  
    mov dx, 0
    cmp varC, 0
    jnl positive
    mov dx, 0ffffh

positive:
    mov ax, varC
    idiv cx		    ;(c-d/2+33)/(2*a*a-1)
    mov result,ax

    movsx eax,result
    mov result_dd,eax
    mov ax,result

    and ax, 1
    .IF ax==0           ;результат парний
        sar result, 1	;result/2
    .ELSE               ;результат непарний
        mov cx,5
        mov ax,result   
        imul cx         ;result*5
        mov result,ax   
    .ENDIF
    
    mov ax,result
    movsx eax,result
    mov endResult,eax

    invoke wsprintf, addr buff, addr form, varA_dd, varC_dd, varD_dd, result_dd, endResult
    invoke MessageBox, 0, addr buff, offset MsgBoxCaption, 0

    mov result, 0
    dec count
    jne nextData

    invoke ExitProcess, 0
end Start