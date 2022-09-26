; RGBDS/SDCC interop testing
; Joe Kennedy 2022

include "hardware.inc"

SECTION "Header", ROM0
    nop
    jp EntryPoint

SECTION "Code", ROM0

; Tile data which will be read in test.c
; The label name is prefixed with a _ so it will link properly to the C definition
; The definition in test.c is
;    extern const uint8_t test_tile[16];
; which says there's an external symbol named test_tile which will be provided at the linker stage
; When the C file is compiled, that symbol name will become _test_tile,
; so the name in asm needs to match that for the linker to link them
_test_tile:
    db $cc, $b3, $ff, $cc, $b3, $ff, $cc, $b3
    db $ff, $cc, $b3, $ff, $cc, $b3, $ff, $cc

EntryPoint:
    nop

    ; set the value of the blacktile global which is defined in test.c
    ld a, $ff
    ld [_blacktile], a

    ; Call our c function
    ; Note that the label is the C function's name prefixed by a _
    call _init_tiles

    ; When calling c functions with parameters
    ; refer to sdcc manual section "4.3.5 SM83 calling conventions"
    ; Depending on the type/number of parameters,
    ; the parameters are passed along in different registers and on the stack
    ; e.g. If the first two parameters are 1 byte each in size, the code will
    ; expect them in the a and e registers, and expect a third param on the stack

    ; Set the tile at [4,6] to 2
    ;
    ; x, first param
    ld a, 4
    ; y, second param
    ld e, 6
    ; tile, third param, goes on stack
    ld bc, 2
    push bc
    call _set_tile

    ; set the tile at [5,7] to the value of _tileconst as defined in test.c
    ;
    ; tile, third param, using a C constant (done first so we can use register a)
    ld a, [_tileconst]
    ld c, a
    ld b, 0
    push bc
    ; x, first param
    ld a, 5
    ; y, second param
    ld e, 7
    call _set_tile

    ; As described in the sdcc manual, you can also use the __sdcccall(0) directive 
    ; in the function definition to set it to only use the stack instead of registers
    ; See the definition of _set_tile_by_offset in test.c for an example

    ; Set the tile at offset $0106 (xy equivalent of [6,8]) to 2
    ;
    ; tile, second param
    ld bc, 2
    push bc
    ; offset, first param, this is a 16-bit offset into the tilemap
    ld bc, $0106
    push bc
    call _set_tile_by_offset

    nop
    halt
    nop

; Functions which will be called from C
; Labels must be the C function name preceded by a _ to link properly
; e.g.
;     extern void EnableLCD();
; will expect to see a symbol called _EnableLCD at the linker stage

; Switch on lcd
_EnableLCD:
    ld a, (LCDCF_ON | LCDCF_BGON | LCDCF_BG9800 | LCDCF_BG8800)
    ld [rLCDC], a
    ret

; Switch off lcd
_DisableLCD:
    ld a, 0
    ld [rLCDC], a
    ret

; Set the backgound palette
; This is called from C, which puts the first parameter into register a (when it's 1 byte in size)
; Again, refer to sdcc manual section "4.3.5 SM83 calling conventions" 
_SetBGPalette:
    ld [rBGP], a
    ret