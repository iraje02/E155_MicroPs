// TIM16.h
// Header for Timer 16 functions
// Ishita Raje
// 9/30/2026

#ifndef STM32L4_TIM16_H
#define STM32L4_TIM16_H

#include <stdint.h>

///////////////////////////////////////////////////////////////////////////////
// Definitions
///////////////////////////////////////////////////////////////////////////////

#define __IO volatile

#define TIM16_BASE (0x40014400UL) // base address of TIM16

typedef struct
{
  __IO uint32_t CR1;          /*!< Address offset: 0x00 */
  __IO uint32_t CR2;          /*!< Address offset: 0x04 */
  uint32_t      RESERVED0;    /*!< Address offset: 0x08 */
  __IO uint32_t DIER;         /*!< Address offset: 0x0C */
  __IO uint32_t SR;           /*!< Address offset: 0x10 */
  __IO uint32_t EGR;          /*!< Address offset: 0x14 */
  __IO uint32_t CCMR1;        /*!< Address offset: 0x18 */
  uint32_t      RESERVED1;    /*!< Address offset: 0x1C */
  __IO uint32_t CCER;         /*!< Address offset: 0x20 */
  __IO uint32_t CNT;          /*!< Address offset: 0x24 */
  __IO uint32_t PSC;          /*!< Address offset: 0x28 */
  __IO uint32_t ARR;          /*!< Address offset: 0x2C */
  __IO uint32_t RCR;          /*!< Address offset: 0x30 */
  __IO uint32_t CCR1;         /*!< Address offset: 0x34 */
  uint32_t      RESERVED2[3]; /*!< Address offset: 0x38 - 0x40 */
  __IO uint32_t BDTR;         /*!< Address offset: 0x44 */
  __IO uint32_t DCR;          /*!< Address offset: 0x48 */
  __IO uint32_t DMAR;         /*!< Address offset: 0x4C */
  __IO uint32_t OR1;          /*!< Address offset: 0x50 */
  uint32_t      RESERVED3[3]; /*!< Address offset: 0x54 - 0x5C */
  __IO uint32_t OR2;          /*!< Address offset: 0x60 */
} TIM16_TypeDef;

#define TIM16 ((TIM16_TypeDef *) TIM16_BASE)

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////

void TIM16_init(void);
void TIM16_play(int frequency); // frequency in Hz

#endif

