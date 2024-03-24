PC:
.word 0
IR:
.word 0
ACC:
.word 5
OPERANDE:
.byte 0

.equ BIT_OPERAND, 12
.equ ADD, 0
.equ SUB, 1
.equ MUL, 2
.equ ST, 3
.equ LD, 4
.equ BR, 5
.equ BRZ, 6
.equ BRNZ, 7
.equ STOP, 8
.equ NOP, 15
.global execute_acc_asm
.text

execute_acc_asm:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

movl 8(%ebp), %edi
movl 12(%ebp), %ecx

start_exec:
    movl 8(%ebp), %edi
    xor %ebx, %ebx
    movw (PC), %bx
    movw (%edi, %ebx, 2), %ax

    # TODO: put in IR and OPERANDE correct values    
    # TODO: put in %ax the opcode                    
    movw %ax, (IR)
    movb %al, (OPERANDE)
    shr $12, %ax                                    

    cmpw $ADD, %ax
    je add_case
    # TODO: rest of cases                            
   
    cmpw $SUB, %ax
    je sub_case

    cmpw $MUL, %ax
    je mul_case
 
    cmpw $ST, %ax
    je st_case
 
    cmpw $LD, %ax
    je ld_case
 
    cmpw $BR, %ax
    je br_case
 
    cmpw $BRZ, %ax
    je brz_case
 
    cmpw $BRNZ, %ax
    je brnz_case
 
    cmpw $STOP, %ax
    je stop_case
 
    cmpw $NOP, %ax
    je end_switch

    add_case:
        xor %eax, %eax
        movb (OPERANDE), %al
        movw (%edi, %eax, 2), %ax
        addb %al, (ACC)
        jmp end_switch

    sub_case:
        # TODO: Update ACC                           
        xor %eax, %eax
        movb (OPERANDE), %al
        movw (%edi, %eax, 2), %ax
        subb %al, (ACC)               
        jmp end_switch

    mul_case:
        # TODO: Update ACC                         
        xor %eax, %eax
        movb (OPERANDE), %al
        movw (%edi, %eax, 2), %ax
        imulw (ACC)
        jmp end_switch

    st_case:
        # TODO                                      
        xor %eax, %eax
        movb (OPERANDE), %al
        movw (ACC), %bx
        movw %bx, (%edi, %eax, 2)
        jmp end_switch