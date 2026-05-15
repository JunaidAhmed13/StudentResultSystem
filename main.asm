.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

.data

m1 db "================================",0
m2 db "   Student Result System",0
m3 db " 1. Add Student",0
m4 db " 2. Show All",0
m5 db " 3. Search by Roll No",0
m6 db " 4. Sort by Marks",0
m7 db " 5. Show Result",0
m8 db " 6. Exit",0
m9 db "================================",0
m10 db "Enter choice: ",0

p1 db "Enter Name: ",0
p2 db "Enter Roll No: ",0
p3 db "Enter Marks (5 subjects): ",0
p4 db "Subject ",0
p5 db ": ",0

o1 db "--- Student Record ---",0
o2 db "Name: ",0
o3 db "Roll: ",0
o4 db "Marks: ",0
o5 db "Total: ",0
o6 db "Percentage: ",0
o7 db "%",0
o8 db "Result: ",0
o9 db "PASS",0
o10 db "FAIL",0
o11 db "----------------------",0
o12 db "Enter Roll to Search: ",0
o13 db "Student Found!",0
o14 db "Not Found.",0
o15 db "Sorted! (Descending)",0
o16 db "No records yet.",0
o17 db "Records full! (max 5)",0
o18 db "Press any key...",0

names  db 100 dup(0)
rolls  dd 5 dup(0)
marks  dd 25 dup(0)
totals dd 5 dup(0)
cnt    dd 0

.code

pln PROC
    call WriteString
    call Crlf
    ret
pln ENDP

addStu PROC
    mov eax, cnt
    cmp eax, 5
    jl goAdd
    mov edx, offset o17
    call pln
    jmp doneAdd

goAdd:
    mov edx, offset p1
    call WriteString
    mov eax, cnt
    mov ebx, 20
    mul ebx
    lea edx, names
    add edx, eax
    mov ecx, 19
    call ReadString

    mov edx, offset p2
    call WriteString
    call ReadInt
    mov ebx, cnt
    lea edx, rolls
    mov [edx + ebx*4], eax

    mov edx, offset p3
    call pln

    mov esi, 0
markLoop:
    cmp esi, 5
    jge marksDone
    mov edx, offset p4
    call WriteString
    mov eax, esi
    inc eax
    call WriteDec
    mov edx, offset p5
    call WriteString
    call ReadInt
    mov ebx, cnt
    imul ebx, 5
    add ebx, esi
    lea edx, marks
    mov [edx + ebx*4], eax
    inc esi
    jmp markLoop

marksDone:
    mov esi, 0
    mov ecx, 0
totalLoop:
    cmp esi, 5
    jge totalDone
    mov ebx, cnt
    imul ebx, 5
    add ebx, esi
    lea edx, marks
    mov eax, [edx + ebx*4]
    add ecx, eax
    inc esi
    jmp totalLoop

totalDone:
    mov ebx, cnt
    lea edx, totals
    mov [edx + ebx*4], ecx
    inc cnt

doneAdd:
    call Crlf
    mov edx, offset o18
    call pln
    call ReadChar
    ret
addStu ENDP

showAll PROC
    mov eax, cnt
    cmp eax, 0
    jne goShow
    mov edx, offset o16
    call pln
    jmp doneShow

goShow:
    mov esi, 0
showLoop:
    mov eax, cnt
    cmp esi, eax
    jge doneShow

    mov edx, offset o1
    call pln

    mov edx, offset o2
    call WriteString
    mov eax, esi
    mov ebx, 20
    mul ebx
    lea edx, names
    add edx, eax
    call pln

    mov edx, offset o3
    call WriteString
    lea edx, rolls
    mov eax, [edx + esi*4]
    call WriteDec
    call Crlf

    mov edx, offset o4
    call WriteString
    mov edi, 0
mshowLoop:
    cmp edi, 5
    jge mshowDone
    mov ebx, esi
    imul ebx, 5
    add ebx, edi
    lea edx, marks
    mov eax, [edx + ebx*4]
    call WriteDec
    mov al, ' '
    call WriteChar
    inc edi
    jmp mshowLoop
mshowDone:
    call Crlf

    mov edx, offset o5
    call WriteString
    lea edx, totals
    mov eax, [edx + esi*4]
    call WriteDec
    call Crlf

    mov edx, offset o6
    call WriteString
    lea edx, totals
    mov eax, [edx + esi*4]
    mov ebx, 5
    cdq
    idiv ebx
    call WriteDec
    mov edx, offset o7
    call pln

    mov edx, offset o8
    call WriteString
    lea edx, totals
    mov eax, [edx + esi*4]
    mov ebx, 5
    cdq
    idiv ebx
    cmp eax, 40
    jl showFail
    mov edx, offset o9
    call pln
    jmp showNext
showFail:
    mov edx, offset o10
    call pln
showNext:
    mov edx, offset o11
    call pln
    inc esi
    jmp showLoop

doneShow:
    mov edx, offset o18
    call pln
    call ReadChar
    ret
showAll ENDP

srch PROC
    mov edx, offset o12
    call WriteString
    call ReadInt
    mov ecx, eax

    mov esi, 0
srchLoop:
    mov eax, cnt
    cmp esi, eax
    jge notFnd
    lea edx, rolls
    mov eax, [edx + esi*4]
    cmp eax, ecx
    je fnd
    inc esi
    jmp srchLoop

