/*
 * This file is part of AJAMI.
 *
 * Copyright (C) 2003 Jack O'Quin
 * Copyright (C) 2014 Victor A. Santos <victoraur.santos@gmail.com>
 *
 * This software is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#ifndef JACKSTATUS_H
#define JACKSTATUS_H

#include <jack/transport.h>

typedef struct {
    int            realtime;
    int            active;
    int            xruns;
    float          cpu_load;
    jack_nframes_t sample_rate;
    jack_nframes_t buf_size;
    jack_nframes_t latency;
} io_jack_status_t;

void io_get_status(io_jack_status_t *jp);

#endif
