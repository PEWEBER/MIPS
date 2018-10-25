# Paige Weber 10/18/2018
# Program does the following:
#	1) Accept an ASCII .txt file as input  					!! DONE
#	2) Search the file for a user specified character
#	3) Print how many times that character occurs
#	4) Print the position of each character
#	5) Print an error message if the file doesn't exist, or has an error 	!! DONE
#	6) Print a message if the character doesn't exist			
#	7) Indicated whether the character encountered is upper-case or lower-case,
#	   and the indexes of such occurances

.data
	prompt:  .asciiz "Enter the char: "
	howManyMsg: .asciiz "The specified character shows up this many times: " 
	indexMsg: .asciiz "The character shows up at this index/position : "
	CharDNE: .asciiz "Your character does not show up."
	FileDNE: .asciiz "The file you specified either doesn't exist or has some error preventing it from opening."
	printLine: .asciiz "\n"
	
	charArray:  .space  100 #reserves 100 bytes of space
	fileName: .space 10
.text	
	
OpenReadFile:	
	#set true counter
	add $t1, $zero, $zero
	# Specify file name and where to store the name
	li $v0, 8 	# Syscall for getting string input
	la $a0, fileName 
	li $a1, 10
	syscall
	
	# Open file for reading
	li $v0, 13	# Syscall for opening a file
	la $a0, fileName 
	li $a1, 1	# Open for reading
 	li $a2, 0	# Mode is ignored, IDFK what that means
 	syscall	
 	move $s1, $v0	# Save the file descriptor into $s1
 			# If $s1 is negative, there is an error
 			
	# Check for errors in opening the file
	slt $t1, $s1, $zero # If $s1 is negative, set $t1 to 1
	beq $t1, 1, BurnItStartOver 
	
 	
 	addi $t0, $0, 0
 	addi $t1, $0, 0
 	add $t7, $0, $0
 	
getChar:	
	addi $v0, $0, 12 #v0 is the character we are looking for
	syscall
	move $t6, $v0
	

Loop:
	jal Read
	#compare to getChar value
	beq $a3, $t6, trueCount
	
loop2: 			
	#jump to trueCount if they are equal
	
	add $t7, $t7, 1
	beq $t7, 25, HowManyTrue
	
	 
	j Loop 
	
HowManyTrue:
	#print they are equal at $t7
	la $a0, howManyMsg
	add $v0, $0, 4
	syscall
		
	#true count val	
	li $v0, 1	
	add $a0, $t1, $zero 
	syscall	

	
	

	
	
			

	
#-----------------------------------------------------------------------		
# itertest: 	
	        # sll $t2, $t0, 2 # set to zero originally, multiplying by 4
	        # add $t3, $t2, $t1   # base address plus 4
	        # lw $a0, ($t3)    # load placement in $a0
	        # addi $v0, $0, 1 # set $v0 to 1 (print int)
	        # syscall
	        # addi $t0, $t0, 1	# set $t0 to 1
	        # beq $t0, $s1, PlaceInBucket #if $s1 is 1 then PlaceInBucket
	        # la $a0, separator	# print seperator
	        # addi $v0, $zero, 4
	        # syscall
	        	
	        
	        # j itertest
	        

# moreEle: 
		# beq $v1,$s1, beginAlist # if the index for placeinbucket equals the loop index then printlists
	       #  sll $t2, $v1, 2 # else multiply $v1 by 4 (index for place in bucket) go to next element 
	        # add $t3, $t2, $t1   #address of int to place in bucket
	        # lw $a0, ($t3) # place the address of int to place in bucket
	        	
 # addF: 
 		# slt $t4, $a0, $s6 # compare $a0 to D value
	        # bne $t4, $t5, addD # compare $t4 (1 or 0) to
                # la $a1 fslist # load base address of Fslist
                # add $a2, $sp, $0 # bottom of stack (5) then going to next location with every addLetterGrade
                # jal addtolist
                # j  moreEle 	        
#---------------------------------------------------------------------		
		
 	
done:  
	# Close the file 
	li $v0, 16	
	add $a0, $s1, $zero 
	syscall
	# Exit gracefully
	li $v0, 10
	syscall

BurnItStartOver:
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

	
trueCount:
	
	add $t1, $t1, 1
	
	#print they are equal at $t7
	la $a0, indexMsg
	add $v0, $0, 4
	syscall
	
	li $v0, 1	
	add $a0, $t7, $zero 
	syscall	
	
	j loop2
	
Read:				
 	# Read the file that was just opened		
 	li $v0, 14	# Read from the file just opened
 	add $a0, $s1, $zero # $s1 contains the file
 	la $a1, charArray  # Buffer will hold the text read from the file
 	li $a2, 1 	# Read 100 bytes 
 	syscall
 	lb $a3, charArray
 	jr $ra	
		
 		