fnd:
    mov edx, offset o13
    call pln
    call Crlf

    mov edx, offset o2
    call WriteString
    mov eax, esi
    mov ebx, 20
    mul ebx
    lea edx, names
    add edx, eax
    call pln

    mov edx, offset o3
    call WriteString
    lea edx, rolls
    mov eax, [edx + esi*4]
    call WriteDec
    call Crlf

    mov edx, offset o5
    call WriteString
    lea edx, totals
    mov eax, [edx + esi*4]
    call WriteDec
    call Crlf

    mov edx, offset o8
    call WriteString
    lea edx, totals
    mov eax, [edx + esi*4]
    mov ebx, 5
    cdq
    idiv ebx
    cmp eax, 40
    jl srchFail
    mov edx, offset o9
    call pln
    jmp srchDone
srchFail:
    mov edx, offset o10
    call pln
    jmp srchDone

notFnd:
    mov edx, offset o14
    call pln

srchDone:
    call Crlf
    mov edx, offset o18
    call pln
    call ReadChar
    ret
srch ENDP

sortM PROC
    mov eax, cnt
    cmp eax, 1
    jle sortDone

    mov ecx, cnt
    dec ecx
outer:
    push ecx
    mov esi, 0
inner:
    mov eax, cnt
    dec eax
    cmp esi, eax
    jge innerDone

    lea edx, totals
    mov eax, [edx + esi*4]
    mov ebx, esi
    inc ebx
    mov ecx, [edx + ebx*4]
    cmp eax, ecx
    jge noSwap

    lea edx, totals
    mov [edx + esi*4], ecx
    mov ebx, esi
    inc ebx
    mov [edx + ebx*4], eax

    lea edx, rolls
    mov eax, [edx + esi*4]
    mov ebx, esi
    inc ebx
    mov ecx, [edx + ebx*4]
    mov [edx + ebx*4], eax
    mov [edx + esi*4], ecx

    mov eax, esi
    imul eax, 20
    mov edi, eax
    mov eax, esi
    inc eax
    imul eax, 20
    mov ebp, eax
    mov ecx, 20
swapN:
    lea edx, names
    mov al, [edx + edi]
    mov ah, [edx + ebp]
    mov [edx + edi], ah
    mov [edx + ebp], al
    inc edi
    inc ebp
    dec ecx
    jnz swapN

    mov eax, esi
    imul eax, 5
    mov edi, eax
    mov eax, esi
    inc eax
    imul eax, 5
    mov ebp, eax
    mov ecx, 5
swapMk:
    lea edx, marks
    mov eax, [edx + edi*4]
    mov ebx, [edx + ebp*4]
    mov [edx + edi*4], ebx
    mov [edx + ebp*4], eax
    inc edi
    inc ebp
    dec ecx
    jnz swapMk

noSwap:
    inc esi
    jmp inner

innerDone:
    pop ecx
    dec ecx
    jnz outer

sortDone:
    mov edx, offset o15
    call pln
    call Crlf
    mov edx, offset o18
    call pln
    call ReadChar
    ret
sortM ENDP

showRes PROC
    mov eax, cnt
    cmp eax, 0
    jne goRes
    mov edx, offset o16
    call pln
    jmp doneRes

goRes:
    mov edx, offset m1
    call pln
    mov esi, 0
resLoop:
    mov eax, cnt
    cmp esi, eax
    jge doneRes

    mov eax, esi
    imul eax, 20
    lea edx, names
    add edx, eax
    call WriteString
    mov al, ' '
    call WriteChar
    call WriteChar

    lea edx, rolls
    mov eax, [edx + esi*4]
    call WriteDec
    mov al, ' '
    call WriteChar
    call WriteChar

    lea edx, totals
    mov eax, [edx + esi*4]
    call WriteDec
    mov al, ' '
    call WriteChar

    lea edx, totals
    mov eax, [edx + esi*4]
    mov ebx, 5
    cdq
    idiv ebx
    cmp eax, 40
    jl resFail
    mov edx, offset o9
    call pln
    jmp resNext
resFail:
    mov edx, offset o10
    call pln
resNext:
    inc esi
    jmp resLoop

doneRes:
    mov edx, offset m9
    call pln
    call Crlf
    mov edx, offset o18
    call pln
    call ReadChar
    ret
showRes ENDP

main PROC
    call Clrscr
menuLoop:
    call Clrscr
    mov edx, offset m1
    call pln
    mov edx, offset m2
    call pln
    mov edx, offset m9
    call pln
    mov edx, offset m3
    call pln
    mov edx, offset m4
    call pln
    mov edx, offset m5
    call pln
    mov edx, offset m6
    call pln
    mov edx, offset m7
    call pln
    mov edx, offset m8
    call pln
    mov edx, offset m9
    call pln
    mov edx, offset m10
    call WriteString
    call ReadInt

    cmp eax, 1
    je do1
    cmp eax, 2
    je do2
    cmp eax, 3
    je do3
    cmp eax, 4
    je do4
    cmp eax, 5
    je do5
    cmp eax, 6
    je do6
    jmp menuLoop

do1: call addStu
     jmp menuLoop
do2: call showAll
     jmp menuLoop
do3: call srch
     jmp menuLoop
do4: call sortM
     jmp menuLoop
do5: call showRes
     jmp menuLoop
do6: exit

main ENDP
END main
