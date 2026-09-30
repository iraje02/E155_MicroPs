// TIM15.h
// Header for Timer 15 functions
// Ishita Raje
// 9/30/2026

#ifndef STM32L4_TIM15_H
#define STM32L4_TIM15_H

#include <stdint.h>

///////////////////////////////////////////////////////////////////////////////
// Definitions
///////////////////////////////////////////////////////////////////////////////

#define __IO volatile

#define TIM15_BASE (0x40014000UL) // base address of TIM15

typedef struct
{
  __IO uint32_t CR1;          /*!< Address offset: 0x00 */
  __IO uint32_t CR2;          /*!< Address offset: 0x04 */
  __IO uint32_t SMCR;         /*!< Address offset: 0x08 */
  __IO uint32_t DIER;         /*!< Address offset: 0x0C */
  __IO uint32_t SR;           /*!< Address offset: 0x10 */
  __IO uint32_t EGR;          /*!< Address offset: 0x14 */
  __IO uint32_t CCMR1;        /*!< Address offset: 0x18 */
  uint32_t      RESERVED0;    /*!< Address offset: 0x1C */
  __IO uint32_t CCER;         /*!< Address offset: 0x20 */
  __IO uint32_t CNT;          /*!< Address offset: 0x24 */
  __IO uint32_t PSC;          /*!< Address offset: 0x28 */
  __IO uint32_t ARR;          /*!< Address offset: 0x2C */
  __IO uint32_t RCR;          /*!< Address offset: 0x30 */
  __IO uint32_t CCR1;         /*!< Address offset: 0x34 */
  __IO uint32_t CCR2;         /*!< Address offset: 0x38 */
  uint32_t      RESERVED1[2]; /*!< Address offset: 0x3C - 0x40 */
  __IO uint32_t BDTR;         /*!< Address offset: 0x44 */
  __IO uint32_t DCR;          /*!< Address offset: 0x48 */
  __IO uint32_t DMAR;         /*!< Address offset: 0x4C */
  __IO uint32_t OR1;          /*!< Address offset: 0x50 */
  uint32_t      RESERVED2[3]; /*!< Address offset: 0x54 - 0x5C */
  __IO uint32_t OR2;          /*!< Address offset: 0x60 */
} TIM15_TypeDef;

#define TIM15 ((TIM15_TypeDef *) TIM15_BASE)

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////

void TIM15_init(void);
void TIM15_play(int duration_ms); // duration in ms

#endif

