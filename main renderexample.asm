        processor f8
        include "ves.h"

        org $0800
        CARTRIDGE_START
        CARTRIDGE_INIT

        ; Rensa skärmen
        li  $c0
        lr  3, A
        pi  BIOS_CLEAR_SCREEN

        ; Blå pixel
        li  COLOR_BLUE
        outs 1

        ; X = 55, mitten av den synliga bilden
        li  55
        com
        outs 4

        ; Y = 33, mitten av den synliga bilden
        li  33
        com
        ni  $3f
        outs 5

        ; Skriv pixeln
        li  $60
        outs 0
        li  $40
        outs 0

.loop:
        br  .loop

        org $0FFF
        .byte $FF