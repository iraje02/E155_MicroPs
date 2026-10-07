// STM32L432KC_INTERRUPT.c
// Code for interrupts
// Ishita Raje
// 10/5/2026
// E155 Lab 5


#include "main.h"
#include "stm32l432xx.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_INTERRUPT.h"


void encoderInterrupt_init(void){
    // SYSCFGEN
  RCC->APB2ENR |= (1 << 0);               //enable peripheral clock
  SYSCFG->EXTICR[1] &= ~(0x7 << 8);      //PA6 to EXTI6
  SYSCFG->EXTICR[2] &= ~(0x7 << 4);      //PA9 to EXTI9

  //configure EXTI 1
  EXTI->IMR1 |= (1 << gpioPinOffset(ENCODER_A_PIN));    // 1. Configure mask bit
  EXTI->RTSR1 |= (1 << gpioPinOffset(ENCODER_A_PIN));   // 2. Enable rising edge trigger
  EXTI->FTSR1 |= (1 << gpioPinOffset(ENCODER_A_PIN));   // 3. Enable falling edge trigger
  EXTI->PR1 = (1 << gpioPinOffset(ENCODER_A_PIN));      // 4. Clear interrupt

  //configure EXTI 2
  EXTI->IMR1 |= (1 << gpioPinOffset(ENCODER_B_PIN));    // 1. Configure mask bit
  EXTI->RTSR1 |= (1 << gpioPinOffset(ENCODER_B_PIN));   // 2. Enable rising edge trigger
  EXTI->FTSR1 |= (1 << gpioPinOffset(ENCODER_B_PIN));   // 3. Enable falling edge trigger
  EXTI->PR1 = (1 << gpioPinOffset(ENCODER_B_PIN));      // 4. Clear interrupt
  
  
  NVIC->ISER[0] |= (1 << 23);                           // 5. Turn on EXTI interrupt in NVIC_ISER (EXTI5-9 is IRQ 23)

}

void timerInterrupt_init(void){
  TIM16->SR &= ~(0x1);                     // Clear UIF
  TIM16->CNT = 0;                          // Reset count
  TIM16->DIER |= (1 << 0);
  NVIC->ISER[0] |= (1 << 25); 
}
