# extern void entry(int *arr, int t, int *arr2)

.section .text
.global asm_dp

asm_dp:
    # TODO: You have to implement dynamic programming with assembly code
    # HINT: You might need to use "slli(shift left)" to implement multiplication
    # HINT: You might need to be careful of calculating the memory address you store in your register


    #a0 = *arr
    #a1 = t
    #a2 = *dp
    
    
    #prepare for loop 1 variables
    #t0 = i 
    addi sp ,sp , -48
    sw s0 , 0(sp)
    sw s1 , 4(sp)
    sw s2 , 8(sp)
    sw s3 , 12(sp)
    sw s4 , 16(sp)
    sw s5 , 20(sp)
    sw s6 , 24(sp)
    sw s7 , 28(sp)
    sw s8 , 32(sp)
    sw s9 , 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)


    addi s0 , zero,0;
    for1:
        blt a1 ,s0, for1end 
        addi t1 , zero ,0; #dp[i]
        #prepare for loop 2 variables
        #s1 = j
        addi s1 , zero , 0;
        for2:
            addi t3 , zero , 6
            bge s1 , t3 , for2end
            slli t0 , s1 , 1
            slli t0 , t0 , 2
            add t0 , a0 , t0
            lw s2 , 0(t0)
            blt s0 , s2 , continue2
            lw s3 , 4(t0)
            
            #get dp[i - s2] + s3
            add t0 , zero,s0
            sub t0 , t0 , s2
            slli t0 , t0 , 2
            add t0 , t0 ,a2
            lw t2 ,0(t0)
            add s4 , t2 , s3
            # (t1 < s4) t1 = s4
            bge t1 , s4 , else1
                addi t1 , s4 , 0
                j endif1
            else1:
            endif1:

        continue2:
        #j++
            addi s1,s1,1
            j for2
        

        for2end:
        #put t1 into dp[s0]
        slli t0 , s0 , 2
        add t0 , t0 , a2
        sw t1 , 0(t0)
        # i++ 
        addi s0 ,s0 , 1
        j for1
    for1end:
    
    #rewirte saved register
    
    lw s0 , 0(sp)
    lw s1 , 4(sp)
    lw s2 , 8(sp)
    lw s3 , 12(sp)
    lw s4 , 16(sp)
    lw s5 , 20(sp)
    lw s6 , 24(sp)
    lw s7 , 28(sp)
    lw s8 , 32(sp)
    lw s9 , 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp ,sp , 48
    jr ra

