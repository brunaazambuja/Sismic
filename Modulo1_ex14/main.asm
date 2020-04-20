;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;              Definições
;--------------------------------------------------------------------------------

LOCKLPM:	.equ	LOCKLPM5
DELAY1:		.equ	700
DELAY2:		.equ	700
LED1:		.equ	BIT0
LED2:		.equ	BIT6

main:
			bic 	#LOCKLPM, PM5CTL0		; Modo de alta impedância

			bis.b	#LED1, &P1DIR
			xor.b	#LED1, &P1OUT

			call					#ROT_ATZ

			bis.b	#LED1, &P1DIR
			xor.b	#LED1, &P1OUT

			bis.b	#LED2, &P6DIR
			xor.b	#LED2, &P6OUT

			call					#ROT_ATZ

			bis.b	#LED2, &P6DIR
			xor.b	#LED2, &P6OUT

			jmp						main


ROT_ATZ:
			mov		#DELAY1, r6
RT1:
			mov		#DELAY2, r5
RT2:
			dec		r5
			jnz						RT2
			dec		r6
			jnz						RT1
			ret

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
