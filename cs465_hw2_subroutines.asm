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
				
