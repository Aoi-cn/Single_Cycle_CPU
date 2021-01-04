addi $1 $0 3
addi $2 $0 6
jal test
addi $5 $0 16
addi $6 $0 10
sub $7 $6 $5
test:	add $3 $1 $2
	jr $ra
