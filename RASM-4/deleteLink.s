	.data
	
// put into X0 the head 
// put into X1 the index to be deleted
dAccumulate:	.byte		1

	.global deleteLink
	
	.text
	
deleteLink:
	sub		X1, X1, #1			// subtract by 1 to get position before its deleted
	ldr		X0, [X0]			// load the address at the location of the head

loop:
	ldr		X0, [X0, #8]		// put into X0 the location of the 
	
	ldr		X3, =dAccumulate	// load address for accumulator
	ldrb	W3, [X3]			// load the address of the 
	
	cmp		X3, X1				// compare to see if its equal to the loop
	beq		delete				// go to delete block
	
	add		X3, X3, #1			// add by 1
	ldr		X4, =dAccumulate	// load address for accumulator
	strb	W3, [X4]			// store new value insideq
	b		loop				// branch back to top of loop

delete:
	mov		X3, X0				// get the node value and put it into X3
	
	ldr		X0, [X0, #8]		// put into X0 the location of the node to be deleted
	mov		X1, X0				// preserve address for a little bit
	
	//ldr		X0, [X0]			// load the address at the location of the node
	
	ldr		X0, [X0, #8]		// put into X0 the location of the next node you want to link to node before one being deleted
	
	str		X0, [X3, #8]		// store address in X0 into the old next node
	
	mov		X3, X1
	ldr		X3, [X3]			// load the address of the requested deleted node
	//mov		X0, X3				// move whats in X3 into X2 to perserve
	//bl		free				// free the allocated bytes
	
	//mov		X0, X1				// get address to entire node
	//bl		free				// delete bytes at that location
	
	ret		LR					// move back out of function
	
	.end

