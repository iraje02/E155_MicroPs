// STM32L432KC_FLASH.c
// Source code for FLASH functions
// Given starter code
// Ishita Raje
// 10/5/2026
// E155 Lab 5

#include "STM32L432KC_FLASH.h"

void configureFlash(void) {
  FLASH->ACR |= FLASH_ACR_LATENCY_4WS;
  FLASH->ACR |= FLASH_ACR_PRFTEN;
}