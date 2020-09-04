#include <msp430.h> 


/**
 * main.c
 */
unsigned char rand() {
    static unsigned char num = 5;
    num = (num * 17) % 7;
    return num;
}
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

    P6DIR |= BIT6;              // Pino de saída P6.6 (LED verde)
    P6OUT &= ~BIT6;             // Apaga o LED verde

    int count = 0;
    int random = rand();

    while (1){

        if (!(P4IN & BIT1)){            // Se S1 for apertado
            count++;                    // Incrementa o contador
            debounce();
            while (!(P4IN & BIT1));
        } else if (!(P2IN & BIT3)){       // Se S2 for apertado
            debounce();
            while (!(P2IN & BIT3));

            if (count == random){
                P6OUT |= BIT6;
                P1OUT &= ~BIT0;
            } else {
                P6OUT &= ~BIT6;
                P1OUT |= BIT0;
            }

            count = 0;
            random = rand();

        }
    }
}
