#include <msp430.h> 
#include <stdint.h>
#include "timer.h"

/**
 * gpio.c
 */

void wait(uint16_t time, enum units unit){

    if (unit == us){

        TB0CTL = TBSSEL__SMCLK |            // SMCLK = 1048576Hz = 2^20 =~ 1MHz -> cada passo é 1us
                        MC__UP |            // Modo UP
                        TBCLR;              // Inicia contagem do zero

        TB0CCR0 = time - 1;                 // CCR0 = teto de contagem

        while(!(TB0CCTL0 & CCIFG));         // Aguarda o final da contagem - trava de execução
        TB0CCTL0 &= ~CCIFG;                 // Zera a flag CCIFG

        TB0CTL = MC__STOP;                  // Para a contagem

        return;

    } else if (unit == ms){

        uint16_t timer_ms = 0;

        TB0CTL = TBSSEL__ACLK |             // ACLK = 32768Hz = 2^15
                       MC__UP |             // Modo UP
                       TBCLR;               // Inicia contagem do zero

        TB0CCR0 = 33 - 1;                   // CCR0 = teto de contagem
                                            // N = fclk*Tsig = 32,768 =~ 33 - 1 -> base de tempo para 1ms

        while(timer_ms != time){

            while(!(TB0CCTL0 & CCIFG));     // Aguarda o final da contagem - trava de execução
            TB0CCTL0 &= ~CCIFG;             // Zera a flag CCIFG

            timer_ms++;
        }

        TB0CTL = MC__STOP;                  // Para a contagem

        return;

    } else if (unit == sec){

        uint16_t timer_sec = 0;

        TB0CTL = TBSSEL__ACLK |             // ACLK = 32768Hz = 2^15
                       MC__UP |             // Modo UP
                       TBCLR;               // Inicia contagem do zero

        TB0CCR0 = 32768 - 1;                // CCR0 = teto de contagem
                                            // N = fclk*Tsig = 32768 - 1 -> base de tempo para 1sec

        while(timer_sec != time){

            while(!(TB0CCTL0 & CCIFG));     // Aguarda o final da contagem - trava de execução
            TB0CCTL0 &= ~CCIFG;             // Zera a flag CCIFG

            timer_sec++;
        }

        TB0CTL = MC__STOP;                  // Para a contagem

        return;
    }
}

