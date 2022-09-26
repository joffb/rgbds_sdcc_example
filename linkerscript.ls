ROM0
    org $100
    "Header"

    org $150
    "Code"

    ; SDCC code and const data sections
    "_INITIALIZER"
    "_CODE"
    "_HOME"

WRAM0
    ; SDCC ram sections
    "_INITIALIZED"
    "_DATA"
    "_GSINIT"
    "_GSFINAL"