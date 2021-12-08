// Programmer: Anthony Grippi
// RASM 4
// Purpose:
// TBD 

// - File Modes - \\
.equ	READONLY,	00
.equ	WRITEONLY,	01
.equ	READWRITE,	02
.equ	CREATEWO,	0101

// - File Perms - \\
.equ	RW_RW__,	660

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
szEnterStr:	.asciz	"Enter a string to search for: "
szEnterStrI:	.asciz	"Enter the index of string: "
szStrToReplace:	.asciz	"Enter the string to replace: "
szWriteToOut:	.asciz	"Enter what you want to write to output.txt: "


// - File Locations - \\
szOutFile:	.asciz "/home/pi/cs3b/RASM/RASM4/output.txt"
szInFile:	.asciz	"/home/pi/cs3b/RASM/RASM4/input.txt"

kbBuf:		.skip	512		// keyboard buffer
szBuf:		.skip	90000
szInFileBuf:	.skip	90000

	.global	_start
	.text

_start:

	ldr	X0,	=szNL
	bl	putString
	ldr	X0,	=szNL
	bl	putString

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


	// load the input file into szbuf first
	mov	X8,	#56
	ldr	X1,	=szInFile
	mov	X2,	#READONLY
	svc	0	
	mov	X26,	X0

	// reads 90000 bytes into the szBuf
	mov	X8,	#63
	ldr	X1,	=szInFileBuf
	mov	X2,	#45000
	add	X2,	X2,	X2
	mov	X19,	X2
	svc	0

	// closes input file	
	mov	X0,	X26
	mov	X8,	#57
	svc	0

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
	// Option 1 reads and prints 90000 bytes from output.txt

	// opens file
	mov	X8,	#56
	ldr	X1,	=szOutFile
	mov	X2,	#READONLY
	svc	0
	mov	X25,	X0
	

	// reads X2 ammount of bytes
	mov	X8,	#63
	ldr	X1,	=szBuf
	mov	X2,	#45000
	add	X2,	X2,	X2
	svc	0

	// prints using putstring
	ldr	X0,	=szBuf
	bl	putString
	

	// closes file	
	mov	X0,	X25
	mov	X8,	#57
	svc	0

	b	_start

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
	
	ldr	X0,	=szWriteToOut
	bl	putString

	// what to write to output file
	ldr	X1,	=kbBuf
	mov	X2,	#512
	bl	getString
	mov	X19,	X0		// preserve bytes read

	cmp	X25,	#3
	beq	Opt2aAfterOpen
	
	// opens output file
	mov	X8,	#56
	ldr	X1,	=szOutFile
	mov	X2,	#WRITEONLY
	svc	0
	mov	X25,	X0

Opt2aAfterOpen: 

	// writes was in kbbuf to output file
	mov	X0,	X25
	mov	X8,	#64
	ldr	X1,	=kbBuf
	mov	X2,	X19
	svc	0

	b	getIn1	

Opt2b:	// CODE FOR OPTION 2.b GOES HERE
	// CURRENTLY JUST ADDED THE ENTIRE INPUT FILE TO THE OUTPUT FILE AND DID NOT MAKE A LINKED LIST FROM IT
	 
	cmp	X25,	#3
	beq	Opt2bAfterOpen

	// opens output file
	mov	X8,	#56
	ldr	X1,	=szOutFile
	mov	X2,	#WRITEONLY
	svc	0
	mov	X25,	X0


Opt2bAfterOpen:
	// writes what is on szbuf to output.txt
	mov	X0,	X25
	mov	X8,	#64
	ldr	X1,	=szInFileBuf
	mov	X2,	#40000
	svc	0	

	b	getIn1	

Opt3:	// CODE FOR OPTION 3 GOES HERE
	ldr	X0,	=szEnterStrI	// print opening msg
	bl	putString

	ldr	X1,	=kbBuf		// this is where we input the index
	mov	X2,	#10
	bl	getString

	ldrb	W19,	[X1]		// store the first byte into X19
	mov	X20,	#0		// counter

	// opening output.txt
	mov	X8,	#56
	ldr	X1,	=szOutFile
	mov	X2,	#WRITEONLY
	svc	0
	mov	X21,	X0		// store file descriptor in X21
	
	// X0 can contain the a pointer to the head and traverse it W0 amount of times
Opt3Loop:

	cmp	X19,	X20
	beq	Opt3IFound

	// increment Linked list

	b	Opt3Loop

Opt3IFound:
	// here we have to delete something from the linked list

	

	// saves and closes file	
	ldr	X0,	[SP],	#16
	mov	X8,	#57
	svc	0

	b	getIn1

Opt4:	// CODE FOR OPTION 4 GOES HERE

	ldr	X0,	=szEnterStrI	// print opening msg
	bl	putString

	ldr	X1,	=kbBuf		// this is where we input the index
	mov	X2,	#10
	bl	getString

	ldrb	W19,	[X1]		// store the first byte into X19
	mov	X20,	#0		// counter

	// opening output.txt
	mov	X8,	#56
	ldr	X1,	=szOutFile
	mov	X2,	#WRITEONLY
	svc	0
	mov	X21,	X0		// store file descriptor in X21
	
	// X0 can contain the a pointer to the head and traverse it W0 amount of times
Opt4Loop:

	cmp	X19,	X20
	beq	Opt4IFound

	// increment Linked list

	b	Opt4Loop

Opt4IFound:
	// we need to overwrite the string already stored in the linked list
	

	// bellow uses get string to write to output.txt
	ldr	X0,	=szStrToReplace
	bl	putString

	ldr	X1,	=kbBuf
	mov	X2,	#50
	bl	getString

	mov	X8,	#64
	ldr	X1,	=kbBuf
	mov	X2,	X0		// returned by getString
	svc	0

	// saves and closes file	
	ldr	X0,	[SP],	#16
	mov	X8,	#57
	svc	0

	b	getIn1

Opt5: 	// CODE FOR OPTION 5 GOES HERE
	// opening output.txt
	mov	X8,	#56
	ldr	X1,	=szOutFile
	mov	X2,	#READONLY
	svc	0
	mov	X20,	X0		// store file descriptor in X20

	mov	X19,	#0		// counter for indexing

	ldr	X0,	=szEnterStr	// print msg
	bl	putString		

	ldr	X1,	=kbBuf		// entering the string to search for
	mov	X2,	#50		// max size of string
	bl	getString
	
	// Pass head into X0 for strcasestr, it will look for the string in X1 within each line in X0
	// srry if thats confussing

checkOpt5:
	bl	strcasestr		// strcasestr will return a pointer to needle(X1) within the haystack(X0)
	
	// We need to check if 
	
	cmp	X0,	#0		// comparing output to null
	beq	itterateLL		// if null itterate linked list and keep searching
	
	mov	X0,	X19		// returing the counter
	b	stringFound	

itterateLL:
	add	X19,	X19,	#1	// add one to the counter
	// itterate linked list
	b	checkOpt5

stringFound:
	bl	printUInt

	mov	X0,	X20		// closing file
	mov	X8,	#57
	svc	0

	b	getIn1

Opt6:	// CODE FOR OPTION 6 GOES HERE

	// saves and closes output file	
	mov	X0,	X25
	mov	X8,	#57
	svc	0

	b	_start

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


	
	
