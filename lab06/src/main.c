/*
File: Lab_6_JHB.c
Author: Josh Brake
Email: jbrake@hmc.edu
Date: 9/14/19
*/


#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdio.h>
#include "main.h"
#include "STM32L432KC_SPI.h"
#include "DS1722.h"
#include "STM32L432KC_USART.h"
#include "STM32L432KC_TIM.h"
#include "STM32L432KC_RCC.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_FLASH.h"

/////////////////////////////////////////////////////////////////
// Provided Constants and Functions
/////////////////////////////////////////////////////////////////

//Defining the web page in two chunks: everything before the current time, and everything after the current time
char* webpageStart = "<!DOCTYPE html><html><head><title>E155 Web Server Demo Webpage</title>\
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
	</head>\
	<body><h1>E155 Web Server Demo Webpage</h1>";
char* ledStr = "<p>LED Control:</p><form action=\"ledon\"><input type=\"submit\" value=\"Turn the LED on!\"></form>\
	<form action=\"ledoff\"><input type=\"submit\" value=\"Turn the LED off!\"></form>";

char* resStr = "<h2>Temperature Resolution</h2>\
	<form action=\"res8\"><input type=\"submit\" value=\"8-bit\"></form>\
	<form action=\"res9\"><input type=\"submit\" value=\"9-bit\"></form>\
	<form action=\"res10\"><input type=\"submit\" value=\"10-bit\"></form>\
	<form action=\"res11\"><input type=\"submit\" value=\"11-bit\"></form>\
	<form action=\"res12\"><input type=\"submit\" value=\"12-bit\"></form>";

char* webpageEnd   = "</body></html>";

//determines whether a given character sequence is in a char array request, returning 1 if present, -1 if not present
int inString(char request[], char des[]) {
	if (strstr(request, des) != NULL) {return 1;}
	return -1;
}

// Turns the LED on/off if a button was pressed; otherwise keeps the current state
int updateLEDStatus(char request[]) {
	int led_status = 0;
	// The request has been received. now process to determine whether to turn the LED on or off
	if (inString(request, "ledoff")==1) {
		digitalWrite(LED_PIN, PIO_LOW);
		led_status = 0;
	}
	else if (inString(request, "ledon")==1) {
		digitalWrite(LED_PIN, PIO_HIGH);
		led_status = 1;
	}
	return led_status;
}

// Returns the requested resolution; checks res10-res12 before res8/res9
int updateResolution(char request[], int current) {
	if (inString(request, "res12") == 1) return 12;
	if (inString(request, "res11") == 1) return 11;
	if (inString(request, "res10") == 1) return 10;
	if (inString(request, "res9")  == 1) return 9;
	if (inString(request, "res8")  == 1) return 8;
	return current;
}

/////////////////////////////////////////////////////////////////
// Solution Functions
/////////////////////////////////////////////////////////////////

int main(void) {
  configureFlash();
  configureClock();

  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);
  gpioEnable(GPIO_PORT_C);

  pinMode(PB3, GPIO_OUTPUT);
  digitalWrite(LED_PIN, PIO_LOW);
  
  RCC->APB2ENR |= (RCC_APB2ENR_TIM15EN);
  initTIM(TIM15);
  
  USART_TypeDef * USART = initUSART(USART1_ID, 125000);

  initSPI(4, 0, 1);
  initDS1722();

  int resolution = 9;
  int led_status = 0;

  while(1) {
      /* Wait for ESP8266 to send a request.
    Requests take the form of '/REQ:<tag>\n', with TAG begin <= 10 characters.
    Therefore the request[] array must be able to contain 18 characters.
    */

    // Receive web request from the ESP
    char request[BUFF_LEN] = {0}; // initialize to known value
    int charIndex = 0;
  
    // Keep going until you get end of line character
    while(inString(request, "\n") == -1) {
      // Wait for a complete request to be transmitted before processing
      while(!(USART->ISR & USART_ISR_RXNE));
      request[charIndex++] = readChar(USART);
    }
	  
    // Update string with current LED state
    int led_status = updateLEDStatus(request);
	
	int newRes = updateResolution(request, resolution);
    if (newRes != resolution) {
      resolution = newRes;
      setResolution(resolution);
      delay_millis(TIM15, 1200);   // wait for a conversion at the new resolution (12-bit max ~1.2 s)
    }

	float temperature = readTemperature();
	
	char temperatureStr[64];
    char ledStatusStr[48];
    char resStatusStr[48];
    sprintf(temperatureStr, "<h2>Temperature</h2><p>%.4f &deg;C</p>", temperature);
    sprintf(ledStatusStr, "<p>LED is %s</p>", led_status ? "on" : "off");
    sprintf(resStatusStr, "<p>Current resolution: %d-bit</p>", resolution);

    // finally, transmit the webpage over UART
    sendString(USART, webpageStart); // webpage header code
    sendString(USART, ledStr); // button for controlling LED
	sendString(USART, resStr);
    sendString(USART, resStatusStr);

    // Display LED status
    sendString(USART, "<h2>LED Status</h2>");
    sendString(USART, "<p>");
    sendString(USART, ledStatusStr);
    sendString(USART, "</p>");

    // Display temperature
    sendString(USART, "<h2>Temperature</h2>");
    sendString(USART, "<p>");
    sendString(USART, temperatureStr);
    sendString(USART, "</p>");

    sendString(USART, webpageEnd);
    }
}
