// lineLen:
// Subroutine lineLen will count a string of characters terminated by a new line character
// X0: points to first byte of a CString
// LR: Contains the return address
// ==========================================
//
// Returned register contents:
// X0: Length of the CString excuding the null character
// All registers are preserved except X0

	.data

	.global lineLen		// provide starting point 

	.text
lineLen:

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
				
 mov X7, X0			// poing to first digit (Leftmost of Cstring)
 mov X2, #0			// counter

topLoop2:

 ldrb W1, [X7], #1		// indirect addressing X1 = *X0
 cmp W1, #0xa			// if (W1 == NULL CHARACTER)
 beq botLoop2			// jump to bottom of subroutine
 add X2, X2, #1			// increment the counter
 b topLoop2

botLoop2:

 mov X0, X2			// X0 = Length of the CString

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

 br LR				// Return
 
 .end

