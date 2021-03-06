/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef _CTL_COMM_H
#define _CTL_COMM_H

#include <haka/types.h>
#include <wchar.h>

bool ctl_send_chars(int fd, const char *str);
bool ctl_send_wchars(int fd, const wchar_t *str);
bool ctl_send_int(int fd, int32 i);

char *ctl_recv_chars(int fd);
wchar_t *ctl_recv_wchars(int fd);
int32 ctl_recv_int(int fd);

void ctl_output_redirect_chars(int fd);

bool ctl_expect_chars(int fd, const char *str);

#endif /* _CTL_COMM_H */
