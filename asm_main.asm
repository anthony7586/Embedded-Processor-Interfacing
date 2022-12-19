; When SW1 is pressed, RED LED turns on

; Built-in LED1 connected to P1.0
; Negative logic built-in button 1 connected to P1.1

			.thumb

			.text					; Following put in ROM

P4OUT		.word	0x40004C23
P5IN		.word	0x40004C40
P5OUT 		.word 	0x40004C42

P4DIR   	.word	0x40004C25		; Port 4 Direction
P4SEL0  	.word	0x40004C2B		; Port 4 Select 0
P4SEL1  	.word	0x40004C2D		; Port 4 Select 1

P5DIR   	.word	0x40004C44		; Port 5 Direction
P5SEL0  	.word	0x40004C4A		; Port 5 Select 0
P5SEL1  	.word	0x40004C4C		; Port 5 Select 1

big_number	.equ	0x0EF00

			.global asm_main
			.thumbfunc asm_main

asm_main:	.asmfunc				; Main
	BL   	GPIO_Init	; this is a sub routine(subroutines use bx lr within their code)


	LDR 	r1, P4OUT	;p4	output
	LDR 	R2, P5IN	;p5 input

loop:
	BL   	GPIO_Input			;input for p1.4

	CMP		R0, #0x01			; if button is pressed
	BEQ 	TURN_ON_LED			;turn on the led

	B		TOGGLE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TURN_ON_LED:
	PUSH	{R3}					; Save context

	MOV		R3, #0x01				; Need to set pin 2 to 1 to keep pull up
	STRB	R3, [R1]

	POP		{R3}					; Restore context

	B		loop ;back to main loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TURN_OFF_LED:
	PUSH	{R3}					; Save context

	MOV		R3, #0x00				; Need to set pin 2 to 1 to keep pull up
	STRB	R3, [R1]

	POP		{R3}					; Restore context

	B		loop;loop back to turn on led then back to loop
			.endasmfunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GPIO_Init:	.asmfunc
	PUSH	{R0-R1}					; Save context

; Init P4
	LDR 	R1, P4SEL0
	LDRB	R0, [R1]
	BIC		R0, R0, #0x01           ; Configure pins as GPIO
	STRB	R0, [R1]

	LDR		R1, P4SEL1
	LDRB	R0, [R1]
	BIC		R0, R0, #0x01           ; Configure pins as GPIO
	STRB 	R0, [R1]

	; Make pins output
	LDR		R1, P4DIR
	LDRB	R0, [R1]
	ORR		R0, R0, #0x01           ; Set P1.0 as output (1)
	STRB	R0, [R1]

; Init P5
	LDR 	R1, P5SEL0
	LDRB	R0, [R1]
	BIC		R0, R0, #0x01           ; Configure pins as GPIO
	STRB	R0, [R1]

	LDR		R1, P5SEL1
	LDRB	R0, [R1]
	BIC		R0, R0, #0x01           ; Configure pins as GPIO
	STRB 	R0, [R1]

	; Make pins output
	LDR		R1, P5DIR
	LDRB	R0, [R1]
	BIC		R0, R0, #0x01
	           ; Set P5.0 as output (1)
	STRB	R0, [R1]

	LDR		R1, P5OUT
	LDRB	R0, [R1]
	ORR		R0, R0, #0x01
	           ; Set P5.0 as output (1)
	STRB	R0, [R1]

    POP		{R0-R1}					; Restore context

	BX   	LR
			.endasmfunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GPIO_Input:	.asmfunc
	; Get P1 input and return via R0
	LDRB	R0, [R2]
	;LSR		R0, #0x04				; Shift to the right 1
	BIC		R0, R0, #0xFE           ; Clear upper 7 bits

	BX   	LR
			.endasmfunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TOGGLE:.asmfunc
	;TURN_ON_LED (with a delay)
	PUSH	{R3}					; Save context

	MOV		R3, #0x01				; Need to set pin 2 to 1 to keep pull up
	STRB	R3, [R1]

	POP		{R3}					; Restore context

	;DELAY
		mov		R5, #big_number				;hold number to count down from
wait:	subs R5,R5,#0x01	;subtrats 1 from 900 then stores it back into r5;
	bne 	wait


;TURN_OFF_LED
	PUSH	{R3}					; Save context
	MOV		R3, #0x00				; Need to set pin 2 to 1 to keep pull up
	STRB	R3, [R1]
	POP		{R3}					; Restore context

	;DELAY2
	mov		R5, #big_number				;hold number to count down from
wait_two:	subs R5,R5,#0x01	;subtrats 1 from 900 then stores it back into r5
	bne 	wait_two


	B		loop;will exit and go back to loop
			.endasmfunc






	        .end
