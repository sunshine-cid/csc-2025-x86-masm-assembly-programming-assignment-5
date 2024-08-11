; Student
; Professor
; Class: CSC 2025 XXX
; Week  - Programming HW #5
; Date
; Program takes input of hours, minutes, and seconds and displays the values inputted, and then calculates total minutes and seconds and displays those too.

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data
	; Create memory space for the user interaction and information messages
	msgNumHours BYTE "Enter the number of hours: ",0
	msgNumMinutes BYTE "Enter the number of minutes: ",0
	msgNumSeconds BYTE "Enter the number of seconds: ",0

	msgEnteredHours BYTE "The number of hours entered was ",0
	msgEnteredMinutes BYTE "The number of minutes entered was ",0
	msgEnteredSeconds BYTE "The number of seconds entered was ",0

	msgTotalMinutes BYTE "The total number of minutes is ",0
	msgMinutes BYTE " minutes.",0
	msgTotalSeconds BYTE "The total number of seconds is ",0
	msgSeconds BYTE " seconds.",0

	;Storing a period character as a string for use later
	msgPeriod BYTE ".",0

	msgTryAgain BYTE "Try again (y/n)? ",0

	; Create variables to save user inputs in memory and compute total minutes/seconds.
	enteredHours DWORD ?
	enteredMinutes DWORD ?
	enteredSeconds DWORD ?

	totalMinutes DWORD ?
	totalSeconds DWORD ?

	tryAgainChar BYTE ?

	; Storing the value of Y and N so they can be compared to uppercase'd inputs
	upperCaseNChar BYTE 4Eh
	upperCaseYChar BYTE 59h

.code

;-------------------------------- ComputeMinutes Procedure 
;	Functional Details: This procedure recieves values(hours,minutes,seconds) via registers, computes and returns total minutes
;	Inputs: Recieves hours via EBX, recieves minutes via ECX, recieves seconds via EDX
;	Outputs: Returns the computed value via EAX
;	Registers:	EAX is used for calculations and for the return value
;				EBX is recieved as input(hours), and later used to temporairily hold our calculated value while we use EAX for division
;				ECX is recievesd as input(minutes), and later used to hold the divisor(60) for DIV calculations
;				EDX is recived as input(seconds), and later zeroed as DIV remainder
;	Memory Locations: This procedure exclusively uses registers
;--------------------------------
ComputeMinutes PROC USES EBX ECX EDX

	mov eax, ebx ; Move EBX(Hours) into EAX
	imul eax, 60 ; Multiply by 60 giving us minutes (Hours * 60) 
	add eax, ecx ; Add to ECX (Minutes), this gives us total minutes between hours and minutes

	; Ok, at this point we need to add minutes from seconds if seconds => 60. So...
	mov ebx, eax ; Now that EBX is available move minutes calculated so far into EBX
	mov eax, edx ; Move EDX(seconds) into EAX in prep for division

	mov edx, 0 ; Set the divisor remainder to 0 (if you don't clear this DIV won't work)
	mov ecx, 60 ; We're required to move the divisor into a register
	div ecx ; DIVide EAX(now seconds) by 60, giving us any additional minutes (ignoring remainder)
	add eax, ebx ; Add saved minutes (EBX) to our result giving us total minutes

	ret
ComputeMinutes ENDP

;-------------------------------- ComputeSeconds Procedure 
;	Functional Details: This procedure recieves values(hours,minutes,seconds) via registers, computes and returns total seconds
;	Inputs: Recieves hours via EBX, recieves minutes via ECX, recieves seconds via EDX
;	Outputs: Returns the computed value via EAX
;	Registers:	EAX is used for calculations and for the return value
;				EBX is used to recieve the value for hours
;				ECX is used to recieve the value for minutes
;				EDX is used to recieve the value for seconds
;	Memory Locations: This procedure exclusively uses registers
ComputeSeconds PROC USES EBX ECX EDX

	mov eax, ebx ; Move EBX(Hours) into EAX
	imul eax, 60 ; Multiply hours by 60, giving us minutes
	add eax, ecx ; Add ECX(Minutes) to our calculated minutes
	imul eax, 60 ; Multiply total currently calculated minutes by 60 giving us seconds
	add eax, edx ; Add EDX(Seconds) remaining to calculated seconds for total seconds

	ret
ComputeSeconds ENDP

