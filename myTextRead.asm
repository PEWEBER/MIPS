# Paige Weber 10/18/2018
# Program does the following:
#	1) Accept an ASCII .txt file as input  					!! DONE
#	2) Search the file for a user specified character
#	3) Print how many times that character occurs				!! DONE
#	4) Print the position of each character					!! DONE
#	5) Print an error message if the file doesn't exist, or has an error 	!! DONE
#	6) Print a message if the character doesn't exist			!! Done	
#	7) Indicated whether the character encountered is upper-case or lower-case,
#	   and the indexes of such occurances					!! DONE

.data
	prompt:  .asciiz "Enter the char: "
	howManyMsg: .asciiz "The specified character shows up this many times: " 
	indexMsg: .asciiz "Character found at index : "
	CharDNE: .asciiz "Your character does not show up."
	FileDNE: .asciiz "The file you specified either doesn't exist or has some error preventing it from opening."
	printLine: .asciiz "\n"
	upMsg: .asciiz "Upper case character found at index: "
	downMsg: .asciiz "Lower case character found at index: "
	
	charArray: .asciiz "pppaaaiiigePaife" #reserves 100 bytes of space
	fileName: .space 10
.text	
	
# OpenReadFile:	
	#set true counter
	# add $t1, $zero, $zero
	# Specify file name and where to store the name
	# li $v0, 8 	# Syscall for getting string input
	# la $a0, fileName 
	# li $a1, 10
	# syscall
	
	# Open file for reading
	# li $v0, 13	# Syscall for opening a file
	# la $a0, fileName 
	# li $a1, 1	# Open for reading
 	# li $a2, 0	# Mode is ignored, IDFK what that means
 	# syscall	
 	# move $s1, $v0	# Save the file descriptor into $s1
 			# If $s1 is negative, there is an error
 			
	# Check for errors in opening the file
	# slt $t1, $s1, $zero # If $s1 is negative, set $t1 to 1
	# beq $t1, 1, Error
	
 	
 	addi $t0, $0, 0
 	addi $t1, $0, 0
 	addi $t7, $0, 0
 	la $s0, charArray
 	
getChar:	
	addi $v0, $0, 12 #v0 is the character we are looking for
	syscall
	move $t6, $v0
	
	
	

Loop:
	add $s2, $s0, $t0 # address of character to compare
	
	lb $a3, ($s2)
	add $t0, $t0, 1 
	# jal Read
	# compare to getChar value

	
	
	add $t4, $t6, 32
	add $t5, $t6, -32
	beq $a3, $t5, UptrueCount
	beq $a3, $t4, DowntrueCount
	
	beq $a3, $t6, trueCount
	
	
loop2: 			
	#jump to trueCount if they are equal
	
	add $t7, $t7, 1
	add $t5, $t7, $0
	beq $t5, 25, HowManyTrue
	
	 
	j Loop 
	
HowManyTrue:
	beq $t1, $0, none
	
	#print they are equal at $t7
	la $a0, howManyMsg
	add $v0, $0, 4
	syscall
	
	beq $t1, $0, none
	#true count val	
	li $v0, 1	
	add $a0, $t1, $zero 
	syscall	

		
 	
done:  
	# Close the file 
	li $v0, 16	
	add $a0, $s1, $zero 
	syscall
	# Exit gracefully
	li $v0, 10
	syscall

Error:
	# Close the file 
	li $v0, 16	
	add $a0, $s1, $zero 
	syscall
	
	# Print error statement
	li $v0, 4
	la $a0, FileDNE # Put prompt in argument register 
	syscall
	
	# Exit gracefully
	li $v0, 10
	syscall	

UptrueCount:
	
	add $t1, $t1, 1
	
	#print they are equal at $t7
	la $a0, upMsg
	add $v0, $0, 4
	syscall
	
	li $v0, 1	
	add $a0, $t7, $zero 
	syscall
	
	la $a0, printLine
	add $v0, $0, 4
	syscall
		
	
	j loop2	
DowntrueCount:
	
	add $t1, $t1, 1
	
	#print they are equal at $t7
	la $a0, downMsg
	add $v0, $0, 4
	syscall
	
	li $v0, 1	
	add $a0, $t7, $zero 
	syscall
	
	la $a0, printLine
	add $v0, $0, 4
	syscall
		
	
	j loop2	
trueCount:
	add $t4, $s0, 20
	add $5, $s0, -20
	
	add $t1, $t1, 1
	
	#print they are equal at $t7
	la $a0, indexMsg
	add $v0, $0, 4
	syscall
	
	li $v0, 1	
	add $a0, $t7, $zero 
	syscall
	
	la $a0, printLine
	add $v0, $0, 4
	syscall
		
	
	j loop2

none:		
		#print they are equal at $t7
	la $a0, CharDNE
	add $v0, $0, 4
	syscall

	
	la $a0, printLine
	add $v0, $0, 4
	syscall
	
	j done
#Read:				
 	# Read the file that was just opened		
 	#li $v0, 14	# Read from the file just opened
 	#add $a0, $s1, $zero # $s1 contains the file
 	#la $a1, charArray  # Buffer will hold the text read from the file
 	#li $a2, 1 	# Read 100 bytes 
 	#syscall
 	#lb $a3, charArray
 	#jr $ra	
		
 		
