// STM32L432KC_TIM.c
// Code for TIM16 functions
// Ishita Raje
// 10/5/2026
// E155 Lab 5

#include "STM32L432KC_TIM.h"

// initial set up
void TIM16_init(void) {
  RCC->APB2ENR |= (1 << 17);   // turn on timer 16
  TIM16->PSC = 7999;          // go from PLL's 80 MHz to 1kHz (PSC+1 = 80000)
  TIM16->ARR = 9999;           // acheive a timer sampling period of 1 second
  TIM16->EGR |= (1 << 0);      // UG = 1 manually update to load PSC into the prescaler
  TIM16->SR  &= ~(1 << 0);     // clear UIF flag
  TIM16->CR1 |= (1 << 0);      // CEN = 1 to start counting
}