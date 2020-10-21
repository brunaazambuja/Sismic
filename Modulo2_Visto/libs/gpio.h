#include <msp430.h> 
#include <stdint.h>

/**
 * gpio.h
 */
enum pinModes { input, output, inPullUp, inPullDown };

void        digitalWrite(uint8_t port, uint8_t bit, uint8_t value);
uint8_t     digitalRead(uint8_t port, uint8_t bit);
void        pinConfiguration(uint8_t port, uint8_t bit, enum pinModes mode);
