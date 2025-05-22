# extern int asm_entry(int *arr, int size);

.section .text
.global asm_entry

asm_entry:
    # TODO: You have to implement the xor_trick function with assembly language
    # clear the value first
    # addi sp, sp , -20
    # sw t0 , 16(sp)
    # sw t1 , 12(sp)
    # sw t2 , 8(sp)
    # sw t3 , 4(sp)
    # sw t4 , 0(sp)
    addi t0 , zero , 0 ; # s0 = ret
    addi t1 , zero , 0;  # s1 = i

for:   
    bge t1 , a1 , forend; # a1 = size
        addi t3 , zero , 4; # a0 = arr s3 = arr + i
        mul t3 , t1 , t3;
        add t3 , t3 , a0;
        lw t2 , 0(t3); # s2 = arr[s1]
        xor t0 ,t0 , t2; # ret ^= arr[s1]
        addi t1, t1 , 1; # i ++
        j for;
forend:
    mv a0 , t0;
    # lw t0 ,16(sp)
    # lw t1 , 12(sp)
    # lw t2 ,8(sp)
    # lw t3 ,4(sp)
    # lw t4 ,0 (sp)
    # addi sp , sp , 20;


    jr ra;

