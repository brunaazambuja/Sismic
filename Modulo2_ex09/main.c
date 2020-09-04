#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode

    TB0CCR0 = 16383;            // Configuring clock
    TB0CTL = TBSSEL__ACLK | MC__UP;

    P6DIR |= BIT6;              // Pino de saída P6.6 (LED verde)
    P6OUT &= ~BIT6;             // Apaga o LED verde


    while (1) {
        P6OUT ^= BIT6;
        while(!(TB0CCTL0 & CCIFG));     // Aguarda o final da contagem
        TB0CCTL0 &= ~CCIFG;             // Zera a flag CCIFG
    }
}
