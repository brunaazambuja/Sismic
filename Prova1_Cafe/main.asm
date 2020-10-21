            .cdecls C,LIST,"msp430.h"       ; Include device header file
            .def    RESET                   ; Export program entry-point
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
		    mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
; Main loop here
;
;						Aluna: Bruna Azambuja
;						Matr�cula: 18/0014153
;						Professor: Daniel Caf�
;
;-------------------------------------------------------------------------------
configLock:	.equ	LOCKLPM5

config:
			; configure aqui os pinos dos bot�es e LEDs

			bic 	#LOCKLPM5, PM5CTL0		; Modo de alta imped�ncia

			bic.b	#BIT0, &P1OUT			; Configurando o LED vermelho
			bis.b	#BIT0, &P1DIR

			bic.b	#BIT1, &P4DIR			; Configurando o bot�o S1
			bis.b	#BIT1, &P4REN
			bis.b	#BIT1, &P4OUT

			bic.b	#BIT6, &P6OUT			; Configurando o LED verde
			bis.b	#BIT6, &P6DIR

			bic.b	#BIT3, &P2DIR			; Configurando o bot�o S2
			bis.b	#BIT3, &P2REN
			bis.b	#BIT3, &P2OUT

			mov.w	#0x0FFF, r12			; Semente do n�mero aleat�rio

main:
			call	#lfsr					; Gera numero aleatorio
			call	#wait					; Espera um tempo aleatorio [128 ms a 4 sec]
			call	#display				; Faz piscar os LEDs 1 vez
			call	#readInput				; Aguarda o usuario responder e mostra para o usuario se ele acertou ou nao
			call	#response

			jmp 	main					; Recome�a do in�cio
			nop

;-------------------------------------------------------------------------------
; Rotina de delay: remover rebotes
delay:
			mov.w	#100000,R4
delay_loop:
			dec		R4
			jnz		delay_loop
			ret

;-------------------------------------------------------------------------------
; Rotina readInput : faz a leitura dos bot�es e remove o rebote
; Entrada: R5 dir� quais LEDs foram acesos (01: s� verde, 10: s� vermelho, 11: os dois)
; Saida
; - R12: dir� se ganhou ou perdeu ou deu timeout (ganhou: 1, perdeu: 2, timeout: 3)

contabilizaTempo:
			clrc							; Contabilizando o tempo
			add		#1, r10
			addc	#0, r11
			ret

readInput:									; Loop Infinito
			clr		r10						; R10 <- LSB contador do tempo
			clr		r11						; R11 <- MSB contador do tempo
			clr		r6						; R6 <- recebe a entrada do usu�rio (01 -> S2, 10 -> S1, 11 -> S1&S2)

;-----------------------------------

amostra:
			call 	#contabilizaTempo
			bit.b	#BIT1, P4IN				; Testa o S1
			jnc		S1Apertado

			bit.b	#BIT3, P2IN				; Se o S1 n�o estiver apertado, testa S2
			jnc		S2Apertado
			jmp		amostra					; Fica em loop verificando os dois bot�es

S1Apertado:
			bis.b	#BIT1, R6				; Guarda em R6 qual bot�o foi apertado (S1)

S1_Loop:
			call 	#contabilizaTempo

			bit.b	#BIT3, P2IN				; Caso o S1 esteja apertado, testa o S2
			jnc		ambosApertados

			bit.b	#BIT1, P4IN				; Caso S2 n�o esteja apertado, testa se soltou o S1
			jnc		S1_Loop
			jmp		soltou

S2Apertado:
			bis.b	#BIT0, R6				; Guarda em R6 qual bot�o foi apertado (S2)

S2_Loop:
			call 	#contabilizaTempo

			bit.b	#BIT1, P4IN				; Caso o S1 esteja apertado, testa o S1
			jnc		ambosApertados

			bit.b	#BIT3, P2IN				; Caso S1 n�o esteja apertado, testa se soltou o S2
			jnc		S2_Loop
			jmp		soltou

ambosApertados:
			bis.b	#BIT0, R6				; Guarda em R6 qual bot�o foi apertado (S1&S2)
			bis.b	#BIT1, R6

ambos_Loop:
			call	#contabilizaTempo

			bit.b	#BIT3, P2IN				; Testa se soltou S1, e vai para a rotina do mesmo
			jc		S1_Loop

			bit.b	#BIT1, P4IN				; Testa se soltou S2, e vai para a rotina do mesmo
			jc		S2_Loop

			jmp		ambos_Loop

soltou:
			ret

;-------------------------------------------------------------------------------
; Rotina response : acende os LEDs avisando ao usu�rio se ele ganhou ou perdeu ou deu timeout
;Entradas:	r11|r10					; R10 <- LSB e R11 <- MSB do contador do tempo
;									; R11 <- MSB contador do tempo
;			r6						; R6 <- recebe a entrada do usu�rio
;			r5						; R5 <- registro de quais leds acendem

response:
			push	r12						; guarda o valor de R12 para n�o perd�-lo

			mov.w	#0x3, r12				; R12 ser� o contador de vezes que far� o LED piscar

			cmp		#0x00, r11				; caso r10+r11 sejam maiores que 0x0000FDE8 = 65000
			jeq		comparaR10				; � por que deu timeout
			jhs		timeout

comparaR10:
			cmp.b	#0xFDE8, r10			; caso r10 passe de 65000, deu timeout
			jhs		timeout

			cmp.b	r5, r6					; compara o reg. que armazena os leds que foram acesos
			jeq		ganhou					; com o reg. que armazena os bot�es apertados pelo usu�rio
			jne		perdeu

