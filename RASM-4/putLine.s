// Subroutine putLine: Provided a pointer to a new line terminated string,
// putLine will append a null to the end and 
// display the string to the terminal
// X0: Must point to a new line terminated string
// LR: Must contain the return address
//
// All registers except: 
// X7, X2, X3, 
// are preserved.
// ============================================
//
// X2 - Stores the strLength of *X (CString)
// X9 - Saves LR bc strLength will change it
// X8 - Saves X0 bc strLength will change it
	.data

	.global putLine

	.text
putLine:

 str X19, [SP, #-16]!		// preserves X19 on the stack
 str X20, [SP, #-16]!		// preserves X20 on the stack
 str X21, [SP, #-16]!		// preserves X21 on the stack
 str X22, [SP, #-16]!		// preserves X22 on the stack
 str X23, [SP, #-16]!		// preserves X23 on the stack
 str X24, [SP, #-16]!		// preserves X24 on the stack
 str X25, [SP, #-16]!		// preserves X25 on the stack
 str X26, [SP, #-16]!		// preserves X26 on the stack
 str X27, [SP, #-16]!		// preserves X27 on the stack
 str X28, [SP, #-16]!		// preserves X28 on the stack
 str X29, [SP, #-16]!		// preserves X29 on the stack
 str X30, [SP, #-16]!		// preserves X30 on the stack


 mov X9, LR			// Preserve the Link register in X9
 mov X8, X0			// Preserve X0
 bl lineLen			// X0 = strLength(*X0)
 mov LR, X9			// restore LR
 mov X2, X0			// X2 = strLength(*X0)
 mov X0, #0			// Store a null in X0
 add X2, X2, #1			// add length 1 length for the null
 strb W0, [X8, X2]		// Store that null at the end of the string

				// Print the string
				// Setyp parameters to *X0
				// and then call linux to do it

 mov X0, #1			// 1 = StdOut
 mov X1, X8			// string to print
 mov X8, #64			// linux write syscall
 svc 0				// call linux to print the string

 ldr X30, [SP], #16		// restore the stack
 ldr X29, [SP], #16		// restore the stack
 ldr X28, [SP], #16		// restore the stack
 ldr X27, [SP], #16		// restore the stack
 ldr X26, [SP], #16		// restore the stack
 ldr X25, [SP], #16		// restore the stack
 ldr X24, [SP], #16		// restore the stack
 ldr X23, [SP], #16		// restore the stack
 ldr X22, [SP], #16		// restore the stack
 ldr X21, [SP], #16		// restore the stack
 ldr X20, [SP], #16		// restore the stack
 ldr X19, [SP], #16		// restore the stack

 br LR				// return to main

.end

