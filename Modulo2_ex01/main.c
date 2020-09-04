#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;               // Stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode

	P4DIR &= ~BIT1;             // Pino de entrada (S1)
	P4REN |= BIT1;              // Habilita o resistor
	P4OUT |= BIT1;              // Pull-down

	P6DIR |= BIT6;              // Pino de saída P6.6 (LED verde)
	P6OUT &= ~BIT6;             // Apaga o LED verde


	while(1){
	    if (P4IN & BIT1){       // Se S1 for solto
	        P6OUT &= ~BIT6;     // Apaga o LED
	    } else {
	        P6OUT |= BIT6;      // Acende o LED
	    }
	}
}
