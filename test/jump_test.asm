addi $9 $0 100
j test
add $3 $1 $2	#13
add $4 $3 $2	#22
test:	add $5 $1 $2	#13
	sub $6 $5 $1	#9
	j Exit
Exit:
addi $7 $0 10

test2:addi $8 $0 12