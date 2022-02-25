#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#	starting point of HW1 MIPS programming part.
#
# CS465-001 S2022 HW1  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME Abenezer Gebeyehu
# G#01281469
# NAME 2
# G# 2
#############################################################

#############################################################
# DESCRIPTION OF ALGORITHMS 
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
# 1. hexdecimal string to integer value
# 2. extract n bits from index start
#############################################################

#############################################################
# Data segment
# 
# Feel free to add more data items
#############################################################
.data
	INPUTMSG: .asciiz "Enter a hexadecimal number: "
	INPUTSTARTMSG: .asciiz "Where to start extraction (31-MSB, 0-LSB)? "
	INPUTNMSG: .asciiz "How many bits to extract? "
	OUTPUTMSG: .asciiz "Input: "
	BITSMSG: .asciiz "Extracted bits: "
	ERRDIGIT: .asciiz "Error: Input has invalid digits!"
	ERRRANGE: .asciiz "Error: Input has invalid range!"
	EQUALS: .asciiz " = "
	NEWLINE: .asciiz "\n"
	ZERO: .asciiz "0"
	TEN: .asciiz "A"
	
	.align 4
	INPUT: .space 9 # 8 characters + 1 null byte

#############################################################
# Code segment
#############################################################
.text

#############################################################
# Provided entry of program execution
# DO NOT MODIFY this part
#############################################################
		
main:
	li $v0, 4
	la $a0, INPUTMSG
	syscall	# print out MSG asking for a hexadecimal
	
	li $v0, 8
	la $a0, INPUT #load address of INPUT into $a0
	li $a1, 9 # 8 characters to read in
	syscall # read in one string of 8 chars and store in INPUT
	li $v0, 4
	la $a0, NEWLINE
	syscall

#############################################################
# END of provided code that you CANNOT modify 
#############################################################
				
	
        			


		
##############################################################
# Add your code here to calculate the numeric value from INPUT 
##############################################################

report_value: 
	li $t0, 0                     #set the index to 0 for do while loop
	li $s3, 0                     #set sum to 0 for integer calcualtion
	li $s4, 7		       #set value power of the highest order bit for 16^? calculation
	li $s1, '/'		       #set the immediate value of $s1 to represent '/' which comes before '0'
	li $t3, ':'		       #set the immediate value of $t3 to represent ':' which comes after '9'
	li $t4, '@'		       #set the immediate value of $t4 to represent '@' which comes before 'A'
	li $t5, 'G'		       #set the immediate value of $t5 to represent 'G' which comes after 'F'
	la $t1, INPUT		       #load the base address our input of hex value into $t1
	sub $a1, $a1, 1               # because we are using a do_while loop we are subtracting one from $a1 for adjusting
     do_while:  			      
        add $10, $t1, $t0	       # we add $t0 which is our index to our base address
        lb $s0, 0($10)		       # we then lb to load byte character into $s0 
	slt $t6, $s1, $s0             # we check if the value of $s0 is greater than $s1('/')which is ascii value interm of integer as 47
	slt $t7, $s0, $t3	       # we check if the value of $s0 is less than $t3 (':') which is ascii value interm of integer as 58
	beq $t6, $0, checkoption2     # if  slt yield zero we do our secound check from A to F
	beq $t7, $0, checkoption2     # if  slt yield zero we do our secound check from A to F
	sub $s0, $s0, 48	       #after it passes the check, we subtract 48 to get the actual integer value
	mul  $s5, $s4, 4		#we know based on the multiplicative property we can have 2^(4*2) to represent 16^2 so here we mulitply 4* the value of $s4
	sllv $s0,$s0, $s5		# we then do left shift by variable to do the actual integervalue*2^(value *4)
	add $s3, $s3, $s0		# we then add to sum+=value
	j Incr			       # we jump to incr 
    checkoption2:
    	slt $t6, $t4, $s0		#checkoption2 does the second check from A to F
    	slt $t7, $s0, $t5		# based on immediate value at the top
    	beq $t6, $0, errorMess		# if it does not match the crietria it will jump to the error mess and exit out
    	beq $t7, $0, errorMess
    	sub $s0, $s0, 55
    	mul  $s5, $s4, 4		#we know based on the multiplicative property  of powers we can have 2^(4*2) to represent 16^2
	sllv $s0,$s0, $s5	        #we are going to use the multipied power to use for shifting to the left
	add $s3, $s3, $s0
    Incr:
        add $t0, $t0, 1 	  #index++
        sub  $s4, $s4,1		  #subtract one from $s4 which hold the highest power 16^? value
	slt  $s6, $t0, $a1       #index < 9 jump while
	bne  $s6, $0, do_while
	#$3 holds the final value for the calculation
