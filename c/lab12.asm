.globl main 

.text

main:

	li $v0, 4			# Code for print string
	la $a0, welcome_message	# Load address of welcome message
	syscall			# Call print
	
	li $t6, 0			# Miss Count
	
	while:
	
		jal print_game
	
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		addi $sp, $sp, -4
		sw $t1, 0($sp)
		addi $sp, $sp, -4
		sw $t2, 0($sp)
		addi $sp, $sp, -4
		sw $t3, 0($sp)
		addi $sp, $sp, -4
		sw $t4, 0($sp)
		
		jal check_game
		
		lw $t4, 0($sp)
		addi $sp, $sp, 4
		lw $t3, 0($sp)
		addi $sp, $sp, 4
		lw $t2, 0($sp)
		addi $sp, $sp, 4
		lw $t1, 0($sp)
		addi $sp, $sp, 4
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		
		bne $v0, $zero, end_while
		
		jal user_input
		
		add $t0, $zero, $v0
		
		li $t1, 48	# 48 = '0'
		beq $t0, $t1, exit
		
		li $t1, 65	# 65 = 'A' 90 = 'Z'
		blt $t0, $t1, invalid
		li $t1, 90
		bgt $t0, $t1, invalid
		
		for_used_character:
			li $t2, 0
			lw $t3, word_size
			
			la $t4, current

			for_check_character:
			
				lbu $t5, ($t4)
				
				beq $t5, $t0, used_character
				beq $t2, $t3, exit_for_used_character
				
				addi $t4, $t4, 1
				addi $t2, $t2, 1
				
				j for_check_character
		exit_for_used_character:
		
		for_used_misses_character:
			li $t2, 0
			li $t3, 5
			
			la $t4, misses

			for_check_misses_character:
			
				lbu $t5, ($t4)
				
				beq $t5, $t0, used_character
				beq $t2, $t3, exit_for_used_misses_character
				
				addi $t4, $t4, 1
				addi $t2, $t2, 1
				
				j for_check_misses_character
		exit_for_used_misses_character:
		
		li $t1, 1
		
		for_check_missed:
			li $t2, 0
			lw $t3, word_size
			
			la $t4, solution
			
			for_check_solution:
			
				lbu $t5, ($t4)
				
				beq $t5, $t0, update_current
				back_to_for_check_solution:
				beq $t2, $t3, exit_for_check_missed
					
				addi $t4, $t4, 1
				addi $t2, $t2, 1
				
				j for_check_solution
		exit_for_check_missed:
		
		bne $t1, $zero, missed
		done_missed:
		
		j while
		
	missed:
		
		la $a1, misses
		add $a1, $a1, $t6
		sb $t0, ($a1)
		addi $t6, $t6, 1
		
		li $t9, 1
		beq $t6, $t9, missedOne
		
		li $t9, 2
		beq $t6, $t9, missedTwo
		
		li $t9, 3
		beq $t6, $t9, missedThree
		
		li $t9, 4
		beq $t6, $t9, missedFour
		
		li $t9, 5
		beq $t6, $t9, missedFive
		
		li $t9, 6
		beq $t6, $t9, missedSix
		
		j done_missed
		# O = 79, | = 124, \ = 92, / = 47
		missedOne:
			la $a1, game_line
			addi $a1, $a1, 36
			li $t8, 79
			sb $t8, ($a1)
			j done_missed
		missedTwo:
			la $a1, game_line
			addi $a1, $a1, 47
			li $t8, 124
			sb $t8, ($a1)
			addi $a1, $a1, 11
			sb $t8, ($a1)
			j done_missed
		missedThree:
			la $a1, game_line
			addi $a1, $a1, 46
			li $t8, 92
			sb $t8, ($a1)
			j done_missed
		missedFour:
			la $a1, game_line
			addi $a1, $a1, 48
			li $t8, 47
			sb $t8, ($a1)
			j done_missed
		missedFive:
			la $a1, game_line
			addi $a1, $a1, 68
			li $t8, 47
			sb $t8, ($a1)
			j done_missed
		missedSix:
			la $a1, game_line
			addi $a1, $a1, 70
			li $t8, 92
			sb $t8, ($a1)
			jal print_game
			
			li $v0, 4			# Code for print string
	
			la $a0, lose_line		# Load address of lose message
			syscall			# Call print
			
			j return
	
	update_current:
	
		la $a1, current
		add $a1, $a1, $t2
		sb $t0, ($a1)
		li $t1, 0
		
		j back_to_for_check_solution
	
	used_character:
	
		li $v0, 4			# Code for print string
	
		la $a0, already_use_line	# Load address of used character message
		syscall			# Call print
		
		j while
	
	invalid:
	
		li $v0, 4			# Code for print string
	
		la $a0, invalid_line		# Load address of invalid message
		syscall			# Call print
		
		j while
	
	end_while:
		jal print_game
		
		li $v0, 4			# Code for print string
	
		la $a0, win_line		# Load address of win message
		syscall			# Call print
		
		j return
	
	exit:
		li $v0, 4
		
		la $a0, exit_line
		syscall
		
		j return
	
	return:
	
	li $v0, 10 			# Code for exit
	syscall			# Call exit