timeout:
			bis.b	#BIT0,P1OUT				; liga o LED vermelho de acordo com a m�scara dos bot�es
			bis.b	#BIT6,P6OUT				; liga o LED verde de acordo com a m�scara dos bot�es
			call	#delay
			bic.b	#BIT0,P1OUT				; apaga o LED vermelho
			bic.b	#BIT6,P6OUT				; apaga o LED verde
			call	#delay

			dec		R12
			jnz		timeout
			jmp		return

perdeu:
			bis.b	#BIT0,P1OUT				; liga o LED vermelho de acordo com a m�scara dos bot�es
			call	#delay
			bic.b	#BIT0,P1OUT				; apaga o LED vermelho
			call	#delay

			dec		R12
			jnz		perdeu
			jmp		return
ganhou:
			bis.b	#BIT6,P6OUT				; liga o LED verde de acordo com a m�scara dos bot�es
			call	#delay
			bic.b	#BIT6,P6OUT				; apaga o LED verde
			call	#delay

			dec		R12
			jnz		ganhou
			jmp		return

return:
			pop		r12
			ret

;-------------------------------------------------------------------------------
; Rotina display : Acende os LEDs com base no conte�do de R12
; Entradas
; - R12: N�mero aleatorio gerado por lfsr
; Saidas
; - LEDs: Acende de acordo com BIT9 (Verde) e BIT1 (Vermelho) --- bits dos bot�es (BIT1 verde e BIT3 vermelho)
; - R5: ter� qual LED foi aceso (01: s� verde, 10: s� vermelho, 11: os dois)

display:
			bit.w	#BIT1, R12				; Testa o valor do BIT1 verde no numero aleatorio de R12
			jc		testaVermelho
			jnc		vermelhoAcende			; caso o verde n�o esteja aceso, quer dizer que o vermelho est�
											; pois a rotina de numeros alet�rios n�o deixa vir os dois zerados
testaVermelho:
			bit.w	#BIT3, R12				; Testa o valor do BIT3 vermelho no numero aleatorio de R12
			jc		doisAcendem

verdeAcende:
			mov.b	#0x1, R5				; bota em R5 o n�mero 01b para indicar que o verde acendeu
			bis.b	#BIT6,P6OUT				; liga o LED verde de acordo com a m�scara dos bot�es
			call 	#delay
			bic.b	#BIT6,P6OUT				; apaga o LED verde
			jmp		retorna

vermelhoAcende:
			mov.b	#0x2, R5				; bota em R5 o n�mero 10b para indicar que o vermelho acendeu
			bis.b	#BIT0,P1OUT				; liga o LED vermelho de acordo com a m�scara dos bot�es
			call	#delay
			bic.b	#BIT0,P1OUT				; apaga o LED vermelho
			jmp		retorna

doisAcendem:
			mov.b	#0x3, R5				; bota em R5 o n�mero 11b para indicar que os dois acenderam
			bis.b	#BIT0,P1OUT				; liga o LED vermelho de acordo com a m�scara dos bot�es
			bis.b	#BIT6,P6OUT				; liga o LED verde de acordo com a m�scara dos bot�es
			call	#delay
			bic.b	#BIT0,P1OUT				; apaga o LED vermelho
			bic.b	#BIT6,P6OUT				; apaga o LED verde

retorna:
			ret

;-------------------------------------------------------------------------------
; Rotina wait : Espera um tempo dado em ms
; Entradas: - R12: valor de tempo em ms
wait:
			mov.w	r12, r13				; roda 1ms R12 vezes
			bic.w	#(BITF|BITE|BITD|BITC), r13	; retira os bits mais significantes para n�o passar de 4segs
rot1:										; 4segs = representa��o m�xima em 12bits (R12)
			mov.w	#350, r14				; quantidade de batidas de clock em 1ms para 3 opera��es (jmp 2x e atrib 1x)
rot2:										; conta: frequencia/1000ms x 3 = 2^20 / 3k = 350
											; 1.048/3 = 350
			dec		r14
			jnz		rot2
			dec		r13
			jnz		rot1

			ret

;-------------------------------------------------------------------------------
; Rotina lfsr: Linear Feedback Shift Register
; Saida
; - R12: N�mero pseudo-aleatorio
lfsr:
			mov		R12,R13
			and		#(BITB|BIT8|BIT6),R13	; cria uma m�scara com os bits que vou usar para fazer xor

			bit		#BIT0,R12				; testa o bit menos significativo do R12
			jc		bitUm
			jmp		bitZero
bitUm:
			xor		#0xFFFF,R13				; se for um, faz xor na m�scara com 1
bitZero:									; se for zero, n�o precisa fazer xor pois xor com zero n�o muda
			clrc
			rrc		R12						; rotaciona R12
			clrc
			rrc		R13						; rotaciona R13
			and		#(BITB|BITA|BIT7|BIT5),R13		; zera os outros bits que n�o v�o ser usados em R13
			bic		#(BITB|BITA|BIT7|BIT5),R12		; zera os bits em R12 que vou setar com a m�scara R13
			bis		R13,R12					; aplica m�scara R13 em R12

			bit		#BIT1,R12				; testa se os BITs 1 e 3 s�o zero,
			jc		fim						; pois se os dois forem zero, tenho que gerar um novo n�mero
											; aleat�rio pois esse n�o iria acender nenhum LED
			bit		#BIT3,R12
			jnc		lfsr
fim:
			ret

;-------------------------------------------------------------------------------
; RAM
;-------------------------------------------------------------------------------
			.data
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
            
