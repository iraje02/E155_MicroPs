// main.c
// Fur Elise, E155 Lab 4
// Based on starter code given
// Ishita Raje
// 9/30/2026
// TIM16 sets the pitch
// TIM15 sets the duration of each note

#include "C:\Users\iraje\Downloads\tutorial-clock-configuration-main\lib\STM32L432KC_GPIO.h"
#include "C:\Users\iraje\Downloads\tutorial-clock-configuration-main\lib\STM32L432KC_RCC.h"
#include "C:\Users\iraje\Downloads\tutorial-clock-configuration-main\lib\STM32L432KC_FLASH.h"
#include "C:\Users\iraje\Documents\SEGGER Embedded Studio Projects\Executable_1\TIM15.h"
#include "C:\Users\iraje\Documents\SEGGER Embedded Studio Projects\Executable_1\TIM16.h"

// speaker (LM386) output pin chosen to be wired to GPIO pin 7
#define SPEAKER_PIN 7   // PB7 

// Fur Elise
// Pitch in Hz, duration in ms
const int notes[][2] = {
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{416, 125},
{494, 125},
{523, 250},
{  0, 125},
{330, 125},
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{523, 125},
{494, 125},
{440, 250},
{  0, 125},
{494, 125},
{523, 125},
{587, 125},
{659, 375},
{392, 125},
{699, 125},
{659, 125},
{587, 375},
{349, 125},
{659, 125},
{587, 125},
{523, 375},
{330, 125},
{587, 125},
{523, 125},
{494, 250},
{  0, 125},
{330, 125},
{659, 125},
{  0, 250},
{659, 125},
{1319, 125},
{  0, 250},
{623, 125},
{659, 125},
{  0, 250},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{416, 125},
{494, 125},
{523, 250},
{  0, 125},
{330, 125},
{659, 125},
{623, 125},
{659, 125},
{623, 125},
{659, 125},
{494, 125},
{587, 125},
{523, 125},
{440, 250},
{  0, 125},
{262, 125},
{330, 125},
{440, 125},
{494, 250},
{  0, 125},
{330, 125},
{523, 125},
{494, 125},
{440, 500},
{  0, 0}};

// Mary Had A Little Lamb
/*
const int notes[][2] = {
    {659, 250},   // E
    {587, 250},   // D
    {523, 250},   // C
    {587, 250},   // D

    {659, 250},   // E
    {659, 250},   // E
    {659, 500},   // E

    {587, 250},   // D
    {587, 250},   // D
    {587, 500},   // D

    {659, 250},   // E
    {784, 250},   // G
    {784, 500},   // G

    {659, 250},   // E
    {587, 250},   // D
    {523, 250},   // C
    {587, 250},   // D

    {659, 250},   // E
    {659, 250},   // E
    {659, 250},   // E
    {659, 250},   // E

    {587, 250},   // D
    {587, 250},   // D
    {659, 250},   // E
    {587, 250},   // D

    {523, 600},   // C

    {0, 0}
};

*/

int main(void) {
  // PLL clock at 80 MHz 
  // TIM15 and TIM16 on APB2 also runs at 80 MHz with the reset prescalers.
  setFlashLatency(4);                    // 4 wait states (from main.c tutorial done in class)
  configurePLL(PLLSRC_MSI, 1, 40, 2);
  selectSysclk(SW_PLL);

  RCC->AHB2ENR |= (1 << 1);              // GPIOB clock turned on 
  pinMode(SPEAKER_PIN, GPIO_OUTPUT);     // speaker pin set as output
  digitalWrite(SPEAKER_PIN, GPIO_LOW);   // start low (silence)

  // begin timers
  TIM15_init();
  TIM16_init();

  // play the song
  for (int i = 0; notes[i][1] != 0; i++) {
    int pitch    = notes[i][0];   //  in Hz
    int duration = notes[i][1];   // in ms

    digitalWrite(SPEAKER_PIN, GPIO_LOW);

    TIM16_play(pitch);       
    TIM15_play(duration);

    // until done playing the note, toggle the pin on every half period
    while (!(TIM15->SR & (1 << 0))) {
      if (pitch != 0 && (TIM16->SR & (1 << 0))) {
        TIM16->SR &= ~(1 << 0);                // clear UIF
        togglePin(SPEAKER_PIN);
      }
    }
  }

  // once song is over
  TIM16->CR1 &= ~(1 << 0);    // CEN for timer 16 = 0
  TIM15->CR1 &= ~(1 << 0);    // CEN for timer 15 = 0
  digitalWrite(SPEAKER_PIN, GPIO_LOW);    // silence

  while (1);
  return 0;
}