check_game:

	addi $sp, $sp, -4		# Save ra register
	sw $ra, 0($sp)			# Save ra register

	li $t0, 0
	lw $t1, word_size
	
	la $t2, current
	
	li $t3, 95

	for_check_game:
		bge $t0, $t1, return_true_check_game
	
		lbu $t4, ($t2)
		
		beq $t4, $t3, return_false_check_game
		
		addi $t2, $t2, 1
		addi $t0, $t0, 1
		
		j for_check_game
	
	return_true_check_game:
		li $v0, 1
		j end_for_check_game
	
	return_false_check_game:
		li $v0, 0
		j end_for_check_game
	
	end_for_check_game:
	
	lw $ra, 0($sp)			# Load ra register
	addi $sp, $sp, 4		# Load ra register
	jr $ra				# Jump to return address

print_game:

	addi $sp, $sp, -4		# Save ra register
	sw $ra, 0($sp)			# Save ra register
	
	li $v0, 4			# Code for print string
	
	la $a0, game_line		# Load address of game message
	syscall			# Call print
	
	la $a0, word_line		# Load address of "Word: "
	syscall			# Call print
	la $a0, current		# Load address of "_______"
	syscall			# Call print
	la $a0, new_line		# Load address of "\n"
	syscall			# Call print
	
	la $a0, misses_line		# Load address of "Misses: "
	syscall			# Call print
	la $a0, misses			# Load address of misses
	syscall			# Call print
	la $a0, new_line		# Load address of "\n"
	syscall			# Call print
	
	lw $ra, 0($sp)			# Load ra register
	addi $sp, $sp, 4		# Load ra register
	jr $ra				# Jump to return address

user_input:

	addi $sp, $sp, -4		# Save ra register
	sw $ra, 0($sp)			# Save ra register
	
	li $v0, 4			# Code for print string
	
	la $a0, prompt_input_line	# Load address of prompt input line
	syscall			# Call print
	
	li $v0, 12			# Code for read character
	syscall			# Call read character
	
	add $t0, $zero, $v0
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	add $v0, $zero, $t0
	li $t0, 0
	
	lw $ra, 0($sp)			# Load ra register
	addi $sp, $sp, 4		# Load ra register
	jr $ra				# Jump to return address

.data
welcome_message:	.asciiz "Welcome to Hangman!\nVersion 1.0\nImplemented by Andrew Kim\n\n"
solution:		.asciiz "HANGMAN"
current:		.asciiz "_______"
misses:		.asciiz "      "
word_line:		.asciiz "Word: "
misses_line:		.asciiz "Misses: "
new_line:		.asciiz "\n"
game_line:		.asciiz "   |-----|\n   |     |\n   |     |\n         |\n         |\n         |\n         |\n         |\n ---------\n"
prompt_input_line:	.asciiz "Enter next character (A-Z), or 0 (zero) to exit: "
win_line:		.asciiz "Congratulations - you win!\n"
lose_line:		.asciiz "You lose - out of moves\n"
exit_line:		.asciiz "Exiting game...\n"
invalid_line:		.asciiz "Invalid input\n"
already_use_line:	.asciiz "Already used character\n"
miss_count:		.word 0
word_size:		.word 7
