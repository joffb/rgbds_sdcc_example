if not exist obj mkdir obj

@REM compile test.c
sdcc -c test.c -msm83 -o obj\test.o

@REM assemble main.asm
@REM   -E is required to export symbols like _EnableLCD which 
@REM   aren't used in the asm code but are used in the C code
..\rgbds\rgbasm -E -v -o obj\main.o main.s

@REM link files together
..\rgbds\rgblink -v -d -n rgbds_sdcc.sym -l linkerscript.ls -o rgbds_sdcc.gb obj\main.o obj\test.o

@REM properly set up the rom
@REM using MBC5 so we can use banks
..\rgbds\rgbfix -v -l 0x33 -p 255 -m MBC5 -t rgbds_sdcc rgbds_sdcc.gb