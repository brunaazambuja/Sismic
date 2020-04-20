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
LOCKLPM:	.equ	LOCKLPM5

main:
			bic 	#LOCKLPM, PM5CTL0		; Modo de alta impedância

			bis.b	#BIT0, &P1DIR
			bic.b	#BIT0, &P1REN
			bic.b	#BIT0, &P1OUT			; Configurando o LED vermelho


			bic.b	#BIT1, &P4DIR
			bis.b	#BIT1, &P4REN
			bis.b	#BIT1, &P4OUT			; Configurando o botão S1


			bis.b	#BIT6, &P6DIR
			bic.b	#BIT6, &P6REN
			bic.b	#BIT6, &P6OUT			; Configurando o LED verde


			bic.b	#BIT3, &P2DIR
			bis.b	#BIT3, &P2REN
			bis.b	#BIT3, &P2OUT			; Configurando o botão S2



; Nesse exercício pedia que o os dois leds acendessem de acordo com as duas chaves,
; Porém só consegui fazer um de cada vez, não os dois ao mesmo tempo.


isNotPressed:

			and		#BIT3, &P2IN				; P4IN &= BIT1
			cmp.b	#0x08, &P2IN
			jeq					isNotPressed

Acender:
			xor.b	#BIT6, P6OUT
isPressed:
			and		#BIT3, &P2IN			; P4IN &= BIT1
			cmp.b	#0x00, &P2IN
			jeq					isPressed

			xor.b	#BIT6, P6OUT

			jmp					isNotPressed
			nop


isNotPressed2:

			and		#BIT1, &P4IN				; P4IN &= BIT1
			cmp.b	#0x0E, &P4IN
			jeq					isNotPressed2

Acender2:
			xor.b	#BIT0, P1OUT
isPressed2:
			and		#BIT1, &P4IN			; P4IN &= BIT1
			cmp.b	#0x0C, &P4IN
			jeq					isPressed2

			xor.b	#BIT0, P1OUT

			jmp					isNotPressed2
			nop


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
            