;-------------------------------- Main Procedure 
;	Functional Details: Practically this program prompts for and takes input for hours, minutes 
;	and seconds. Displays the inputted values, and then calculates total minutes and total 
;	seconds and displays those as well. Then the user is given the option of repeating the 
;	process via a y/n prompt.
;	Inputs: Takes input via 3 seperate prompts for hours, minutes and seconds. At the end of 
;	the process prompts to repeat the program via a y/n input.
;	Outputs: Displays menaingful guiding prompts. Displays the values input. And displays 
;	the final calculation
;	Registers:	EAX is used repeatedly to recieve input from the user, and also to return 
;				values based on computations.
;				EBX is used to pass the value of hours when calling ComputeMinutes and 
;				ComputeSeconds.
;				ECX is used to pass the value of minutes when calling ComputeMinutes and 
;				ComputeSeconds.
;				EDX is used to pass the value of hours when calling ComputeMinutes and 
;				ComputeSeconds. Also, EDX is used repeatedly to hold the offset to a 
;				string in memory so a message can be displayed on screen.
;	Memory Locations: No explicit memory locations are used in this procedure, but many 
;	offsets referring to strings which are intended to be displayed are used.

main PROC

; Label so we can repeat the program if the user desires
REPEATPROG:
	
	; Display messgae and take input for hours
	mov  edx,OFFSET msgNumHours
	call WriteString

	call ReadDec ; Read the unsigned int value
	mov enteredHours, eax ; Move the entered value into a memory operand

	; Display messgae and take input for minutes
	mov  edx,OFFSET msgNumMinutes
	call WriteString

	call ReadDec ; Read the unsigned int value
	mov enteredMinutes, eax ; Move the entered value into a memory operand

	; Display messgae and take input for seconds
	mov  edx,OFFSET msgNumSeconds
	call WriteString

	call ReadDec ; Read the unsigned int value
	mov enteredSeconds, eax ; Move the entered value into a memory operand

	call Crlf ; Move the display line down 1 to match the assignment output

	; Display the entered value for hours
	mov  edx,OFFSET msgEnteredHours
	call WriteString

	mov eax, enteredHours ; move the stored value into memory
	call WriteDec ; Write the unsigned integer
	mov edx, OFFSET msgPeriod ; Move the period string offset into EDX so our output is similar to the assignment's sample output
	call WriteString
	call Crlf ; Move the display line down 1

	; Display the entered value for minutes
	mov  edx,OFFSET msgEnteredMinutes
	call WriteString

	mov eax, enteredMinutes ; move the stored value into memory
	call WriteDec ; Write the unsigned integer
	mov edx, OFFSET msgPeriod ; Move the period string offset into EDX so our output is similar to the assignment's sample output
	call WriteString
	call Crlf ; Move the display line down 1

	; Display the entered value for seconds
	mov  edx,OFFSET msgEnteredSeconds
	call WriteString

	mov eax, enteredSeconds ; move the stored value into memory
	call WriteDec ; Write the unsigned integer
	mov edx, OFFSET msgPeriod ; Move the period string offset into EDX so our output is similar to the assignment's sample output
	call WriteString
	call Crlf ; Move the display line down 1

	call Crlf ; Move the display line down 1 to match the assignment output

	; Move values into registers to prepare for a procedure call
	mov ebx, enteredHours
	mov ecx, enteredMinutes
	mov edx, enteredSeconds

	;Calculate total minutes, and save it
	call ComputeMinutes
	mov totalMinutes, eax

	; Calculate total seconds, and save it
	call ComputeSeconds
	mov totalSeconds, eax

	; Display total minutes message
	mov  edx,OFFSET msgTotalMinutes
	call WriteString

	mov eax, totalMinutes ; move the stored value into memory
	call WriteDec ; Write the unsigned integer
	mov edx, OFFSET msgMinutes ; Move the period string offset into EDX so our output is similar to the assignment's sample output
	call WriteString
	call Crlf ; Move the display line down 1

	; Display total seconds message
	mov  edx,OFFSET msgTotalSeconds
	call WriteString

	mov eax, totalSeconds ; move the stored value into memory
	call WriteDec ; Write the unsigned integer
	mov edx, OFFSET msgSeconds ; Move the period string offset into EDX so our output is similar to the assignment's sample output
	call WriteString
	call Crlf ; Move the display line down 1

TRYPROG:
	; Display try again prompt (case insensitive)
	mov  edx,OFFSET msgTryAgain
	call WriteString

	call ReadChar
	call WriteChar ; Display the character typed, this is necessary since ReadChar doesn't display the Char typed
	call Crlf ; Move the display line down 1
	call Crlf ; Move the display line down 1

	movsx eax, al ; we need to overwrite the rest of the EAX register with the sign from AL becasue ReadChar loads the value to AL
	mov tryAgainChar, al ; Store the read character in our memory operand

	; Convert input Char to Uppercase
	INVOKE Str_ucase, ADDR tryAgainChar
	
	
	; Compare input character to uppercase N, if NOT uppercase N jump to REPEATPROG
	mov al, tryAgainChar
	cmp al, upperCaseYChar
	je REPEATPROG

	; Compare input to uppercase N, if equals, jump to ENDPROG
	cmp al, upperCaseNChar
	je ENDPROG

	; If neither y opr n was pressed, repeat prompt
	jmp TRYPROG

ENDPROG:
	; Before exit call WaitMsg prompt so the window doesn't just disappear
	call WaitMsg

	exit
main ENDP
END main
