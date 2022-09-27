// RGBDS/SDCC interop testing
// Joe Kennedy 2022

// This specifies the name of the section in which the code and const data will be placed
// If this isn't specified, the section will default to "_CODE"
// This name (prefixed with a _) can be used in the linkerscript
// to place code into different banks
#pragma codeseg TEST_C

// some basic types
typedef unsigned char uint8_t;
typedef signed char int8_t;
typedef unsigned short uint16_t;
typedef signed short int16_t;

// pointers into VRAM
#define MAPDATA ((uint8_t *)0x9800)
#define TILEDATA ((uint8_t *)0x9000)

// some globals and consts
uint8_t blacktile;
const uint8_t tileconst = 2;

// functions which will be implemented in asm
// extern basically says we haven't defined these here
// but they'll be available at the linker stage
extern void EnableLCD();
extern void DisableLCD();
extern void SetBGPalette(uint8_t pal);

// accessing data in the rom which was defined in the asm file
extern const uint8_t test_tile[16];

// Puts some tile data in tiles 0,1,2 and fills the tilemap with
// a checkerboard of tiles 0 and 1
void init_tiles()
{
    static uint16_t i;

    // calling an asm function
    DisableLCD();
    
    // tile 0 - vertical lines
    for (i = 0; i < 16; i++)
    {
        TILEDATA[i] = (i & 1) ? 0xaa : 0x00;
    }

    // tile 1 - data from rom, defined in the asm file
    for (i = 16; i < 32; i++)
    {
        TILEDATA[i] = test_tile[i - 16];
    }

    // tile 2 - pure black
    // value of blacktile will be set in asm
    for (i = 32; i < 48; i++)
    {
        TILEDATA[i] = blacktile;
    }

    // checkerboard
    for (i = 0; i < 1024; i++)
    {
        MAPDATA[i] = (i + (i >> 5)) & 1;
    }    

    // calling an asm function with a parameter
    SetBGPalette(0xE4);

    // calling an asm function
    EnableLCD();
}

// set tilemap tile at [x, y] to tile
// on the asm side, this will expect:
// x in register a, y in register e, tile on the stack
void set_tile(uint8_t x, uint8_t y, uint8_t tile)
{
    static uint16_t offset;

    DisableLCD();

    offset = x + (y << 5);
    MAPDATA[offset] = tile;
    
    EnableLCD();
}

// set tilemap tile by offset into memory rather than x, y
// __sdcccall(0) makes this only use the stack for parameters
// rather than using registers too
void set_tile_by_offset(uint16_t offset, uint8_t tile)  __sdcccall(0)
{
    DisableLCD();

    MAPDATA[offset] = tile;
    
    EnableLCD();
}