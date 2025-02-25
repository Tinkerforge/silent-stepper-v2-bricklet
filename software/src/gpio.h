/* silent-stepper-v2-bricklet
 * Copyright (C) 2020-2021 Olaf Lüke <olaf@tinkerforge.com>
 *
 * gpio.h: Driver for GPIO inputs/interrupts
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */


#ifndef GPIO_H
#define GPIO_H

#include <stdint.h>
#include <stdbool.h>

#define GPIO_CHANNEL_NUM 2

typedef struct {
	uint16_t debounce[GPIO_CHANNEL_NUM];
	uint16_t stop_deceleration[GPIO_CHANNEL_NUM];
    uint32_t action[GPIO_CHANNEL_NUM];

	uint32_t last_interrupt_time[GPIO_CHANNEL_NUM];
	bool last_interrupt_value[GPIO_CHANNEL_NUM];

	bool stop_normal;
	bool stop_emergency;

	bool new_callback;
} GPIO;

extern GPIO gpio;

void gpio_init(void);
void gpio_tick(void);
void gpio_check(void);

#endif