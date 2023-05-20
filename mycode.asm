.model small
.stack 100h
.data 
    crlf db 13, 10, '$'
    tb db '******* May tinh chi so BMI (Body Mass Index) *******$'
    tb1 db 'Nhap chieu cao (cm): $'
    tb2 db 'Nhap can nang (kg): $' 
    tb3 db 'Chi so BMI cua ban xap xi: $'
    
    result db 'Ban dang bi thieu can$'
    result1 db 'Ban co can nang ly tuong$'
    result2 db 'Ban dang bi thua can$'
    result3 db 'Ban dang bi beo phi$'
    
    chieucao dw ?
    cannang dw ?
    tmp dw ?
    x dw ?
    y dw ?    
    count db 0                     
    
    loikhuyen db 'Sau day la nhung loi khuyen giup cai thien chi so BMI cua ban: $'
    
    gay1 db 13, 10, '1. Tieu thu cac thuc pham giau calo.$'
    gay2 db 13, 10, '2. Ngu du 8 tieng 1 ngay.$'
    gay3 db 13, 10, '3. Uong 3 lit nuoc 1 ngay.$'
    
    beo1 db 13, 10, '1. Chon che do an kieng voi luong calo thap.$'
    beo2 db 13, 10, '2. Han che tieu thu do an nhanh.$'
    beo3 db 13, 10, '3. Tap the duc, the thao hang ngay.$'
    
    tb4 db 13, 10, 'Nhan 1 de tinh lai BMI.$'
    tb5 db 13, 10, 'Nhan 2 de thoat chuong trinh.$' 
    
.code

; x <19 : can nang thap (gay)
; 19 <= x < 25: binh thuong
; 25 <= x < 29 : thua can
; x >= 30: Beo phi

MAIN proc
    mov ax, @data
    mov ds, ax
    
batdau:     
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
    
    mov ah, 9
    lea dx, tb
    int 21h
    
    call endl
    mov ah, 9
    lea dx, tb1
    int 21h        
        
    xor ax, ax    
    call NhapSo 
    mov chieucao, ax
    call endl
    
    mov ah, 9
    lea dx, tb2
    int 21h
    
    xor ax, ax
    call NhapSo
    mov cannang, ax
    call endl 
    call endl 
    
    mov ah, 9
    lea dx, tb3
    int 21h
    
    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx
    
    mov bx, 100
    mov ax, cannang
    
    mul bx
    mov bx, chieucao
    div bx
    
    mov bx, 100
    xor dx, dx
    mul bx
    
    mov bx, chieucao
    xor dx, dx
    div bx  
      
    call InSo
    call endl  
    call endl
    
    mov tmp, ax
    cmp tmp, 19
    jl underweight
    cmp tmp, 25
    jl perfect
    cmp tmp, 30
    jl overweight
    jge obesity
    
    
    underweight:
        mov ah, 9
        lea dx, result
        int 21h   
        
        call endl
        
        mov ah, 9
        lea dx, loikhuyen
        int 21h   
        
        mov ah, 9
        lea dx, gay1
        int 21h     
        
        mov ah, 9
        lea dx, gay2
        int 21h     
        
        mov ah, 9
        lea dx, gay3
        int 21h 
       
        jmp thoat
     
    perfect:
        mov ah, 9
        lea dx, result1
        int 21h
        jmp thoat
   
    overweight:
        mov ah, 9
        lea dx, result2
        int 21h       
        
        call endl
        
        mov ah, 9
        lea dx, loikhuyen
        int 21h          
        
        mov ah, 9
        lea dx, beo1
        int 21h     
        
        mov ah, 9
        lea dx, beo2
        int 21h     
        
        mov ah, 9
        lea dx, beo3
        int 21h 
        
        jmp thoat
    
    obesity:
        mov ah, 9
        lea dx, result3
        int 21h               
        
        call endl
        
        mov ah, 9
        lea dx, loikhuyen
        int 21h     
        
        mov ah, 9
        lea dx, beo1
        int 21h     
        
        mov ah, 9
        lea dx, beo2
        int 21h     
        
        mov ah, 9
        lea dx, beo3
        int 21h 
     
thoat: 
    call endl
    mov ah, 9
    lea dx, tb4
    int 21h    
    
    mov ah, 9
    lea dx, tb5
    int 21h    
nhaplai:    
    mov ah, 1
    int 21h
    cmp al, '1'
    je replay
    cmp al, '2'
    je ketthuc
    jmp nhaplai
          
ketthuc:    
    mov ah, 4CH
    int 21h
MAIN endp

NhapSo proc
    mov x, 0
    mov y, 0
    mov bx, 10
    nhap:
        mov ah, 1
        int 21h
        
        cmp al, 13
        je nhapXong
        
        sub al, '0'
        mov ah, 0
        mov y, ax
        
        mov ax, x
        mul bx
        add ax, y
        
        mov x, ax
        jmp nhap
        
    nhapXong:
        mov ax, x
        ret
        
NhapSo endp   

InSo proc
    push ax
    push bx
    push cx
    push dx
    
    mov cl, 10
LAP1:
    mov dx, 0
    div cx
    add dl, 30h
    push dx
    inc count
    cmp ax, 0
    jne LAP1
LAP2:
    pop dx
    mov ah, 2
    int 21h
    dec count
    cmp count, 0
    jne LAP2
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
InSo endp

endl proc
    push ax
    push dx
    
    mov ah, 9
    lea dx, crlf
    int 21h
    
    pop dx
    pop ax
    
    ret
endl endp  

replay proc
    mov ah, 00
    mov al, 02
    int 10h
    jmp batdau
    ret
replay endp

END MAIN