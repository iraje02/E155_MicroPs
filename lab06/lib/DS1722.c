// DS1722.c
// Ishita Raje
// iraje@hmc.edu
// 10/30/2026

#include "DS1722.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_SPI.h"

  void initDS1722(void) {
    pinMode(PB4, GPIO_OUTPUT); // chose PB4 as the chip enable CE
    digitalWrite(PB4, PIO_LOW); // CE is active high so start low

    digitalWrite(PB4, PIO_HIGH);  // then set high to select sensor
    spiSendReceive(0x80); // send configuration write address
    spiSendReceive(0xE2); // 9-bit continuous conversion 
    digitalWrite(PB4, PIO_LOW); // set low again
}

float readTemperature(void) {
    digitalWrite(PB4, PIO_HIGH);
    spiSendReceive(0x01);
    uint8_t temperatureLSB = spiSendReceive(0x00);
    uint8_t temperatureMSB = spiSendReceive(0x00);
    digitalWrite(PB4, PIO_LOW);

    int8_t number = (int8_t)temperatureMSB;
    uint8_t fraction = temperatureLSB >> 7;
    float temperature = number + (fraction * 0.5f);
    return temperature;
}