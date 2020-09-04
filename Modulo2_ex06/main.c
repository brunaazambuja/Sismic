#include <msp430.h> 


/**
 * main.c
 */
void debounce() {
    volatile int i = 10000;
    for(i; i < 0; i--);
}

void writeNums(int num){
    switch(num){
        case 1:
            P6OUT |= BIT6;
            P1OUT &= ~BIT0;
            break;
        case 2:
            P6OUT &= ~BIT6;
            P1OUT |= BIT0;
            break;
        case 3:
            P6OUT |= BIT6;
            P1OUT |= BIT0;
            break;
        default:
            P6OUT &= ~BIT6;
            P1OUT &= ~BIT0;
            break;
    }
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

    P6DIR |= BIT6;              // Pino de saída P6.6 (LED verde)
    P6OUT &= ~BIT6;             // Apaga o LED verde

    int i = 0;


    while(1){
        if (!(P4IN & BIT1)){       // Se S1 for apertado
            i--;
            if (i < 0){
                i = 3;
            }
            debounce();
            while (!(P4IN & BIT1));

        } else if (!(P2IN & BIT3)){       // Se S2 for apertado
            i++;
            if (i > 3){
                i = 0;
            }
            debounce();
            while (!(P2IN & BIT3));
        }

        writeNums(i);
    }
}
