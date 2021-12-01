.equ	READONLY,00
.equ	WRITEONLY,01
.equ	READWRITE,02
.equ	CREATEWO,0101
.equ	RW_RW__,644

	.data

// - Menu Strings - \\
szTE:		.asciz	"\tRASM4 TEXT EDITOR\n"
szMemCon:	.asciz	"\tData Structure Heap Memory Consumption "
szBytes:	.asciz	" bytes\n"
szNumNodes:	.asciz	"\tNumber of Nodes: "

szOpt1:		.asciz	"<1> View all strings\n\n"

szOpt2:		.asciz	"<2> Add string\n"
szOpt2a:	.asciz	"\t<a> From Keyboard\n"
szOpt2b:	.asciz	"\t<b> From File. Static file named input.txt\n\n"

szOpt3:		.asciz	"<3> Delete string. Given am index #, delete the entire string and de-allocate memory (including the node)\n\n"

szOpt4:		.asciz	"<4> Edit string. Given and index #, replace old string w/ new string. Allocate/De-allocate as needed.\n\n"

szOpt5:		.asciz	"<5> String search. Regaurdless of case, return all strings that match the substring given.\n\n"

szOpt6:		.asciz	"<6> Save File (output.txt)\n\n"

szOpt7:		.asciz	"<7> Quit\n\n\n"

szSubOpt:	.asciz	"Please select a sub-option: "

// - Other Strings - \\
szNL:		.asciz	"\n"
szGetOpt:	.asciz	"Please select an option: "
szValidIn:	.asciz	"Please select a valid option: "


kbBuf:		.skip	512		// keyboard buffer

	.global	_start
	.text

_start:

	// Bellow prints the menu
	ldr	X0,	=szTE
	bl	putString
	ldr	X0,	=szMemCon
	bl	putString
	// print num bytes here
	ldr	X0,	=szBytes
	bl	putString
	ldr	X0,	=szNumNodes
	bl	putString
	ldr	X0,	=szNL
	bl	putString
	ldr	X0,	=szNL
	bl	putString
	ldr	X0,	=szOpt1
	bl	putString
	ldr	X0,	=szOpt2
	bl	putString
	ldr	X0,	=szOpt2a
	bl	putString
	ldr	X0,	=szOpt2b
	bl	putString
	ldr	X0,	=szOpt3
	bl	putString
	ldr	X0,	=szOpt4
	bl	putString
	ldr	X0,	=szOpt5
	bl	putString
	ldr	X0,	=szOpt6
	bl	putString
	ldr	X0,	=szOpt7
	bl	putString

	// Asking for user input
	ldr	X0,	=szGetOpt
	bl	putString

getIn1:
	ldr	X1,	=kbBuf		// arg for getString
	mov	X2,	#2		// accepting 2 characters for selecting option
	bl	getString		// see what option user selected

	// Checking what option was selected
	ldrb	W0,	[X1]		// derefference the first byte and store in X0
	bl	getOption		// jump to check what option was selected

Opt1:	// CODE FOR OPTION 1 GOES HERE


Opt2:	// CODE FOR OPTION 2 GOES HERE

	ldr	X0,	=szSubOpt	// option 2 has 2 sub options 2.a and 2.b
	bl	putString		
getIn2:
	ldr	X1,	=kbBuf		// arg for getstring
	mov	X2,	#2		// only accepting 2 characters for selecting the suboption
	bl	getString		// see what suboption was selected

	ldrb	W0,	[X1]		// dereffernce the first byte stored in kbbuf 

	cmp	X0,	#0x61		// was it an a
	b.eq	Opt2a
	cmp	X0,	#0x62		// was it a b
	b.eq	Opt2b
	
	ldr	X0,	=szValidIn	// anthing else... return to getting input
	bl	putString
	b	getIn2

Opt2a: 	// CODE FOR OPTION 2.a GOES HERE


Opt2b:	// CODE FOR OPTION 2.b GOES HERE


Opt3:	// CODE FOR OPTION 3 GOES HERE


Opt4:	// CODE FOR OPTION 4 GOES HERE


Opt5: 	// CODE FOR OPTION 5 GOES HERE


Opt6:	// CODE FOR OPTION 6 GOES HERE


getOption:
	cmp	X0,	#0x31		// was the option 1	
	b.eq	Opt1
	cmp	X0,	#0x32		// ... 2
	b.eq	Opt2
	cmp	X0,	#0x33		// ... 3
	b.eq	Opt3
	cmp	X0,	#0x34		// ... 4
	b.eq	Opt4
	cmp	X0,	#0x35		// ... 5
	b.eq	Opt5
	cmp	X0,	#0x36		// ... 6
	b.eq	Opt6
	cmp	X0,	#0x37		// ... 7
	b.eq	exit			// if 7 just exit

	ldr	X0,	=szValidIn	// anthing else ... return to getting input
	bl	putString
	b	getIn1



exit:
						// setup parameters to end the program
						// and then call Linux to do it
	mov X0, #0				// use 0 as return code
	mov X8, #93				// service command code 93 terminates this program
	svc 0					// call Linux to terminate the program

.end
