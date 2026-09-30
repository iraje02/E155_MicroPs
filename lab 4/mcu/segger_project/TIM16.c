// TIM16.c
// Source code for TIM16 functions
// Ishita Raje
// 9/30/2026

#include "TIM16.h"
#include "C:\Users\iraje\Downloads\tutorial-clock-configuration-main\lib\STM32L432KC_RCC.h"

// initial set up
void TIM16_init(void) {

  RCC->APB2ENR |= (1 << 17);   // turn on timer 16

  TIM16->PSC = 79;             // go from PLL's 80 MHz to 1MHz (PSC+1 = 80)

  TIM16->EGR |= (1 << 0);      // UG = 1 manually update to load PSC into the prescaler
  TIM16->SR  &= ~(1 << 0);     // clear UIF flag
}

void TIM16_play(int frequency) {
  if (frequency <= 0) {        // rest = stop timer
    TIM16->CR1 &= ~(1 << 0);   // CEN = 0
    return;
  }

  // one overflow is half of the square wave period.
  TIM16->ARR = ((1000000 + frequency) / (2 * frequency)) - 1;

  TIM16->EGR |= (1 << 0);      // UG = 1: reset and apply the new ARR
  TIM16->SR  &= ~(1 << 0);     // clear UIF flag

  TIM16->CR1 |= (1 << 0);      // CEN = 1 to start or keep running
}

