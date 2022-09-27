ROM0
    org $100
    "Header"

    org $150
    "Code"

    ; SDCC code and const data section
    "_CODE"

    ; default SDCC sections
    "_INITIALIZER"
    "_HOME"

WRAM0
    ; SDCC ram section
    "_DATA"

    ; default SDCC sections
    "_INITIALIZED"
    "_GSINIT"
    "_GSFINAL"