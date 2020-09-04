#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode

    TB0CCR0 = 16383;            // Configuring clock
    TB0CTL = TBSSEL__ACLK | MC__UP;
    TB0CCTL0 = CCIE;            // Interrupt

    P6DIR |= BIT6;              // Pino de saída P6.6 (LED verde)
    P6OUT &= ~BIT6;             // Apaga o LED verde

    __enable_interrupt();


    while (1) {
        // Do nothing
    }
}

#pragma vector=TIMER0_B0_VECTOR         // Pragma usado para mapear a função abaixo
__interrupt void TB0_CCR0_ISR() {       // para a ISR do CCR0 de TA0
    P6OUT ^= BIT6;                      // Código executado quando TA0R == CCR0
}
