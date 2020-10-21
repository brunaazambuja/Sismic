#include <msp430.h> 
#include <stdint.h>

/**
 * gpio.h
 */
enum units { us, ms, sec };

void        wait(uint16_t time, enum units unit);
