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

    P1DIR |= BIT0;              // Pino de saída P1.0 (LED vermelho)
    P1OUT &= ~BIT0;             // Apaga o LED vermelho


    while(1){
        if (!(P4IN & BIT1)){       // Se S1 for apertado
            P1OUT ^= BIT0;         // Alterna o estado do LED
        }
    }
}
