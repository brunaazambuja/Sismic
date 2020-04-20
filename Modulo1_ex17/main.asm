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

; Esse exercício pede Escreva a Rotina LEDS que apresenta o seguinte controle para os leds.
; Chave S1: a cada acionamento (AF), inverte o estado do LED 1;
; Chave S2: a cada acionamento (AF), inverte o estado do LED 2;
; Enquanto ambas chaves estiverem acionadas (ambas fechadas), os leds piscam de
; forma complementar, na frequência de 1 Hz. Por complementar se entende um led aceso
; e o outro apagado. Quando ambas as chaves forem liberadas, é restaurado o estado dos
; leds, que voltam a obedecer aos controles das chaves S1 e S2
                                            
; Não sei fazer
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
            
