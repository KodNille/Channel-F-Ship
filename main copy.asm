        processor f8
        include "ves.h"

        org $0800
        CARTRIDGE_START
        CARTRIDGE_INIT

        li  $c0
        lr  3, A
        pi  BIOS_CLEAR_SCREEN

.loop:
        br  .loop

        org $0FFF
        .byte $FF