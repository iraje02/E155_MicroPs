// TIM15.c
// Source code for TIM15 functions
// Ishita Raje
// 9/30/2026

#include "TIM15.h"
#include "C:\Users\iraje\Downloads\tutorial-clock-configuration-main\lib\STM32L432KC_RCC.h"

// initial set up
void TIM15_init(void) {

  RCC->APB2ENR |= (1 << 16);   // turn on timer 15

  TIM15->SMCR &= ~(1 << 16);   // SMS[3] = 0 slave mode off
  TIM15->SMCR &= ~(0b111);     // SMS[2:0] = 0 ensures the counter runs from the internal clock

  TIM15->PSC = 7999;           // go from PLL's 80 MHz to 10 kHz thsu 1 tick = 0.1 ms

  TIM15->EGR |= (1 << 0);      // UG = 1 manually update to load PSC into the prescaler
  TIM15->SR  &= ~(1 << 0);     // clear UIF flag
}

void TIM15_play(int duration_ms) {
  if (duration_ms < 1)    duration_ms = 1;      // ensures that never write ARR = -1
  if (duration_ms > 6553) duration_ms = 6553;   // ARR is 16 bits: 65536 ticks max

  TIM15->ARR = 10 * duration_ms - 1;            // 10 ticks per ms

  TIM15->EGR |= (1 << 0);      // UG = 1: reset and apply the new ARR
  TIM15->SR  &= ~(1 << 0);     // clear UIF flag

  TIM15->CR1 |= (1 << 0);      // CEN = 1 to start or keep running
}

