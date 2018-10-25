# Write a program that does the following:

# Accept a ASCII text file as input

# Search the file for a specified character

# Print out the following:

# The number of times that the character occurs                                             [10 points] 
# The position of each occurrence of the character                                          [10 points]
# Error message if the file does not exist, or has problems                        	    [2.5 points]   
# Appropriate  message if the character does not exist in the file        	    	    [2.5 points]

# Bonus (5 points)

# Indicate whether the character encountered is upper-case, or lower-case, and the indexes of such occurrences.

.data
	chararray: 	.space 100
	
	filename:	.asciiz "         "
	
	fileprompt:	.asciiz "Enter the file name:\n"
	
	charprompt: 	.asciiz "Enter the character:\n"
	
	charcount: 	.asciiz "\nThis character appears "
	charcount2: 	.asciiz " times."
	
	location: 	.asciiz "\nThis character appears at "
	
	fileissue: 	.asciiz "The file doesn't exist or has a problem with opening."
	
	charissue:	.asciiz "\n(The character does not show up in the file.)"
	
	complete: 	.asciiz "\nComplete."
	
.text
	main:	
		add $t1, $zero, $zero 	#set character counter
		
		#----------------------#
		# prompt for file name #
		#----------------------#
		li $v0, 4
		la $a0, fileprompt
		syscall
		
		#-----------------------------------------------#
		# specify file name and where to store the name #
		#-----------------------------------------------#
		
		li $v0, 8 		# syscall for string input
		la $a0, filename
		li $a1, 9
		syscall
	
		#-----------------------#
		# open file for reading #
		#-----------------------#
		
		li $v0, 13		# syscall for opening
		la $a0, filename 
		li $a1, 0		# open for reading
 		li $a2, 0		# mode is ignored
 		syscall	
 		move $s1, $v0		# save the file descriptor into $s1, if $s1 is negative, there is an error
 		
 		#--------------------------------------#
		# check for errors in opening the file #
		#--------------------------------------#
		
		slt $t1, $s1, $0 	# if $s1 is negative, set $t1 to 1
		beq $t1, 1, badfile 
	
		#------------------------------------#
 		# read the file that was just opened #
 		#------------------------------------#	
 		
 		li $v0, 14		# syscall for reading file
 		add $a0, $s1, $0 	# $s1 contains the file descriptor
 		la $a1, chararray  	# buffer will hold the text read from the file
 		li $a2, 100		# read 100 bytes
 		syscall
 		
 		#----------------------#
		# prompt for char name #
		#----------------------#
		
		li $v0, 4		# print char prompt
		la $a0, charprompt	
		syscall
		
 		#-------------------#
 		# get the character #
 		#-------------------#
 		
 		addi $v0, $0, 12	# syscall for asking for char
		syscall
		
		#----------------------#
		# load file into array #
		#----------------------#
		
		move $s2, $a1		# s2 is array start
		add $t0, $0, $0		# t0 is loop counter
		move $t7, $v0		# t7 is character
		
	
	loop:
		#-----------------------------------#
		# put file characters into an array #
		#-----------------------------------#
		
		add $t3, $t0, $s2   	# base address plus t0
		la $s3, ($t3)     	# load place in $s3
		lb $t6, ($s3)		# load actual character into $t6
		beq $t6, $t7, countchar	# if the char in the array is the char we are looking for, go to count it
		
	loop2:
		#-----------------------------------------------------------#
		# second loop function only so I can return after countchar #
		#-----------------------------------------------------------#
		
		addi $t0, $t0, 1	# count for loop	
		beq $t0, 24, print	# if count gets to 24, end loop
		j loop
		
	countchar:
		#--------------------------------------#
		# count occurences and print locations #
		#--------------------------------------#
		
		addi $t1, $t1, 1	# t1 = t1 + 1
		
		li $v0, 4		# print location statement
		la $a0, location
		syscall
		
		li $v0, 1		# print count of loop, which is location in array
		la $a0, ($t0)
		syscall
		
		j loop2
		
	print:
		#----------------------------#
		# print statements and count #
		#----------------------------#
		
		li $v0, 4		# print charcount statement
		la $a0, charcount
		syscall
		
		li $v0, 1		# print count of character
		la $a0, ($t1)
		syscall
		
		li $v0, 4		# print second part of statement
		la $a0, charcount2
		syscall
		
		beq $t1, $0, nochar	# if no characters, print 0 statement
		
 	exit:
 		#----------------#
 		# close the file #
 		#----------------#
 		
 		li $v0, 16		# syscall for closing file
		add $a0, $s1, $zero 
		syscall
		
		#-------------#
		# exit string #
		#-------------#
		
		li $v0, 4		# print closing word
		la $a0, complete
		syscall
		
		#------#
		# exit #
		#------#
		
		li $v0, 10
		syscall	

 	badfile:
		#-----------------------#
		# print error statement #
		#-----------------------#
		
		li $v0, 4		# print fileissue statement
		la $a0, fileissue
		syscall 
	
		j exit
	
	nochar:
		#-------------------------#
		# print no char statement #
		#-------------------------#
		
		li $v0, 4		# print charissue statement
		la $a0, charissue
		syscall
		
		j exit
