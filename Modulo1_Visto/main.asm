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
NUM:		.equ	2419

main:
			mov 	#NUM, r5 				; R5 = número a ser convertido
 			mov 	#RESP, r6 				; R6 = ponteiro para escrever a resposta
 			call 				#alg_rom 	; Chamar subrotina
 			jmp 	$
  			nop
alg_rom:
			cmp		#1000, r5
			jhs					caso_mil

			cmp		#900, r5
			jhs					caso_novecentos

			cmp		#500, r5
			jhs					caso_quinhentos

			cmp		#400, r5
			jhs					caso_quatrocentos

			cmp		#100, r5
			jhs					caso_cem

			cmp		#90, r5
			jhs					caso_noventa

			cmp		#50, r5
			jhs					caso_cinquenta

			cmp		#40, r5
			jhs					caso_quarenta

			cmp		#10, r5
			jhs					caso_dez

			cmp		#9, r5
			jhs					caso_nove

			cmp		#5, r5
			jhs					caso_cinco

			cmp		#4, r5
			jhs					caso_quatro

			cmp		#1, r5
			jhs					caso_um
			jeq					caso_um

			mov.b	#0x00, 0(r6)			; Para terminar move 00 para o final do número
			ret

caso_mil:
			sub		#1000, r5
			mov.b	#0x4D, 0(r6)			; Move o 'M'
			inc		r6
			jmp					alg_rom

caso_novecentos:
			sub		#900, r5
			mov.b	#0x43, 0(r6)			; Move o 'CM'
			inc		r6
			mov.b	#0x4D, 0(r6)			; Move o 'CM'
			inc		r6
			jmp					alg_rom

caso_quinhentos:
			sub		#500, r5
			mov.b	#0x44, 0(r6)			; Move o 'D'
			inc		r6
			jmp					alg_rom

caso_quatrocentos:
			sub		#400, r5
			mov.b	#0x43, 0(r6)			; Move o 'CD'
			inc		r6
			mov.b	#0x44, 0(r6)			; Move o 'CD'
			inc		r6
			jmp					alg_rom

caso_cem:
			sub		#100, r5
			mov.b	#0x43, 0(r6)			; Move o 'C'
			inc		r6
			jmp					alg_rom

caso_noventa:
			sub		#90, r5
			mov.b	#0x58, 0(r6)			; Move o 'XC'
			inc		r6
			mov.b	#0x43, 0(r6)			; Move o 'XC'
			inc		r6
			jmp					alg_rom

caso_cinquenta:
			sub		#50, r5
			mov.b	#0x4C, 0(r6)			; Move o 'L'
			inc		r6
			jmp					alg_rom

caso_quarenta:
			sub		#40, r5
			mov.b	#0x58, 0(r6)			; Move o 'XL'
			inc		r6
			mov.b	#0x4C, 0(r6)			; Move o 'XL'
			inc		r6
			jmp					alg_rom

caso_dez:
			sub		#10, r5
			mov.b	#0x58, 0(r6)			; Move o 'X'
			inc		r6
			jmp					alg_rom

caso_nove:
			sub		#9, r5
			mov.b	#0x49, 0(r6)			; Move o 'IX'
			inc		r6
			mov.b	#0x58, 0(r6)			; Move o 'IX'
			inc		r6
			jmp					alg_rom

caso_cinco:
			sub		#5, r5
			mov.b	#0x56, 0(r6)			; Move o 'V'
			inc		r6
			jmp					alg_rom

caso_quatro:
			sub		#4, r5
			mov.b	#0x49, 0(r6)			; Move o 'IV'
			inc		r6
			mov.b	#0x56, 0(r6)			; Move o 'IV'
			inc		r6
			jmp					alg_rom

caso_um:
			sub		#1, r5
			mov.b	#0x49, 0(r6)			; Move o 'I'
			inc		r6
			jmp					alg_rom
			nop

			.data
RESP:		.byte	"RRRRRRRRRRRRRRRRRR", 0
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
            
