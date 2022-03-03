#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#		starting point of HW2 MIPS programming part.
#		This is the only file you should change and submit.
#
# CS465-001 S2022
# HW2  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME
# G#
# NAME 2
# G# 2
#############################################################

#############################################################
# Data segment
#############################################################

.data


#############################################################
# Code segment
#############################################################

.text

#############################################################
# atoi
#############################################################
#############################################################
# DESCRIPTION  
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################
		
.globl atoi
atoi:
	li $t0, 0              # set the index to 0 for do while loop
	li $t5, 0              # set sum to 0 for integer calcualtion
	li $s4, 7		       # set value power of the highest order bit for 16^? calculation
	li $s1, '/'		       # set the immediate value of $s1 to represent '/' which comes before '0'
	li $t3, ':'		       # set the immediate value of $t3 to represent ':' which comes after '9'
	li $a1, 9
	la $t1, 0($a0)		       # load the base address our input of hex value into $t1
	sub $a1, $a1, 1 
    do_while:  			      
    add $t2, $t1, $t0	       # we add $t0 which is our index to our base address
    lb $t4, 0($t2)		       	# we then lb to load byte character into $s0 
	slt $t6, $s1, $t4             # we check if the value of $s0 is greater than $s1('/')which is ascii value interm of integer as 47
	slt $t7, $t4, $t3	       # we check if the value of $s0 is less than $t3 (':') which is ascii value interm of integer as 58
	beq $t6, $0, checkoption2     # if  slt yield zero we do our secound check from A to F
	beq $t7, $0, checkoption2     # if  slt yield zero we do our secound check from A to F
	sub $t4, $t4, 48	       # after it passes the check, we subtract 48 to get the actual integer value
	mul  $s5, $s4, 4		# we know based on the multiplicative property we can have 2^(4*2) to represent 16^2 so here we mulitply 4* the value of $s4
	sllv $t4,$t4, $s5		# we then do left shift by variable to do the actual integervalue*2^(value *4)
	add $t5, $t5, $t4		# we then add to sum+=value
	j Incr			       # we jump to incr 
    checkoption2:	
    sub $s0, $s0, 55
    mul  $s5, $s4, 4		# we know based on the multiplicative property  of powers we can have 2^(4*2) to represent 16^2
	sllv $t4,$t4, $s5	        # we are going to use the multipied power to use for shifting to the left
	add $t5, $t5, $t4
    Incr:
    add $t0, $t0, 1 	  # index++
    sub  $s4, $s4,1		  # subtract one from $s4 which hold the highest power 16^? value
	slt  $s6, $t0, $a1       # index < 9 jump while
	bne  $s6, $0, do_while
	addi $sp, $sp, -4
	sw  $ra, 0($sp)
	li $a0, 1
	jal report
	lw  $ra, 0($sp)
	add $sp, $sp, 4
	move $v0, $t5
	jr $ra


#############################################################
# get_type
#############################################################
#############################################################
# DESCRIPTION  
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

	
.globl get_type
get_type:
	add $t1, $0, 0xFFFFFFFF
	add $t4, $0, 0x0000003F
	add $t5, $0, 0x20
	add $t6, $0, 0x24
	add $t7, $0, 0x2a
	and $t3, $a0, $t1
	srl $t2, $a0, 26
	bne $t2, $zero, check2
	and $t3, $t3, $t4
	beq $t3, $t5, setup
	beq $t3, $t6, setup
	beq $t3, $t7, setup
	li $v0, 0xFFFFFFFF
	j ret
	check2:
	li $t4, 0x23
	li $t5,	0x04
	li $t6, 0x08
	li $t7, 0x2b
	beq $t2, $t4, setup2
	beq $t2, $t5, setup2
	beq $t2, $t6, setup2
	beq $t2, $t7, setup2

	check3:
	li $t4, 0x02
	beq $t4, $t2, setup3
	li $v0 0xFFFFFFFF
	j ret
	setup:
	li $v0, 0
	j ret
	setup2:
	li $v0, 1
	j ret
	setup3:
	li $v0, 2
	j ret
	ret:
	li $a0, 2
	addi $sp, $sp -8
	sw $v0, 4($sp)
	sw $ra, 0($sp)
	jal report
	lw $v0,  4($sp)
	lw  $ra, 0($sp)
	add $sp, $sp, 8
	jr $ra

#############################################################
# get_dest_reg
#############################################################
#############################################################
# DESCRIPTION  
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################
	
.globl get_dest_reg
get_dest_reg:
	#prepare return
	#call report() to update status
	jal report
	lw  $t2,0($a0)		# load 32-bit unsigned number from atoi to $t0
	srl $t1,$t2,26		# shift right logical 26 bits to get value for the opcode
	beq $t1,$0, r_type	# if opcode == 0, goto r_type
	li $t3,0x2		# $t3 = 2
	beq $t1,$t3,no_reg	# if opcode == 2, goto no_reg
	li $t3,0x08		# opcode == 8
	beq $t1,$t3,rt		# $t1 == $t3, goto rt
	li $t3,0x23		
	beq $t1,$t3,no_reg 	# $t1 == $t3, goto no_reg
	li $t3,0x24
	beq $t1,$t3,no_reg 	# $t1 == $t3, goto no_reg
	li $t3,0x2b
	beq $t1,$t3,no_reg 	# $t1 == $t3, goto no_reg
	j invalid		# else, goto invalid
	
cont:
	jr $ra
	
no_reg:
	li $t1, 0x20		# return 32 if no register get updated
	j cont
	
r_type:
	li $t3,0x3F		# create a mask to extract 6-bit function code
	and $t1,$t2,$t3 	# masking to get 6-bit function code 
	li $t4,0x20		# function code for 'add' instruction
	li $t5,0x24		# function code for 'and' instruction 
	li $t6,0x2a 		# function code for 'slt' instruction
	beq $t1,$t4,rd		# funct == 0x20, goto rd
	beq $t1,$t4,rd		# funct == 0x24, goto rd
	beq $t1,$t4,rd		# funct == 0x21, goto rd
	j invalid	

rd:
	srl $t1,$t2,11		# shift right logical 11 bits
	li $t3, 0x1F		# create a mask to get 5-bit rd
	and $t1,$t2,$t3		# masking 32-bit unsigned number and 0x1F to get 5-bit rd
	move $a0, $t1		# return dest_reg number 
	j cont

rt:
	srl $t1,$t2,16		# shift right logical 16 bits 
	li $t3, 0x1F		# create a mask to get 5-bit rt
	and $t1,$t2,$t3		# masking 32-bit unsigned number and 0x1F to get 5-bit rt
	move $a0, $t1		# return dest_reg number 
	j cont

invalid:
	li $t1, 0xFFFFFFFF	# return invalid
	j cont

#############################################################
# get_next_pc
#############################################################
#############################################################
# DESCRIPTION 
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

.globl get_next_pc
get_next_pc:

	#prepare return
	#call report() to update status
	jr $ra



#############################################################
# optional: other helper functions
#############################################################
				
