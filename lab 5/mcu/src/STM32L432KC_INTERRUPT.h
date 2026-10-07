// STM32L432KC_INTERRUPT.h

#ifndef STM32L4_INT_H
#define STM32L4_INT_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stm32l432xx.h>

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////


void encoderInterrupt_init(void);
void timerInterrupt_init(void);

#endif