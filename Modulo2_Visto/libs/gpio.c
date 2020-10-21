#include <msp430.h> 
#include <stdint.h>
#include "gpio.h"

/**
 * gpio.c
 */


void digitalWrite(uint8_t port, uint8_t bit, uint8_t value){
    uint8_t mask = 1 << bit;

    switch(port){
        case 1:
            if (value)
                P1OUT |= mask;
            else
                P1OUT &= ~mask;
            break;
        case 2:
            if (value)
                P2OUT |= mask;
            else
                P2OUT &= ~mask;
            break;
        case 3:
            if (value)
                P3OUT |= mask;
            else
                P3OUT &= ~mask;
            break;
        case 4:
            if (value)
                P4OUT |= mask;
            else
                P4OUT &= ~mask;
            break;
        case 5:
            if (value)
                P5OUT |= mask;
            else
                P5OUT &= ~mask;
            break;
        case 6:
            if (value)
                P6OUT |= mask;
            else
                P6OUT &= ~mask;
            break;
        default: break;
    }
}

uint8_t digitalRead(uint8_t port, uint8_t bit){
    uint8_t mask = 1 << bit;
    uint8_t valueRead;

    switch(port){
        case 1:
            valueRead = P1IN & mask;
            break;
        case 2:
            valueRead = P2IN & mask;
            break;
        case 3:
            valueRead = P3IN & mask;
            break;
        case 4:
            valueRead = P4IN & mask;
            break;
        case 5:
            valueRead = P5IN & mask;
            break;
        case 6:
            valueRead = P6IN & mask;
            break;
        default: break;
    }

    return valueRead;
}

void pinConfiguration(uint8_t port, uint8_t bit, enum pinModes mode){
    uint8_t mask = 1 << bit;

    switch(port){
        case 1:
            switch(mode){
                case input:
                    P1DIR &= ~mask;
                    P1REN &= ~mask;
                    P1OUT &= ~mask;
                    break;
                case output:
                    P1DIR |= mask;
                    P1OUT &= ~mask;
                    break;
                case inPullUp:
                    P1DIR &= ~mask;
                    P1REN |= mask;
                    P1OUT |= mask;
                    break;
                case inPullDown:
                    P1DIR &= ~mask;
                    P1REN |= mask;
                    P1OUT &= ~mask;
                    break;
                default: break;
            }
            break;
        case 2:
            switch(mode){
                case input:
                    P2DIR &= ~mask;
                    P2REN &= ~mask;
                    P2OUT &= ~mask;
                    break;
                case output:
                    P2DIR |= mask;
                    P2OUT &= ~mask;
                    break;
                case inPullUp:
                    P2DIR &= ~mask;
                    P2REN |= mask;
                    P2OUT |= mask;
                    break;
                case inPullDown:
                    P2DIR &= ~mask;
                    P2REN |= mask;
                    P2OUT &= ~mask;
                    break;
                default: break;
            }
            break;
        case 3:
            switch(mode){
                case input:
                    P3DIR &= ~mask;
                    P3REN &= ~mask;
                    P3OUT &= ~mask;
                    break;
                case output:
                    P3DIR |= mask;
                    P3OUT &= ~mask;
                    break;
                case inPullUp:
                    P3DIR &= ~mask;
                    P3REN |= mask;
                    P3OUT |= mask;
                    break;
                case inPullDown:
                    P3DIR &= ~mask;
                    P3REN |= mask;
                    P3OUT &= ~mask;
                    break;
                default: break;
            }
            break;
        case 4:
            switch(mode){
                case input:
                    P4DIR &= ~mask;
                    P4REN &= ~mask;
                    P4OUT &= ~mask;
                    break;
                case output:
                    P4DIR |= mask;
                    P4OUT &= ~mask;
                    break;
                case inPullUp:
                    P4DIR &= ~mask;
                    P4REN |= mask;
                    P4OUT |= mask;
                    break;
                case inPullDown:
                    P4DIR &= ~mask;
                    P4REN |= mask;
                    P4OUT &= ~mask;
                    break;
                default: break;
            }
            break;
        case 5:
            switch(mode){
                case input:
                    P5DIR &= ~mask;
                    P5REN &= ~mask;
                    P5OUT &= ~mask;
                    break;
                case output:
                    P5DIR |= mask;
                    P5OUT &= ~mask;
                    break;
                case inPullUp:
                    P5DIR &= ~mask;
                    P5REN |= mask;
                    P5OUT |= mask;
                    break;
                case inPullDown:
                    P5DIR &= ~mask;
                    P5REN |= mask;
                    P5OUT &= ~mask;
                    break;
                default: break;
            }
            break;
        case 6:
            switch(mode){
                case input:
                    P6DIR &= ~mask;
                    P6REN &= ~mask;
                    P6OUT &= ~mask;
                    break;
                case output:
                    P6DIR |= mask;
                    P6OUT &= ~mask;
                    break;
                case inPullUp:
                    P6DIR &= ~mask;
                    P6REN |= mask;
                    P6OUT |= mask;
                    break;
                case inPullDown:
                    P6DIR &= ~mask;
                    P6REN |= mask;
                    P6OUT &= ~mask;
                    break;
                default: break;
            }
            break;
        default: break;
    }
}
