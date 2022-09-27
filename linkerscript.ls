ROM0
    org $100
    "Header"

    org $150
    "Code"

    ; default SDCC code and const data sections
    "_INITIALIZER"
    "_CODE"
    "_HOME"

; As a demonstration, putting the compiled code from test.c into ROM bank 2
; For smaller projects you could just keep this in ROM0/ROM1
ROMX 2

    ; SDCC code and const data from test.c
    "_TEST_C"


WRAM0
    ; SDCC ram sections
    "_INITIALIZED"
    "_DATA"
    "_GSINIT"
    "_GSFINAL"