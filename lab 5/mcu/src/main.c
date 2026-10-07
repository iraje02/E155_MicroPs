// Ishita Raje Lab 5
// E155 Microprocessor Systems
// Main.c
// October 7, 2026

#include "main.h"
#include "STM32L432KC_FLASH.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_INTERRUPT.h"
#include "STM32L432KC_RCC.h"
#include "STM32L432KC_TIM.h"
#include <stdio.h>
#include <stdint.h>

volatile int32_t encoderCount = 0;
volatile int32_t measuredCount = 0;
volatile int measurementReady = 0;

int main(void) {
    // confirgure clock
    configureFlash();
    configureClock();

    //configure encoder A and B GPIO pins
    gpioEnable(GPIO_PORT_A);
    pinMode(ENCODER_A_PIN, GPIO_INPUT);     
    pinMode(ENCODER_B_PIN, GPIO_INPUT);  

    // initialize timer
    TIM16_init();

    // configure intterupts (EXTI)
    encoderInterrupt_init();
    timerInterrupt_init();  

    // enable interrupts globally
    __enable_irq();

    while (1) {
        if (measurementReady) {
            int32_t count = measuredCount; // Make a local copy so the ISR variables are not repeatedly accessed
            measurementReady = 0;
            // velocity =
            // counts / (counts/revolution * 1 second)
            float velocity =
                ((float) count) / ((float) COUNTS_PER_REV);
            if (velocity > 0.0f) {
                printf("velocity: %.3f rev/s, motor moving clockwise\n", velocity);
            } else if (velocity < 0.0f) {
                printf("velocity: %.3f rev/s, motor moving counterclockwise\n", velocity);
            } else {
                printf("velocity: 0.000 rev/s, motor has stopped\n");
            }
        }
    }
}

void EXTI9_5_IRQHandler(void) {
    if (EXTI->PR1 & (1 << 6)) {
        EXTI->PR1 = (1 << 6);
        int A = digitalRead(ENCODER_A_PIN);
        int B = digitalRead(ENCODER_B_PIN);
        if (A != B) {
            encoderCount++;}
        else {
            encoderCount--;
        }
    }

    if (EXTI->PR1 & (1 << 9)) {

        EXTI->PR1 = (1 << 9);
        int A = digitalRead(ENCODER_A_PIN);
        int B = digitalRead(ENCODER_B_PIN);
        if (A == B) {
            encoderCount++;} 
        else {
            encoderCount--;}
    }
}

  void TIM1_UP_TIM16_IRQHandler(void) {
    if (TIM16->SR & (1 << 0)) {
        TIM16->SR &= ~(1 << 0);
        measuredCount = encoderCount;
        encoderCount = 0;
        measurementReady = 1;
    }
  }
