# extern int fibo_asm(int term)

.section .text
.global fibo_asm

fibo_asm:
    # TODO: You have to implement fibonacci with assembly language
    # HINT: You might need to use "jal(jump and link)" to finish the task
    addi sp, sp , -8
    sw s0 , 0(sp)
    sw s1 , 4(sp)
    addi s0 , a0 , 0  #save call value to s0
    #base case
    addi s1 , zero, 0 
    bne a0 , s1 , else1
        addi a0 , zero, 0;
        j return 
    else1:
    addi s1 , zero , 1;
    bne a0 ,s1 ,else2
        addi a0 , zero,1
        j return 
    else2:
    #call fibo_asm with s0 - 1
    addi sp, sp , -4
    sw ra , 0(sp)
    addi a0 , s0 , -1
    jal fibo_asm
    add s1 , a0 , zero
    #call fibo_asm with s0-2
    addi a0 , s0 , -2
    jal fibo_asm
    add a0 , a0 , s1
    lw ra , 0(sp)
    addi sp,sp,4

return:
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp,sp,8
    jr ra


    