#include <msp430.h> 


/**
 * main.c
 */
void debounce() {
    volatile int i = 10000;
    for(i; i < 0; i--);
}

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;               // Stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode

    P4DIR &= ~BIT1;             // Pino de entrada (S1)
    P4REN |= BIT1;              // Habilita o resistor
    P4OUT |= BIT1;              // Pull-down

    P2DIR &= ~BIT3;             // Pino de entrada (S2)
    P2REN |= BIT3;              // Habilita o resistor
    P2OUT |= BIT3;              // Pull-down

    P1DIR |= BIT0;              // Pino de saída P1.0 (LED vermelho)
    P1OUT &= ~BIT0;             // Apaga o LED vermelho


    while(1){
        if (!(P4IN & BIT1) || !(P2IN & BIT3)){       // Se S1 ou S2 for apertado
            P1OUT ^= BIT0;         // Alterna o estado do LED
            debounce();
            while (!(P4IN & BIT1) || !(P2IN & BIT3));
        }
    }
}
