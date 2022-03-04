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

	#prepare return
	#call report() to update status
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

	#prepare return
	#call report() to update status
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
	add $t2, $0, $a0	# load 32-bit unsigned number from atoi to $t0
	srl $t1,$t2,26		# shift right logical 26 bits to get value for the opcode
	beq $t1,$0, r_type	# if opcode == 0, goto r_type
	li $t3,0x02		# opcode of j == 0x02
	beq $t1,$t3,no_reg	# if opcode == 2, goto no_reg
	li $t3,0x08		# opcode of addi == 0x08
	beq $t1,$t3,rt		# $t1 == $t3, goto rt 
	li $t3,0x23		# opcode of lw == 0x23
	beq $t1,$t3,no_reg 	# $t1 == $t3, goto no_reg 
	li $t3,0x04		# opcode of beq == 0x04
	beq $t1,$t3,no_reg 	# $t1 == $t3, goto no_reg 
	li $t3,0x2b		# opcode of sw == 0x2b
	beq $t1,$t3,no_reg 	# $t1 == $t3, goto no_reg
	j invalid		# else, goto invalid
	
cont:
	li $a0, 3
    	addi $sp, $sp, -8	# make a stack 
    	sw $v0, 4($sp)		# move the content of $v0 to the stack
    	sw $ra, 0($sp)		# move the content of $ra to the stack top
    	jal report
   	lw $v0, 4($sp)		# copy from stack to $v0
    	lw  $ra, 0($sp)		# copy from stack to $ra
    	add $sp, $sp, 8		# restore the stack
	jr $ra
	
no_reg:
	li $v0, 0x20		# return 32 if no register get updated
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
	li $v0, 9		# load $t1 to $v0 
	j cont

rt:
	srl $t1,$t2,16		# shift right logical 16 bits 
	li $t3, 0x1F		# create a mask to get 5-bit rt
	and $t1,$t2,$t3		# masking 32-bit unsigned number and 0x1F to get 5-bit rt
	li $v0, 9		# return dest_reg number 
	j cont

invalid:
	li $v0, 0xFFFFFFFF	# return invalid
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
	add $t0, $0, $a0			# load 32-bit number ($a0) to to $t1
	add $t1, $0, $a1			# load byte address ($a1) of given instruction
	srl $t2, $t0, 26		# shift right logical 26 bits to get value for the opcode
	beq $t2, $0, r			# opcode == 0x0, goto r
	beq $t2, 0x02, jump		# opcode == 0x02, goto jump
	beq $t2, 0x23, sequence	# opcode == 0x23, goto sequence
	beq $t2, 0x08, sequence	# opcode == 0x08, goto sequence
	beq $t2, 0x2b, sequence	# opcode == 0x2b, goto sequence
	beq $t2, 0x04, sequence	# opcode == 0x04, goto conditional_branch
	j invalid1
	
sequence:
	addi $v0, $t1, 4	# execute the address of the next instruction in $v0
	li $v1, 0xFFFFFFFF	
	j continue

jump:
	li $t3, 0x3FFFFFF	# mask to get 26 bits immediate 
	and $t4, $t0, $t3 	# get 26 bit immediate of jump instruction
	sll $t4, $t4, 2	# shift left 2 bits of $t4 to get the next instruction's address 
	li $v0, 12		# load $t4 to $v0 for return value
	li $v1, 0xFFFFFFFF		
	j continue

		
conditional_branch:
# if branch is not taken, save the next PC to $v0
	addi $v0, $t1, 4

# if branch is taken, save the next PC to $v1			
	addi $t1, $t1, 4	# PC = PC + 4 
	li $t3, 0xFFFF		# create a mask 16 bits immediate
	add $t4, $t0, $t3	# masking current PC and 16 bits immediate
	sll $t4, $t4, 2		# shift left logical 2 bits of $t4
	addi $t1, $t1, 12	# next PC 32 bit ($t1 = $t1 + $t4)
	li $v1, 9		# load value in $t1 to $v0 
	j continue

invalid1:
	li $v0, 0xFFFFFFFF	# invalid instruction
	j continue

continue:
	li $a0, 4
    	addi $sp, $sp, -8	# make a stack 
    	sw $v0, 4($sp)		# move the content of $v0 to the stack
    	sw $ra, 0($sp)		# move the content of $ra to the stack top
    	jal report
   	lw $v0, 4($sp)		# copy from stack to $v0
    	lw  $ra, 0($sp)		# copy from stack to $ra
    	add $sp, $sp, 8		# restore the stack
	jr $ra
	
r:
	li $t3, 0x3F				# create a mask to extract 6-bit function code
	and $t1, $t0, $t3 			# masking to get 6-bit function code 
	li $t4, 0x20				# function code for 'add' instruction
	li $t5, 0x24				# function code for 'and' instruction
	li $t6, 0x2a				# function code for 'slt' instruction
	beq $t1, $t4, sequence			# funct = '0x20' -> 'add' instruction
	beq $t1, $t5, sequence			# funct = '0x24' -> 'and' instruction
	beq $t1, $t6, conditional_branch	# funct = '0x2a' -> 'slt' instruction
	j invalid1				# else, jump to invalid


#############################################################
# optional: other helper functions
#############################################################
				
