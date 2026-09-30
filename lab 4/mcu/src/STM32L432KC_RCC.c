// STM32L432KC_RCC.c
// Source code for RCC functions

#include "STM32L432KC_RCC.h"

void enableHSI16(void) {
  RCC->CR |= (1 << 8);            // HSION: turn on the 16 MHz internal RC oscillator
  while (!((RCC->CR >> 10) & 1)); // Wait for HSIRDY: oscillator is stable
}

void selectSysclk(uint32_t sw) {
  // One read-modify-write so SW never passes through an intermediate value.
  // (Clearing first and then setting would briefly select MSI = 0b00.)
  RCC->CFGR = (RCC->CFGR & ~(0b11 << 0)) | (sw << 0);

  // SW is a request; SWS reports which source is actually driving SYSCLK
  while (((RCC->CFGR >> 2) & 0b11) != sw);
}

void setAHBPrescaler(uint32_t hpre) {
  // HCLK = SYSCLK / (AHB prescaler)
  RCC->CFGR = (RCC->CFGR & ~(0b1111 << 4)) | (hpre << 4);
}

void configurePLL(uint32_t src, uint32_t m, uint32_t n, uint32_t r) {
  // PLLCLK = (src / M) * N / R
  //   src / M must be 4-16 MHz, (src / M) * N must be 64-344 MHz, PLLCLK must be <= 80 MHz

  // Turn off the PLL and wait until it has stopped. PLLCFGR can only be written while it is off.
  RCC->CR &= ~(1 << 24);        // PLLON = 0
  while ((RCC->CR >> 25) & 1);  // Wait for PLLRDY = 0

  // PLL input clock source
  RCC->PLLCFGR &= ~(0b11 << 0);
  RCC->PLLCFGR |= (src << 0);

  // M: field holds M - 1 (000 -> /1, ..., 111 -> /8)
  RCC->PLLCFGR &= ~(0b111 << 4);
  RCC->PLLCFGR |= ((m - 1) << 4);

  // N: field holds N itself (8-86). The reset value is N = 16, so it must be cleared first.
  RCC->PLLCFGR &= ~(0b1111111 << 8);
  RCC->PLLCFGR |= (n << 8);

  // R: field holds R/2 - 1 (00 -> /2, 01 -> /4, 10 -> /6, 11 -> /8)
  RCC->PLLCFGR &= ~(0b11 << 25);
  RCC->PLLCFGR |= ((r / 2 - 1) << 25);

  // Enable the R output (PLLCLK), the PLL output that can drive SYSCLK
  RCC->PLLCFGR |= (1 << 24);    // PLLREN


  // Turn on the PLL and wait for it to lock
  RCC->CR |= (1 << 24);         // PLLON
  while (!((RCC->CR >> 25) & 1)); // Wait for PLLRDY = 1
}
