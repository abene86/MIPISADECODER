#############################################################
# NOTE: this is the provided main program 
#       of HW2 MIPS programming part.
#		DO NOT change this file.  
#		No need to submit this file either.
#
# Author: Yutao Zhong
# CS465-001 S2022
# HW2  
#############################################################


#############################################################
# Data segment
#############################################################

.data
.globl INVALIDCODE
	INVALIDCODE: .word -1

.globl NOTUSEDCODE
	NOTUSEDCODE: .word 32
	
	INPUTMSG: .asciiz "Enter a MIPS machine word in hex: 0x"
	OUTPUTMSG: .asciiz "Input: "
	INSNTYPE: .asciiz "Instruction Type: "
	DESTREG: .asciiz "Destination Register: "
	NEXTPC: .asciiz "Next PC(s): "
	INVALID: .asciiz "invalid"
	NOTUSED: .asciiz "N/A"
	REPORTMSG: .asciiz "========================\nStage passed: "
	
	EQUALS: .asciiz " = "
	COMMA: .asciiz ", "
	SPACE: .asciiz " "

.globl NEWLINE
	NEWLINE: .asciiz "\n"
.globl ZERO
	ZERO: .asciiz "0"
.globl TEN
	TEN: .asciiz "A"

	.align 4
	INPUT: .space 9  # 8 characters + 1 null byte

#############################################################
# Code segment
#############################################################

.text

#############################################################
# main
#############################################################
	
main:
######### get input ###########
	
	la $a0, INPUTMSG
	li $v0, 4
	syscall	# print out MSG asking for one MIPS machine code
	
	la $a0, INPUT
	li $a1, 9
	li $v0, 8
	syscall # read in one string of 8 chars and store in INPUT
		
######### Step 1: atoi ##########
	# call atoi 
	la $a0, INPUT
	jal atoi

	# grab return, save returned machine code	
	add $s0, $v0, $0

	# print out return of atoi (as hex)
	la $a0, OUTPUTMSG
	li $v0, 4
	syscall
	add $a0, $s0, $0
	li $v0, 34
	syscall
	jal print_newline
	
######## end of Step 1 #################
########################################	
	
########## Step 2: get_type #######
	#call get_type
	add $a0, $s0, $0
	jal get_type
	add $s1, $v0, $0
	
	# print out return of get_type (as decimal)	
	la $a0, INSNTYPE
	li $v0, 4
	syscall
	
	lw $t0, INVALIDCODE
	bne $s1, $t0, type_print
	jal print_invalid
	j end_print_type
	
type_print:
	add $a0, $s1, $0
	li $v0, 36
	syscall
end_print_type:
	jal print_newline

######## end of Step 2 #################
########################################	
	

########## Step 3: get_dest_reg #########
	# call get_dest_reg
	add $a0, $s0, $0
	jal get_dest_reg
	add $s1, $v0, $0

	# print out return of get_dest_reg (as decimal)	
	la $a0, DESTREG
	li $v0, 4
	syscall

	lw $s2, INVALIDCODE
	bne $s1, $s2, dest_next
	jal print_invalid
	j end_print_dest
dest_next:
	lw $s2, NOTUSEDCODE
	bne $s1, $s2, print_dest
	jal print_notused
	j end_print_dest
print_dest:		 
	add $a0, $s1, $0
	li $v0, 36
	syscall
end_print_dest:
	jal print_newline

######## end of Step 3 #################
########################################	
	
########## Step 4: get_next_pc ########
	# call get_next_pc
	add $a0, $s0, $0
	add $a1, $0, $0  
	jal get_next_pc
	add $s1, $v0, $0
	add $s3, $v1, $0
	
	# print out return of get_next_pc (as hexadecimal)	
	la $a0, NEXTPC
	li $v0, 4
	syscall

	lw $s2, INVALIDCODE
	bne $s1, $s2, pc_next
	jal print_invalid
	j end_print_pc
pc_next:
	lw $s2, INVALIDCODE
	bne $s1, $s2, print_pc1
	jal print_notused
	j end_print_pc

print_pc1:		 
	add $a0, $s1, $0
	li $v0, 34
	syscall
	
	bne $s3, $s2, print_pc2
	j end_print_pc

print_pc2:
	la $a0, COMMA
	li $v0, 4
	syscall	
	add $a0, $s3, $0
	li $v0, 34
	syscall		

end_print_pc:	
	jal print_newline	

######## end of Step 4 #################
########################################	
	
exit:
	li $v0, 10
	syscall

######## end of main ###################
########################################	

#############################################################
# global subroutine: report
# Your subroutines must call this one.
#############################################################
		
.globl report
report:
	add $t0, $a0, 0
	
	la $a0, REPORTMSG
	li $v0, 4
	syscall	# print out REPORTMSG 
	add $a0, $t0, $0
	li $v0, 36
	syscall
	la $a0, NEWLINE
	li $v0, 4
	syscall	
	
	jr $ra


#############################################################
# subroutine: print_invalid
#############################################################

print_invalid:
	la $a0, INVALID
	li $v0, 4
	syscall	
	jr $ra

#############################################################
# subroutine: print_newline
#############################################################
	
print_newline:
	la $a0, NEWLINE
	li $v0, 4
	syscall	
	jr $ra

#############################################################
# subroutine: print_notused
#############################################################

print_notused:
	la $a0, NOTUSED
	li $v0, 4
	syscall	
	jr $ra

	