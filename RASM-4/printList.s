	.data
	
// put into X0 the head of the linked list address
chLine:		.byte		'\n'
	.global	printList
	
	.text

printList:
	
	ldr		X0, [X0]			// grab the address at the address of the head
	ldr		X2, [X0]			// grab the string address at the 
	ldr		X0, [X0, #8]		// grab the address to the next node
	
iterate:
	str		X0, [sp, #-16]!		// store the next node onto the stack
	mov		X0, X2				// place string address into X0 in order to print
	bl		putString			// print the string in the lsit out
	
	ldr		X1, =chLine			// get address for newline
	bl		putch				// print newline
	
	ldr		X0, [sp], #16		// grab node address off stack
			
	ldr		X2, [X0]			// grab string at that node
	ldr		X0, [X0, #8]		// grab next node address
	
	cmp		X0, #0				// if next node address equals 0 get out of address
	beq		out					// move to out
	
	b		iterate				// otherwise iterate again

out:
	mov		X0, X2				// print last string
	bl		putString			// print funcitons
	ret		LR					// break out
