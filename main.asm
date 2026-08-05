        processor f8
        include "ves.h"

        org $0800
        CARTRIDGE_START
        CARTRIDGE_INIT

TICK_COUNTER_START_VALUE = 255

PLAYER_COLOR_VALUE = COLOR_RED
BACKGROUND_COLOR_VALUE = BK_COLOR_GREEN
PLAYER_MOVE_TICKDELAY_SVALUE = 1
MISSILE_MOVE_TICKDELAY_SVALUE = 2
MISSILE_START_X_OFFSET_VALUE = 3
MISSILE_START_Y_OFFSET_VALUE = 48
SPACESHIP_SIZE = 4

MAIN_BANK = 2
TICK_COUNTER = 0

PLAYER_BANK = 3
PLAYER_STATUS = 0
PLAYER_X_POS = 1
PLAYER_Y_POS = 2
PLAYER_MOVE_TICKDELAY = 3
PLAYER_1_JOYSTICK = 5

MISSILE_BANK = 4
MISSILE_STATUS = 0
MISSILE_X_POS = 1
MISSILE_Y_POS = 2
MISSILE_MOVE_TICKDELAY = 3


DEFAULTS:
DEFAULTS_setbackground:
        li BK_COLOR_BLUE
        lr 3,a
        pi BIOS_CLEAR_SCREEN
DEFAULTS_setPlayerXpos:
        lisu PLAYER_BANK
        lisl PLAYER_X_POS
        li 55
        lr s,a
DEFAULTS_setPlayerYpos
        lisl PLAYER_Y_POS
        li 52
        lr s,a
DEFAULTS_setMoveDelay:
        lisl PLAYER_MOVE_TICKDELAY
        li PLAYER_MOVE_TICKDELAY_SVALUE
        lr s,a
DEFAULTS_setMissileMoveDelay:
        lisu MISSILE_BANK
        lisl MISSILE_MOVE_TICKDELAY
        li MISSILE_MOVE_TICKDELAY_SVALUE
        lr s,a 
DEFAULTS_setTickCounter:
        lisu MAIN_BANK
        lisl TICK_COUNTER
        li TICK_COUNTER_START_VALUE
        lr s,a 
DEFAULTS_renderStartPlayer:
        li PLAYER_COLOR_VALUE
        lr 8,a
        pi SUB_renderplayer





MAIN:
MAIN_readInput:
        jmp INPUT
MAIN_spawnPlayerMissile:
        jmp MISSILE
MAIN_updateTick:
        jmp TICK
MAIN_playerMovement:
        jmp SHIP
MAIN_moveMissile:
        jmp MOVEMISSILE





INPUT:
INPUT_readAndSaveInput:
        lisu PLAYER_BANK
        clr
        outs 0
        outs 1
        ins 1
        com
        lisl PLAYER_1_JOYSTICK
        lr s,a
        br MAIN_spawnPlayerMissile





TICK:
TICK_updateTick:
        lisu MAIN_BANK
        lisl TICK_COUNTER
        lr a,s 
        ai $ff 
        lr s,a 
        bnz MAIN
TICK_triggerTick:
        li TICK_COUNTER_START_VALUE
        lr s,a 
        br MAIN_playerMovement






MISSILE:
MISSILE_checkIfmissileFired:
        lisu MISSILE_BANK
        lisl MISSILE_STATUS
        lr a,s
        ni %00000001
        bnz MAIN_updateTick
MISSILE_checkFireButton:
        lisu PLAYER_BANK
        lisl PLAYER_1_JOYSTICK
        lr a,s
        ni %00000100
        bz MAIN_updateTick
MISSILE_setMissileSpawnPos:
        lisl PLAYER_X_POS
        lr a,s 
        ai MISSILE_START_X_OFFSET_VALUE
        lisu MISSILE_BANK
        lisl MISSILE_X_POS
        lr s,a
        li MISSILE_START_Y_OFFSET_VALUE
        lisl MISSILE_Y_POS
        lr s,a
        lisl MISSILE_STATUS
        lr a,s
        oi %00000001
        lr s,a 
MISSILE_renderMissile:
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
        jmp MAIN_updateTick



