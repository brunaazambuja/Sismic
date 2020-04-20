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
			mov		#vetor, r5				; Move o endere�o inicial do vetor para R5
			mov 	@r5+, r6				; R6 recebe o tamanho do vetor e o ponteiro de
											; in�cio � incrementado para a pr�xima posi��o
			call 	#subrot
			jmp		$
			nop

subrot:
			mov		@r5+, r7				; R7 recebe o atual maior
			mov 	#1, r4					; Conta a frequ�ncia


loop:
			mov		@r5+, r8				; R8 recebe o poss�vel novo maior
			cmp 	r7, r8					; Compara R7 com R8
			jeq					igual		; Caso iguais - menor continua em R7
			jhs					maior		; (dst > src)

exit:
			dec 	r6						; O tamanho do vetor � decrementado
			jnz					loop		; Retorna pro loop
			ret

maior:										; Label pra capturar a situa��o em que vc achou um novo menor
			mov		r8, r7					; Troca o menor de R8 para R7
			mov 	#1, r4					; Conta a frequ�ncia
			jmp                 exit        ; Incondicionalmente voltar para loop pra ver se vc ja acabou com seu programa


igual:
			add 	#1, r4					; Conta a frequ�ncia
			jmp 				exit
			nop




			.data							; Declarar vetor com 13 elementos [BRUNAAZAMBUJA]
vetor:
	 		.byte 	7,0,"BRZRNAZRZAJAS",0

                                            

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
            
