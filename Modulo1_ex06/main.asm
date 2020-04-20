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
main:		mov 	#Vetor1, r12			; R12 recebe o vetor1
			mov 	#Vetor2, r13			; R13 recebe o vetor2
			mov.w	@r12+, r5				; R5 recebe o tamanho do vetor
			incd	r13
			clr.w 	r10
			clr.w	r11
			call 				#SUM_TOT	; Chama a função de comparação
			jmp 	$
			nop

SUM_TOT:
			clrc
			add.w	@r12, r10				; R10 guarda a soma acumulada
			adc		r11						; Se tivermos carry, somamos 1 em R11
			incd 	r12
			clrc
			add.w 	@r13, r10				; R10 guarda a soma acumulada
			adc		r11						; Se tivermos carry, somamos 1 em R11
			incd	r13

exit:
			dec		r5
			jnz					SUM_TOT
			ret


 			.data							; Declarar os vetores com 7 elementos
Vetor1:		.word 7, 131231, 1414, 14991, 14245, 19999, 1536, 164341
Vetor2:		.word 7, 152345, 2523, 3535, 454114, 55435, 61543, 71461

                                            

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
            
