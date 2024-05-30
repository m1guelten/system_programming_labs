
.486                      ; create 32 bit code
.model flat, stdcall      ; 32 bit memory model
option casemap :none      ; case sensitive

include \masm32\include\masm32rt.inc

.data
      myPassword DB "9876",0
         
     ; myPassw01     dd 039383736h
     ; myPassw02     dd 0EFEEE1E0h
  ;    myPassw02     dd 0E0E1EEEFh ;36 37 38 39 hex

   ;   myKey         dd 0D6D6D6D6h
  
      wind01Proc   PROTO :DWORD,:DWORD,:DWORD,:DWORD
      wind02       PROTO :DWORD,:DWORD,:DWORD
      wind02Proc   PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data?
      hInstance dd ?
	  hIcon dd ?

.code

start:
      mov hInstance, FUNC(GetModuleHandle,NULL)

      call main

      invoke ExitProcess,eax

main proc

    LOCAL lpArgs:DWORD

    invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT, 32
    mov lpArgs, eax

    push hIcon
    pop [eax]

    Dialog "Password Dialogs","MS Sans Serif",10, \         ; caption,font,pointsize
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \     ; style
            4, \                                            ; control count
            50,50,200,80, \                                 ; x y co-ordinates
            1024                                            ; memory buffer size

	DlgEdit     WS_TABSTOP or WS_BORDER,10,10,120,10,100   
   	DlgButton "Ok",WS_TABSTOP,155,10,30,10,IDOK
    DlgButton "Cancel",WS_TABSTOP,155,22,30,10,IDCANCEL
    DlgStatic 'Enter of password',SS_CENTER,3,23,120,9,100
  
    CallModalDialog hInstance,0,wind01Proc,ADDR lpArgs
    invoke GlobalFree, lpArgs

    ret

main endp

wind01Proc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

    LOCAL buffer:DWORD
    LOCAL hEdit :DWORD
    LOCAL tl    :DWORD

    .if uMsg == WM_INITDIALOG
      invoke SetWindowLong,hWin,GWL_USERDATA,lParam
      mov eax, lParam
      mov eax, [eax]
      invoke SendMessage,hWin,WM_SETICON,1,[eax]

    .elseif uMsg == WM_COMMAND
      .if wParam == IDOK
        invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT, 32
        mov buffer, eax

        invoke GetDlgItem,hWin,100
        mov hEdit, eax
        invoke GetWindowTextLength,hEdit

        cmp eax, 0
        je @F
        
        cmp eax, 4
        jne noPassw

        mov tl, eax
        inc tl
        invoke SendMessage,hEdit,WM_GETTEXT,tl,buffer
        
 ;       mov ebx,buffer
  ;      mov eax,[ebx]

     ;     xor eax,myKey

   ;     cmp eax, myPassw02
   ;     jne noPassw


        invoke crt__stricmp, buffer, offset myPassword
        cmp eax, 0
        jne noPassw

        invoke EndDialog,hWin,0  

        invoke GetWindowLong,hWin,GWL_USERDATA
        mov ecx, [eax]
        invoke wind02,hWin,[ecx],buffer
        jmp quit_dialog

	  noPassw:
        invoke MessageBox,hWin,SADD("Password invalid, try again"),SADD("Password message"),MB_OK
        jmp nxt
		
      @@:
        invoke MessageBox,hWin,SADD("You did not enter any text"),SADD("Password message"),MB_OK
      nxt:
        invoke GlobalFree,buffer

      .elseif wParam == IDCANCEL
        jmp quit_dialog
      .endif

    .elseif uMsg == WM_CLOSE
      quit_dialog:
         invoke EndDialog,hWin,0

    .endif

    xor eax, eax
    ret

wind01Proc endp

wind02 proc hParent:DWORD,lpIcon:DWORD,buffer:DWORD

    Dialog "My info","MS Sans Serif",10, \               ; caption,font,pointsize
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \     ; style
            4, \                                            ; control count
            50,50,200,80, \                                   ; x y co-ordinates
            1024                                            ; memory buffer size

    DlgStatic 'Password passed',SS_CENTER,10,3,120,9,100
	DlgStatic 'Potapenko Mykhailo Vitaliyovich',SS_CENTER,10,15,120,9,100
	DlgStatic '21.11.2004',SS_CENTER,10,27,120,9,100
	DlgStatic 'Zalik book 1325',SS_CENTER,10,39,120,9,100

  ; --------------------------------------------------------
  ; the use of "ADDR hParent" is to pass the address of the
  ; stack parameters in this proc to the proc being called.
  ; --------------------------------------------------------
    CallModalDialog hInstance,hParent,wind02Proc,ADDR hParent
    ret

wind02 endp

wind02Proc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

    LOCAL buffer:DWORD
    LOCAL hEdit :DWORD
    LOCAL tl    :DWORD

    .if uMsg == WM_INITDIALOG
    ; -----------------------------------------
    ; write the parameters passed in "lParam"
    ; to the dialog's GWL_USERDATA address.
    ; -----------------------------------------
      invoke SetWindowLong,hWin,GWL_USERDATA,lParam
      mov eax, lParam
      mov eax, [eax+4]
      invoke SendMessage,hWin,WM_SETICON,1,eax

 
    .elseif uMsg == WM_CLOSE
      Exit_Find_Text:
        invoke EndDialog,hWin,0

    .endif

    xor eax, eax
    ret

wind02Proc endp

end start