SHIP:
SHIP_checkIfAnyMove:
        lisu PLAYER_BANK
        lisl PLAYER_1_JOYSTICK
        lr a,s 
        ni %00000011
        bz SHIP_done
SHIP_delayCheck:
        lisl PLAYER_MOVE_TICKDELAY
        lr a,s 
        ai $ff 
        lr s,a 
        bnz SHIP_done
        li PLAYER_MOVE_TICKDELAY_SVALUE
        lr s,a 
SHIP_checkJoystickRight:
        lisl PLAYER_1_JOYSTICK
        lr a,s
        ni %00000001
        bz SHIP_moveLeft
SHIP_right_blankLeft:
        dci SPACESHIP_LEFT 
        li COLOR_BACKGROUND 
        lr 8,a 
        lisl PLAYER_X_POS 
        lr a,s 
        lr 9,a 
        lisl PLAYER_Y_POS 
        lr a,s 
        lr 10,a  
        li SPACESHIP_SIZE 
        lr 11,a 
        pi SUB_DRAW_SIDE 
SHIP_right_updatePos:
        lisl PLAYER_X_POS
        lr a,s 
        inc 
        lr s,a 
SHIP_right_drawRight:
        dci SPACESHIP_RIGHT
        li COLOR_RED 
        lr 8,a 
        lisl PLAYER_X_POS 
        lr a,s 
        lr 9,a 
        lisl PLAYER_Y_POS
        lr a,s  
        lr 10,a  
        li SPACESHIP_SIZE 
        lr 11,a 
        pi SUB_DRAW_SIDE 
        br SHIP_done
SHIP_moveLeft:
SHIP_left_blankRight:
        dci SPACESHIP_RIGHT 
        li COLOR_BACKGROUND 
        lr 8,a 
        lisl PLAYER_X_POS 
        lr a,s 
        lr 9,a  
        lisl PLAYER_Y_POS 
        lr a,s 
        lr 10,a  
        li SPACESHIP_SIZE 
        lr 11,a 
        pi SUB_DRAW_SIDE 
SHIP_left_updatePos:
        lisl PLAYER_X_POS
        lr a,s 
        ai $ff 
        lr s,a 
SHIP_left_drawLeft:
        dci SPACESHIP_LEFT
        li COLOR_RED 
        lr 8,a 
        lisl PLAYER_X_POS 
        lr a,s 
        lr 9,a  
        lisl PLAYER_Y_POS 
        lr a,s 
        lr 10,a  
        li SPACESHIP_SIZE 
        lr 11,a 
        pi SUB_DRAW_SIDE 
        br SHIP_done
SHIP_done:
        jmp MAIN








MOVEMISSILE:
MOVEMISSILE_checkMissileDelay:
        lisu MISSILE_BANK
        lisl MISSILE_MOVE_TICKDELAY
        lr a,s 
        ai $ff 
        bnz gobacK
MOVEMISSILE_resetTickDelay:
        li MISSILE_MOVE_TICKDELAY_SVALUE
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
        jmp MAIN







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
        ci 4
        bnz readNextRow
        pop







SUB_DRAW_SIDE:
SUB_DRAW_SIDE_setPixelColor:
        lr a,8
        outs 1 
SUB_DRAW_SIDE_newRow:
SUB_DRAW_SIDE_setYPos:
        lr a,10
        com
        ni  $3f
        outs 5
SUB_DRAW_SIDE_setXPos:
        lm 
        as 9
        com
        outs 4
SUB_DRAW_SIDE_draw:
        li  $60
        outs 0
        li  $40
        outs 0
SUB_DRAW_SIDE_reduceIndex:
        lr a,11
        ai $ff 
        lr 11,a 
        bz SUB_DRAW_SIDE_done
SUB_DRAW_SIDE_prepareNext:
        lr a,10 
        inc
        lr 10,a 
        br SUB_DRAW_SIDE_newRow
SUB_DRAW_SIDE_done:
        pop 





SPACESHIP_BITMAP:
        .byte %00011000
        .byte %00111100
        .byte %01111110
        .byte %11111111
SPACESHIP_LEFT:
        .byte 3
        .byte 2
        .byte 1
        .byte 0
SPACESHIP_RIGHT:
        .byte 4
        .byte 5
        .byte 6
        .byte 7



        org $1FFF
        .byte $FF
