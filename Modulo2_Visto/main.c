#include <msp430.h> 
#include "libs/timer.h"
#include "libs/gpio.h"

/**
 * main.c
 * Visto 2 - Bruna Azambuja - 18/0014153
 */

void trigger();
void checkDistance(int dist);
void configuraPinos();
void configuraTimer();

volatile int dist;
uint16_t t1, t2, flag = 0;

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;                               // stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode

    configuraTimer();
    configuraPinos();


    uint16_t deltaT;

    while(1){
        flag = 0;

        wait(500, ms);
        trigger();                                          // manda um sinal para o sensor

        while(!flag);                                       // espera ocorrer a interrupção

        deltaT = t2 - t1;                                   // calcula a diferenca entre t2 e t1

        dist = 34.3 * deltaT/(32*2);                        // quantos ms durou o echo: deltaT/2^15*1ms = deltaT/32
                                                            // o echo vai e volta = deltaT/2
                                                            // Vsom no ar = 34,3 cm/ms * deltaT

        checkDistance(dist);                                // mostramos a resposta

    }
}


#pragma vector = TIMER1_B1_VECTOR
__interrupt void TB1_CCRN_ISR(){
    switch(TB1IV){
        case 2:                                             // CCR1
            if (TB1CCTL1 & CCI){                            // flanco de subida
                t1 = TB1CCR1;
            } else if (!(TB1CCTL1 & CCI)){                  // flanco de descida
                t2 = TB1CCR1;
                flag = 1;
            }
            break;
        default: break;
    }
}

void configuraTimer(){
    TB1CTL = TBSSEL__ACLK | MC__CONTINUOUS;

    TB1CCTL1 = CAP | CM_3 | CCIE;                           // Modo de captura 3 e interrupção

    __enable_interrupt();                                   // Habilida interrupcoes globais
}


void trigger(){
    P1OUT |= BIT2;
    wait(500, us);
    P1OUT &= ~BIT2;
}

void checkDistance(int dist){
    if(dist < 20){
        digitalWrite(1, 0, 0);
        digitalWrite(6, 6, 0);
    } else if(dist > 20 && dist <= 40){
        digitalWrite(1, 0, 0);
        digitalWrite(6, 6, 1);
    } else if(dist > 40 && dist <= 60){
        digitalWrite(1, 0, 1);
        digitalWrite(6, 6, 0);
    } else if(dist > 60){
        digitalWrite(1, 0, 1);
        digitalWrite(6, 6, 1);
    }
}

void configuraPinos(){
    pinConfiguration(1, 0, output);                         // configura LED vermelho
    pinConfiguration(6, 6, output);                         // configura LED verde

    P1OUT &= ~BIT2;                                         // configura P1.2 como saida
    P1DIR |=  BIT2;                                         // do trigger ao sensor

    P2DIR &= ~BIT0;                                         // configura P2.0 como entrada
    P2SEL0 |=  BIT0;                                        // do sensor (echo) -> saída do timer B1.1
    P2SEL1 &=  ~BIT0;                                       // função 2 -> SELx = 01
}


