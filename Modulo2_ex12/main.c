#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode

    // 32768 = 2s --> f = 2Hs -> pisca 2x em 1 segundo, logo N = (32768/4 - 1) = 8192
    TB0CCR0 = 8192;            // Configuring clock B0 - 2Hz
    TB0CTL = TBSSEL__ACLK | MC__UP;
    TB0CCTL0 = CCIE;            // Interrupt

    // 32768 = 2s --> f = 5Hs -> pisca 5x em 1 segundo, logo N = (32768/10 - 1) = 3275
    TB1CCR0 = 3275;            // Configuring clock B1 - 5Hz
    TB1CTL = TBSSEL__ACLK | MC__UP;
    TB1CCTL0 = CCIE;            // Interrupt


    P6DIR |= BIT6;              // Pino de saída P6.6 (LED verde)
    P6OUT &= ~BIT6;             // Apaga o LED verde

    P1DIR |= BIT0;              // Pino de saída P1.0 (LED vermelho)
    P1OUT &= ~BIT0;             // Apaga o LED verde


    __enable_interrupt();


    while (1) {
        // Do nothing
    }
}

#pragma vector=TIMER0_B0_VECTOR         // Pragma usado para mapear a função abaixo
__interrupt void TB0_CCR0_ISR() {       // para a ISR do CCR0 de TA0
    P1OUT ^= BIT0;
}

#pragma vector=TIMER1_B0_VECTOR         // Pragma usado para mapear a função abaixo
__interrupt void TB1_CCR0_ISR() {       // para a ISR do CCR0 de TA0
    P6OUT ^= BIT6;
}
