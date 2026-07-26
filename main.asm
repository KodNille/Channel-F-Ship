        processor f8
        include "ves.h"

        org $0800
        CARTRIDGE_START
        CARTRIDGE_INIT

PLAYER_COLOR = COLOR_RED

PLAYER_MOVE_DELAY_SECOND_SVALUE = 255
PLAYER_MOVE_DELAY_MAIN_SVALUE = 2

PLAYER_BANK = 3
PLAYER_X_POS = 1
PLAYER_Y_POS = 2
PLAYER_MOVE_DELAY_SECOND = 3
PLAYER_MOVE_DELAY_MAIN = 4
PLAYER_1_JOYSTICK = 5
PLAYER_X_POS_NEXT = 6
PLAYER_Y_POS_NEXT = 7

MISSLE_BANK = 4

MISSLE_Y_POS = 0
MISSLE_X_POS = 1
MISSLE_STATUS = 2


SET_DEFAULTS:
setbackground:
        li BK_COLOR_BLUE
        lr 3,a
        pi BIOS_CLEAR_SCREEN
setPlayerXpos:
        lisu PLAYER_BANK
        lisl PLAYER_X_POS
        li 55
        lr s,a
        lisl PLAYER_X_POS_NEXT
        lr s,a
setPlayerYpos
        lisl PLAYER_Y_POS
        li 52
        lr s,a
setMoveDelay:
        lisl PLAYER_MOVE_DELAY_SECOND
        li PLAYER_MOVE_DELAY_SECOND_SVALUE
        lr s,a
        lisl PLAYER_MOVE_DELAY_MAIN
        li PLAYER_MOVE_DELAY_MAIN_SVALUE
        lr s,a
renderStartPlayer:
        li PLAYER_COLOR
        lr 8,a
        pi SUB_renderplayer

MAIN_LOOP:
readInputSaveInA:
        clr
        outs 0
        outs 1
        ins 1
        com
        lisl PLAYER_1_JOYSTICK
        lr s,a
checkIfAnyMove:
        ni %00000011
        bz MAIN_LOOP
delayChecks:
        lisl PLAYER_MOVE_DELAY_SECOND
        lr a,s
        ai $ff
        lr s,a
        ci 0
        bnz MAIN_LOOP
        li PLAYER_MOVE_DELAY_SECOND_SVALUE
        lr s,a
        lisl PLAYER_MOVE_DELAY_MAIN
        lr a,s 
        ai $ff
        lr s,a
        ci 0
        bnz MAIN_LOOP
        li PLAYER_MOVE_DELAY_MAIN_SVALUE
        lr s,a
checkJoystickRight:
        lisl PLAYER_1_JOYSTICK
        lr a,s
        ni %00000001
        bz checkJoystickLeft
        lisl PLAYER_X_POS
        lr a,s
        ci 95
        bz checkJoystickLeft
        
        lisl PLAYER_X_POS
        lr a,s
        inc
        lisl PLAYER_X_POS_NEXT
        lr s,a
checkJoystickLeft:
        lisl PLAYER_1_JOYSTICK
        lr a,s
        ni %00000010
        bz clearPlayerPixels
        lisl PLAYER_X_POS
        lr a,s
        ci 10
        bz clearPlayerPixels

        lisl PLAYER_X_POS
        lr a,s
        ai $ff
        lisl PLAYER_X_POS_NEXT
        lr s,a
clearPlayerPixels:
        li COLOR_BACKGROUND
        lr 8,a
        pi SUB_renderplayer

        lisl PLAYER_X_POS_NEXT
        lr a,s
        lisl PLAYER_X_POS
        lr s,a
renderNewPlayerPos:
        li PLAYER_COLOR
        lr 8,a
        pi SUB_renderplayer
checkFire:
        lisl MISSLE_STATUS
        lr a,s
        ni %00000001
        bnz renderMissle
        ins 1
        ni %10000000
        bz MAIN_LOOP
        
renderMissle:






        br MAIN_LOOP







SUBS:
SUB_renderplayer:
        lisu PLAYER_BANK
setColor:
        lr a,8
        outs 1
setXCounter:
        li 0
        lr 9,a
setYCounter:
        li 0
        lr 10,a
loadPositions:
        lisl PLAYER_X_POS
        lr a,s
        lr 11,a
        lisl PLAYER_Y_POS
        lr a,s
        lr 12,a
loadBitMapStartPoint:
        dci SPACESHIP_BITMAP
readNextRow:
        lm 
        lr 6,a
testBit:
        lr a,6
        ni %10000000
        bz increaseCounters
setPixelXpos:
        lr a,9
        as 11
        com
        outs 4
setPixelYPos:
        lr a,10
        as 12
        com 
        ni $3f
        outs 5
render:
        li  $60
        outs 0
        li  $40
        outs 0
increaseCounters:
        lr a,9
        inc
        lr 9,a
        ci 8
        bz prepareNextRow
        bnz shiftBit
shiftBit:
        lr a,6
        sl 1
        lr 6,a
        br testBit
prepareNextRow:
        li 0
        lr 9,a
        lr a,10
        inc
        lr 10,a
        ci 5
        bnz readNextRow
        pop

SPACESHIP_BITMAP:
        .byte %00011000
        .byte %00111100
        .byte %00111100
        .byte %11111111
        .byte %00111100


        org $1FFF
        .byte $FF