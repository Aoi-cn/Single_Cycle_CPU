sort:	addi $sp,$sp,-12    #001000
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $ra,8($sp)
	addi $s0,$0,0
loop1:	slt $t0,$s0,$a0	#s0 = i,s1 = j a0 =n a1 = arr
	beq $t0,$0,exit1 #if(i<n)	
	addi $s1,$s0,-1
loop2:	slt $t0,$s1,$zero
	bne $t0,$0,exit2
	sll $t1,$s1,2
	add $t0,$a1,$t1
	lw $t1,0($t0)
	lw $t2,4($t0)
	slt $t3,$t2,$t1
	beq $t3,$0,exit2
	addi $sp,$sp,-4
	sw $a0,0($sp)
	addi $a0,$s1,0
	jal swap
	lw $a0,0($sp)
	addi $sp,$sp,4
loopCon:addi $s1,$s1,-1
	j loop2
exit2:	addi $s0,$s0,1
	j loop1
exit1:	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $ra,8($sp)
	addi $sp,$sp,12
	jr $ra
swap:	sll $t0,$a0,2
	add $t0,$a1,$t0
	lw $t1,0($t0)
	lw $t2,4($t0)
	sw $t2,0($t0)
	sw $t1,4($t0)
	jr $ra
