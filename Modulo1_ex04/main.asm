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

main:		mov 	#vetor, r4				; R4 recebe o vetor
			mov.b	@r4+, r5				; R5 recebe o tamanho do vetor
			call 				#extremos	; Chama a função de comparação
			jmp 	$
			nop

extremos:
			mov 	@r4+, r6				; Novo menor R6
			mov 	r6, r7					; Novo maior R7
			dec		r5						; Diminui o tamanho do vetor

loop:
			mov 	@r4+, r9				; R9 é o novo número a ser analisado
			cmp 	r6, r9					; Compara R6 com R9
			jl					menor		; (dst < src)
			cmp 	r7, r9					; Compara R7 com R9
			jge					maior		; (dst > src)

exit:
			dec 	r5
			jnz					loop
			ret

maior:
			mov 	r9, r7
			jmp                 exit        ; Incondicionalmente voltar para loop pra ver se vc ja acabou com seu programa
			nop

menor:
			mov 	r9, r6
			jmp                 exit        ; Incondicionalmente voltar para loop pra ver se vc ja acabou com seu programa
			nop



			.data
vetor:		.word	8, 2, 6, 10, -1, -7, 4, 11, -19
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
            
