#include <msp430.h> 


/**
 * main.c
 */


int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;               // Disable the GPIO power-on default high-impedance mode


    // 50Hz -> logo N = (32768/50 - 1) ~= 655

    TB0CTL = TBSSEL__ACLK | MC__UP;
    TB0CCR0 = 655;                      // Configuring clock B0 - 50Hz
    TB0CCTL0 = CCIE;                    // Interrupt

    TB0CCR1 = 655 * 0.5;                // PWD
    TB0CCTL1 = CCIE;

    P1DIR |= BIT0;                      // Pino de saída P1.0 (LED vermelho)
    P1OUT &= ~BIT0;                     // Apaga o LED verde

    P4DIR &= ~BIT1;                     // Pino de entrada (S1)
    P4REN |= BIT1;                      // Habilita o resistor
    P4OUT |= BIT1;                      // Pull-down

    P2DIR &= ~BIT3;                     // Pino de entrada (S2)
    P2REN |= BIT3;                      // Habilita o resistor
    P2OUT |= BIT3;                      // Pull-down


    __enable_interrupt();


    while (1) {
        if (!(P4IN & BIT1)){               // Se S1 for apertado
            TB0CCR1 -= 0.1 * TB0CCR0;
            if (TB0CCR1 <= 0){
                TB0CCR1 = TB0CCR0;
            }
            while (!(P4IN & BIT1));

        } else if (!(P2IN & BIT3)){       // Se S2 for apertado
            TB0CCR1 += 0.1 * TB0CCR0;
            if (TB0CCR1 > TB0CCR0){
                TB0CCR1 = 0;
            }
            while (!(P2IN & BIT3));
        }

    }
}

#pragma vector=TIMER0_B0_VECTOR         // Pragma usado para mapear a função abaixo
__interrupt void TB0_CCR0_ISR() {       // para a ISR do CCR0 de TB0
    P1OUT |= BIT0;
}

#pragma vector=TIMER0_B1_VECTOR         // Pragma usado para mapear a função abaixo
__interrupt void TB0_CCR1_ISR() {       // para a ISR do CCR0 de TB0
    switch (TB0IV){
        case 0x2:                       // Canal 1
            P1OUT &= ~BIT0;
            break;
        default:
            break;
        }
}