#############################################################
# Add your code here to print the numeric value
# Hint: syscall 34: print integer as hexadecimal
#	syscall 36: print integer as unsigned
#############################################################
	li $v0, 4		#it print out the readers to inform where bit extraction should start from
	la $a0, OUTPUTMSG
	syscall
	li $v0, 34	       #it prints the value out hexadecimal
	la $a0, 0($s3)
	syscall
	li $v0, 4
	la $a0, EQUALS
	syscall		#it prints the value in unsigned integer
	li $v0, 36
	la $a0, 0($s3)
	syscall	
	li $v0, 4
	la $a0, NEWLINE
	syscall



#############################################################
# Add your code here to get two integers: start and n
#############################################################
	li  $t2, 31
	li $v0, 4
	la $a0, INPUTSTARTMSG
	syscall	# print out MSG asking for which byte to extract
	li $v0, 5
	syscall					#takes in an integer and saves to register $v0
	move $t0, $v0				#move so it does not get lost when we $vo again			
	slt $t3, $t0, $zero			#to our first comparison to check < 0 if it to jump to errorMess2
	bne $t3, $zero, errorMess2
	slt $t4, $t2, $t0
	bne $t4, $zero, errorMess2		#to our first comparison to check >31 if it to jump to errorMess2
	li $v0, 4	
	la $a0, INPUTNMSG	
	syscall					#this input message asks for n extraction
	li $v0, 5
	syscall
	move $t1, $v0
	slt $t3, $t1, $zero			# it checks if the value is less than 0 it jumps to erroMess2
	bne $t3, $zero, errorMess2
		
#############################################################
# Add your code here to extract bits and print extracted value
#############################################################
	li $t3, 2147483647			# it setup the bitmask so there are 111111111111111... in all 32 place
	srlv $s3, $s3, $t0			# we shift evey bit to the right to get rid of uncessary bit from the start to the right
	sub $t2, $t2, $t1			# then I will take by secound input and  subtracted from 31
	srlv $t3, $t3, $t2			# use that value shift mask to the right to get the mask in the correct position
	and $s3, $s3, $t3			# we then use and to extract the part we want from our original inputs.
	li $v0, 4
	la $a0, BITSMSG
	syscall
	li $v0, 34
	la $a0, 0($s3)
	syscall
	li $v0, 4
	la $a0, EQUALS
	syscall
	li $v0, 36
	la $a0, 0($s3)
	syscall	
	li $v0, 4
	la $a0, NEWLINE
	syscall
#############################################################
# Optional exit 
#############################################################
exit:
	li $v0, 10
	syscall
#compares the values from A to F
# if they fail it will jump to error mess
# if it is successful it will also calculates the value
errorMess:
	li $v0, 4
	la $a0, ERRDIGIT
	syscall
	j exit
errorMess2:
	li $v0, 4
	la $a0, ERRRANGE
	syscall
	j exit
# Example input	
# H: 0x 0   1    2    3    4    5    6    A
# B: 0000 0001 0010 0011 0100 0101 0110 1010
#    31   27   23   19   15   11   7    3  0 (index)
