#include <msp430.h> 


/**
 * main.c
 */
void debounce() {
    volatile int i = 65000;
    for(i; i < 0; i--);
}

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;               // Stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode

    P6DIR |= BIT6;              // Pino de saída P6.6 (LED verde)
    P6OUT &= ~BIT6;             // Apaga o LED verde


    while (1){
        P6OUT ^= BIT6;
        debounce();
        debounce();
    }
}
