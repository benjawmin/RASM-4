	.data
	
head:		.skip		16
tail:		.quad		0
current:	.quad		0

info:		.quad		0
newNode:	.quad		0
acume:		.byte		0
chLine:		.byte		'\n'
szPrompt:	.asciz		"Enter a string"

kBuff:		.skip	 	512

	.global _start
	.text
	
_start:

up:
	ldr		X1, =kBuff			// location of whre dynamic string's address will go 
	mov		X2, #511			// get the length for a keyboard buffer
	bl		getString		
	
	mov		X0, X1				// move the keyboard buffer into X0
	ldr		X1, =info			// temporary location for the string
	bl		String_copy			// X0 = new string in the heap
	
	mov		X0, #16
	bl		malloc				// allocate enought memory for a new node
	
	ldr		X1, =newNode		// our first node
	str		X0, [X1]			// store the address to the allocated memory into Newnode
	
	ldr		X1, [X1]			// derefernce the pointer of new node address to get the freed 16 bytes
	ldr		X0, =info		
	ldr		X0, [X0]			// get the derefrenced data from info into X0
	str		X0, [X1]			// store the address to the string into X1, which is newnode
	
	mov		X2, #0				// creaet a 0 for null pointer
	str		X2, [X1, #8]		// offset by 8 bytes to put the tail in back half of node
	
	// comapre to see if head is null
	
	ldr		X3, =head			// grab the address for the head
	ldr		X3, [X3]			// derefrence the address to get the values
	cmp		X3, #0				// see if it its 0
	bne		else				// if it is not go to else
	
	ldr		X1, =newNode		// grab the initial address for new node
	ldr		X1, [X1]			// derefernce to get address stored inside
	
	ldr		X3, =head			// get address to the head
	str		X1, [X3]			// place the address to the node inside
	
	ldr		X3, =tail			// replicate the same as the head
	str		X1, [X3]			// place the address to the node inside
		
	ldr		X0, =kBuff			// load address to keyboard buffer
	bl		strLength			// get the length of that string
	mov		X2, X0				// move length to x0
	ldr		X0, =kBuff			// get address again
	bl		clear_string		// clear that string
		
	b		up					// go bakc to top to iterate		
	
else: 
	ldr		X1, =newNode		// grab the new node address
	ldr		X1, [X1]			// load the dynamic address
	
	ldr		X3, =tail			// grab the address stored in tail
	ldr		X3, [X3]			// dereference to get stored address
	
	str		X1, [X3, #8]		// store the address to a new node in the "next" portion or last 8 bytes
	
	ldr		X3, =tail			// grab the address stored in tail
	str		X1, [X3]			// store this node so the next time it goes through it will automatically place last 8 bytes at new tail
	
	ldr		X0, =kBuff			// load address to keyboard buffer
	bl		strLength			// get the length of that string
	mov		X2, X0				// move length to x0
	ldr		X0, =kBuff			// get address again
	bl		clear_string		// clear that string
	
	ldr		X2, =acume			// grab accumulator address
	ldrb	W2, [X2]			// load the value from it
	cmp		X2, #3				// comparer 
	beq		get_out		
	add		X2, X2, #1
	ldr		X1, =acume
	strb	W2, [X1]
	b		up

	
clear_string:
	mov		X4, #0
	
loop_clear:
	mov		X1, #0			// move 0 into X1
	strb	W1, [X0], #1	// store 0 to reset string
	cmp		X4, X2			// comapre to exit loop
	beq		exit_clear
	add		X4, X4, #1		// increment X2
	b 		loop_clear		// branch back to loop clear

exit_clear:
	ret		LR				// return Link Register

get_out:
	ldr		X0, =head
	mov		X1, #2
	bl		deleteLink
	
	ldr		X0, =head
	bl		printList
	
	mov		X0, #0
	mov		X8, #93
	svc		0
