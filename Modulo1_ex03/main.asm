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

main:
			mov 	#vetor, r5				; R5 recebe o valor inicial do vetor
			clr 	r7
			clr 	r8
			mov.b 	@r5+, r6				; R6 recebe o tamanho do vetor
			add 	#1, r6
			call 				#M2M4		; Chama subrotina
			jmp		$
			nop

M2M4:
			mov.b 	@r5+, r9				; R9 é o número atual avaliado
			dec 	r6						; Decrementa o tamanho do vetor

			jnz 				loop		; vai para M2 caso R6 não tenhha chegado no zero
			ret

loop:
			clrc
			rra 	r9						; Shift right do número (dividir por 2)
			jnc 				M2			; Caso o carry seja 0, ir para M2
			jmp 				M2M4		; Volta para o loop principal

M2:
			inc		r7						; Incrementa R7 - contador de múltiplos de 2
			clrc
			rra 	r9						; Shift right do número (dividir por 2 novamente)
			jnc 				M4			; Caso o carry seja 0, ir para M4
			jmp 				M2M4		; Volta para o loop principal

M4:
			inc		r8						; Incrementa R8 - contador de múltiplos de 4
			jmp 				M2M4
			nop


		.data
vetor:  .byte 7, 4, 2, 3, 2, 5, 7, 8

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
            
