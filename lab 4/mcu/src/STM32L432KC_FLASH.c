// STM32L432KC_FLASH.c
// Source code for FLASH functions

#include "STM32L432KC_FLASH.h"

void setFlashLatency(uint32_t waitStates) {
  // Flash is slower than the CPU at high clock speeds. Each wait state gives
  // every flash read one more HCLK cycle to complete.
  FLASH->ACR = (FLASH->ACR & ~(0b111 << 0)) | (waitStates << 0); // LATENCY
  while ((FLASH->ACR & 0b111) != waitStates); // Wait until the new latency is in effect

  FLASH->ACR |= (1 << 8); // PRFTEN: turn on prefetch
}
