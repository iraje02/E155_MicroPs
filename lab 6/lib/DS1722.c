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
    setResolution(9); // default is 9
}

void setResolution(int bits) {
    if (bits < 8)  bits = 8;
    if (bits > 12) bits = 12;
    uint8_t config = 0xE0 | ((bits - 8) << 1);
 
    digitalWrite(PB4, PIO_HIGH);  // then set high to select sensor
    spiSendReceive(0x80);   // send configuration write address
    spiSendReceive(config);
    digitalWrite(PB4, PIO_LOW);  // set low again
}

float readTemperature(void) {
    
    digitalWrite(PB4, PIO_HIGH);
    spiSendReceive(0x02);
    uint8_t temperatureMSB = spiSendReceive(0x00);
    digitalWrite(PB4, PIO_LOW);

    digitalWrite(PB4, PIO_HIGH);
    spiSendReceive(0x01);
    uint8_t temperatureLSB = spiSendReceive(0x00);
    digitalWrite(PB4, PIO_LOW);
 
    // MSB and LSB is a signed two's-complement value in units of 1/256 degC
    int16_t raw = (int16_t)((temperatureMSB << 8) | temperatureLSB);
    return raw / 256.0f;
}
