        processor f8
        include "ves.h"

        org $0800
        CARTRIDGE_START
        CARTRIDGE_INIT

PLAYER_COLOR = COLOR_RED
PLAYER_MOVE_DELAY_SECOND_SVALUE = 255
PLAYER_MOVE_DELAY_MAIN_SVALUE = 2
MISSILE_MOVE_DELAY_MAIN_SVALUE = 2
MISSILE_MOVE_DELAY_SECOND_SVALUE = 255
MISSILE_START_X_OFFSET = 3
MISSILE_START_Y_VALUE = 48

PLAYER_BANK = 3
PLAYER_X_POS = 1
PLAYER_Y_POS = 2
PLAYER_MOVE_DELAY_SECOND = 3
PLAYER_MOVE_DELAY_MAIN = 4
PLAYER_1_JOYSTICK = 5
PLAYER_X_POS_NEXT = 6
PLAYER_Y_POS_NEXT = 7

MISSILE_BANK = 4
MISSILE_Y_POS = 0
MISSILE_X_POS = 1
MISSILE_STATUS = 2
MISSILE_MOVE_DELAY_SECOND = 3
MISSILE_MOVE_DELAY_MAIN = 4


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
setMissileMoveDelay:
        lisu MISSILE_BANK
        lisl MISSILE_MOVE_DELAY_MAIN
        li MISSILE_MOVE_DELAY_MAIN_SVALUE
        lr s,a 
        lisl MISSILE_MOVE_DELAY_SECOND
        li MISSILE_MOVE_DELAY_SECOND_SVALUE
        lr s,a 
renderStartPlayer:
        li PLAYER_COLOR
        lr 8,a
        pi SUB_renderplayer

MAIN_LOOP:
        lisu PLAYER_BANK
readInputAndSave:
        clr
        outs 0
        outs 1
        ins 1
        com
        lisl PLAYER_1_JOYSTICK
        lr s,a
checkIfAnyMove:
        ni %00000011
        bz checkIfmissileFired
delayChecks:
        lisl PLAYER_MOVE_DELAY_SECOND
        lr a,s
        ai $ff
        lr s,a
        ci 0
        bnz jumpToMissleKernel
        li PLAYER_MOVE_DELAY_SECOND_SVALUE
        lr s,a
        lisl PLAYER_MOVE_DELAY_MAIN
        lr a,s 
        ai $ff
        lr s,a
        ci 0
        bnz jumpToMissleKernel
        li PLAYER_MOVE_DELAY_MAIN_SVALUE
        lr s,a
        br checkJoystickRight
jumpToMissleKernel:
        jmp MISSILE_KERNEL
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
MISSILE_KERNEL:
checkIfmissileFired:
        lisu MISSILE_BANK
        lisl MISSILE_STATUS
        lr a,s
        ni %00000001
        bnz renderMissile
checkFireButton:
        lisu PLAYER_BANK
        lisl PLAYER_1_JOYSTICK
        lr a,s
        ni %00000100
        bz MAIN_LOOP
loadPlayerPosForRef:
        lisl PLAYER_X_POS
        lr a,s 
        ai MISSILE_START_X_OFFSET
        lisu MISSILE_BANK
        lisl MISSILE_X_POS
        lr s,a
        li MISSILE_START_Y_VALUE
        lisl MISSILE_Y_POS
        lr s,a
        lisl MISSILE_STATUS
        lr a,s
        oi %00000001
        lr s,a 
renderMissile:
        li  COLOR_BLUE
        outs 1
        lisl MISSILE_X_POS
        lr a,s 
        com
        outs 4
        lisl MISSILE_Y_POS
        lr a,s
        com 
        ni $3f
        outs 5
        li  $60
        outs 0
        li  $40
        outs 0
checkMissileDelay:
        lisl MISSILE_MOVE_DELAY_SECOND
        lr a,s 
        ai $ff 
        lr s,a 
        ci 0
        bnz gobacK
        li MISSILE_MOVE_DELAY_SECOND_SVALUE
        lr s,a 
        lisl MISSILE_MOVE_DELAY_MAIN
        lr a,s 
        ai $ff 
        lr s,a 
        ci 0
        bnz gobacK
        li MISSILE_MOVE_DELAY_MAIN_SVALUE
        lr s,a 
moveMissile:
removeOld:
        li COLOR_BACKGROUND
        outs 1
        lisl  MISSILE_X_POS
        lr a,s 
        com
        outs 4
        lisl  MISSILE_Y_POS
        lr a,s 
        com
        ni  $3f
        outs 5
        li  $60
        outs 0
        li  $40
        outs 0
moveUp:
        lisl MISSILE_Y_POS
        lr a,s 
        ai $ff 
        lr s,a 
gobacK:
        jmp MAIN_LOOP







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
        ci 6
        bnz readNextRow
        pop

SPACESHIP_BITMAP:
        .byte %00011000
        .byte %00111100
        .byte %01111110
        .byte %11111111
        .byte %11111111
        .byte %00111100


        org $1FFF
        .byte $FF
